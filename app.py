import os
from datetime import timedelta
import pymysql

from flask import Flask, render_template, request, jsonify, session, redirect, abort
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename

# ================== CONFIG ==================
MYSQL_HOST = os.getenv("MYSQL_HOST", "127.0.0.1")
MYSQL_PORT = int(os.getenv("MYSQL_PORT", "3306"))
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASS = os.getenv("MYSQL_PASS", "")
MYSQL_DB   = os.getenv("MYSQL_DB", "truyen_tranh")

DEFAULT_AVT = "/static/img/default-avatar.png"

UPLOAD_FOLDER = os.path.join("static", "uploads")
ALLOWED_EXTS = {"png", "jpg", "jpeg", "gif"}

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET", "super-secret-change-this")
app.permanent_session_lifetime = timedelta(days=7)

# ================== DB UTILS ==================
def get_conn():
    return pymysql.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASS,
        database=MYSQL_DB,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True,
    )

def init_db():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(100) UNIQUE,
                email VARCHAR(255) UNIQUE,
                password_hash VARCHAR(255),
                avatar_url VARCHAR(500) DEFAULT '/static/img/default-avatar.png',
                phone VARCHAR(20) NULL,
                bio TEXT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            """)

# ================== HELPERS ==================
def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTS

# ================== ROUTES ==================
# @app.route("/")
# def home():
#     with get_conn() as conn:
#         with conn.cursor() as cur:
#             # chỉ lấy những truyện mới thêm sau id 15 (ví dụ)
#             cur.execute("""
#                 SELECT id, title, slug, cover_url, latest_chapter, updated_at
#                 FROM comics
#                 WHERE id > 21
#                 ORDER BY updated_at DESC
#             """)
#             new_comics = cur.fetchall()
#     return render_template("index.html", comics=new_comics)




# ---------- Auth ----------
@app.route("/api/register", methods=["POST"])
def api_register():
    data = request.get_json(force=True)
    username = (data.get("username") or "").strip()
    email    = (data.get("email") or "").strip()
    password = (data.get("password") or "").strip()

    if not username or not email or not password:
        return jsonify({"ok": False, "msg": "Thiếu dữ liệu."}), 400

    pw_hash = generate_password_hash(password)

    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                # trùng tên/email?
                cur.execute("SELECT id FROM users WHERE username=%s OR email=%s", (username, email))
                if cur.fetchone():
                    return jsonify({"ok": False, "msg": "Username hoặc email đã tồn tại."}), 409

                # luôn set avatar mặc định
                cur.execute("""
                    INSERT INTO users(username, email, password_hash, avatar_url)
                    VALUES (%s,%s,%s,%s)
                """, (username, email, pw_hash, DEFAULT_AVT))
                uid = cur.lastrowid

        session.permanent = True
        session["user_id"] = uid
        session["username"] = username
        session["role"]     = "user"
        return jsonify({"ok": True, "msg": "Đăng ký thành công.",
                        "user": {"id": uid, "username": username, "email": email, "avatar_url": DEFAULT_AVT, "role": "user"}})
    except pymysql.err.IntegrityError:
        return jsonify({"ok": False, "msg": "Username hoặc email đã tồn tại."}), 409

@app.route("/api/login", methods=["POST"])
def api_login():
    data = request.get_json(force=True)
    identifier = (data.get("identifier") or "").strip()
    password   = (data.get("password") or "").strip()
    if not identifier or not password:
        return jsonify({"ok": False, "msg": "Thiếu dữ liệu."}), 400

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, username, email, password_hash, avatar_url, role
                FROM users
                WHERE username=%s OR email=%s
                LIMIT 1
            """, (identifier, identifier))
            row = cur.fetchone()

    if not row:
        return jsonify({"ok": False, "msg": "Tài khoản không tồn tại."}), 404
    if not check_password_hash(row["password_hash"], password):
        return jsonify({"ok": False, "msg": "Mật khẩu sai."}), 401

    # nếu vì lý do gì avatar_url bị NULL -> set mặc định cho chắc
    if not row.get("avatar_url"):
        row["avatar_url"] = DEFAULT_AVT
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE users SET avatar_url=%s WHERE id=%s", (DEFAULT_AVT, row["id"]))

    session.permanent = True
    session["user_id"] = row["id"]
    session["username"] = row["username"]
    session["role"]     = row["role"] or "user"
    return jsonify({"ok": True, "msg": f"Xin chào {row['username']}!",
                    "user": {"id": row["id"], "username": row["username"],
                             "email": row["email"], "avatar_url": row["avatar_url"], "role": row["role"]}})

@app.route("/api/logout", methods=["POST"])
def api_logout():
    session.clear()
    return jsonify({"ok": True, "msg": "Đã đăng xuất.", "user": None})

@app.route("/api/me")
def api_me():
    if "user_id" not in session:
        return jsonify({"ok": True, "user": None})
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, username, email, avatar_url, phone, bio, role    
                FROM users WHERE id=%s LIMIT 1
            """, (session["user_id"],))
            row = cur.fetchone()
    # đảm bảo luôn có avatar mặc định
    if row and not row.get("avatar_url"):
        row["avatar_url"] = DEFAULT_AVT
    return jsonify({"ok": True, "user": row})

# ---------- Profile ----------
@app.route("/profile")
def profile_page():
    if "user_id" not in session:
        return redirect(url_for("home"))
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM users WHERE id=%s", (session["user_id"],))
            me = cur.fetchone()
    return render_template("profile.html", user=me)


from flask import redirect, url_for

@app.route("/api/profile/update", methods=["POST"])
def api_profile_update():
    if "user_id" not in session:
        return redirect(url_for("home"))

    username = request.form.get("username")
    phone    = request.form.get("phone")
    bio      = request.form.get("bio")
    avatar   = request.files.get("avatar")

    avatar_url = None
    if avatar and allowed_file(avatar.filename):
        os.makedirs(UPLOAD_FOLDER, exist_ok=True)
        fname = secure_filename(f"u{session['user_id']}_{avatar.filename}")
        save_path = os.path.join(UPLOAD_FOLDER, fname)
        avatar.save(save_path)
        avatar_url = f"/static/uploads/{fname}"

    with get_conn() as conn:
        with conn.cursor() as cur:
            if avatar_url:
                cur.execute(
                    "UPDATE users SET username=%s, phone=%s, bio=%s, avatar_url=%s WHERE id=%s",
                    (username, phone, bio, avatar_url, session["user_id"])
                )
            else:
                cur.execute(
                    "UPDATE users SET username=%s, phone=%s, bio=%s WHERE id=%s",
                    (username, phone, bio, session["user_id"])
                )

    # Cập nhật session ngay để index lấy dữ liệu mới
    if username:
        session["username"] = username
    if avatar_url:
        session["avatar_url"] = avatar_url

    # Quay về trang chủ
    return redirect(url_for("home"))






# nút con gái
from datetime import datetime
from flask import request

def humanize_delta(dt):
    # trả “X phút/giờ/ngày trước”
    if not dt: return ""
    sec = int((datetime.now() - dt).total_seconds())
    if sec < 3600:  # <1h
        m = max(1, sec // 60)
        return f"{m} phút trước"
    if sec < 86400: # <1d
        h = sec // 3600
        return f"{h} giờ trước"
    d = sec // 86400
    return f"{d} ngày trước"

@app.route("/con-gai")
def page_con_gai():
    status = request.args.get("status")   # ongoing|completed|None
    country = request.args.get("country") # Trung Quốc|Việt Nam|...|None
    sort = request.args.get("sort", "new")  # new|chapter

    sql = "SELECT id, title, cover_url, latest_chapter, updated_at, status, country FROM comics WHERE audience=%s"
    params = ["con_gai"]

    if status in ("ongoing", "completed"):
        sql += " AND status=%s"
        params.append(status)

    if country in ("Trung Quốc","Việt Nam","Hàn Quốc","Nhật Bản","Mỹ"):
        sql += " AND country=%s"
        params.append(country)

    if sort == "chapter":
        sql += " ORDER BY latest_chapter DESC"
    else:
        sql += " ORDER BY updated_at DESC"

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()

    # tính label “x phút/giờ/ngày trước”
    for r in rows:
        r["ago"] = humanize_delta(r["updated_at"])

    filters = {
        "status": status,
        "country": country,
        "sort": sort
    }

    return render_template("con_gai.html", rows=rows, filters=filters)


@app.route("/con-trai")
def con_trai():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM comics WHERE category=%s ORDER BY id DESC", ("Con Trai",))
            rows = cur.fetchall()
    return render_template("con_gai.html", rows=rows, page_title="Truyện Con Trai")









from datetime import datetime

from datetime import datetime
import pymysql

@app.route("/api/history")
def api_history():
    user_id = session.get("user_id")
    if not user_id:
        return jsonify({"ok": False, "msg": "Chưa đăng nhập"})

    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Lấy danh sách truyện đã đọc và chương mới nhất của mỗi truyện
            cur.execute("""
                SELECT 
                    c.id,
                    c.slug,
                    c.title,
                    c.cover_url,
                    (
                        SELECT MAX(ch.number)
                        FROM chapters ch
                        WHERE ch.comic_id = c.id
                    ) AS last_chapter,
                    MAX(h.viewed_at) AS viewed_at
                FROM reading_history h
                JOIN comics c ON h.comic_id = c.id
                WHERE h.user_id = %s
                GROUP BY c.id, c.slug, c.title, c.cover_url
                ORDER BY viewed_at DESC
            """, (user_id,))
            history = cur.fetchall()

    # Đổi kiểu datetime sang chuỗi ISO
    for h in history:
        if isinstance(h["viewed_at"], datetime):
            h["viewed_at"] = h["viewed_at"].isoformat()

    return jsonify({"ok": True, "data": history})






@app.route("/lich-su")
def lich_su_page():
    if "user_id" not in session:
        return redirect("/")
    return render_template("lich_su.html")





    # tính prev/next
    nums = [c["number"] for c in all_chapters]
    idx = nums.index(number)
    prev_num = nums[idx-1] if idx > 0 else None
    next_num = nums[idx+1] if idx < len(nums)-1 else None

    return render_template(
        "reader.html",
        comic=comic,
        chapter=chapter,
        pages=pages,
        chapters=all_chapters,
        prev_num=prev_num,
        next_num=next_num
    )



# Chi tiết truyện theo slug
from flask import abort  # đã import rồi thì bỏ dòng này
@app.route("/truyen/<slug>")
def comic_detail(slug):
    uid = session.get("user_id")  # đã login thì có user_id
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:  # ⚠️ dùng DictCursor để truy cập bằng tên cột
            # Lấy truyện
            cur.execute("SELECT * FROM comics WHERE slug=%s LIMIT 1", (slug,))
            comic = cur.fetchone()
            if not comic:
                abort(404)

            # ⚠️ Kiểm tra truyện bị ẩn
            if comic["is_hidden"]:
                return render_template(
                    "error.html",
                    message="Truyện này hiện đang bị ẩn và không thể truy cập."
                ), 403

            view_count = comic.get("view_count", 0)

            # Danh sách chương
            cur.execute("""
                SELECT id, number, title, created_at
                FROM chapters
                WHERE comic_id=%s
                ORDER BY number ASC
            """, (comic["id"],))
            chapters = cur.fetchall()

            # Thể loại
            cur.execute("""
                SELECT g.id, g.name, g.slug
                FROM genres g
                JOIN comic_genres cg ON cg.genre_id = g.id
                WHERE cg.comic_id = %s
                ORDER BY g.name
            """, (comic["id"],))
            genres = cur.fetchall() or []

            # Trạng thái theo dõi + tổng số người theo dõi
            followed = False
            if uid:
                cur.execute("SELECT 1 FROM follows WHERE user_id=%s AND comic_id=%s LIMIT 1",
                            (uid, comic["id"]))
                followed = cur.fetchone() is not None

            cur.execute("SELECT COUNT(*) AS c FROM follows WHERE comic_id=%s", (comic["id"],))
            follow_count = cur.fetchone()["c"]

            liked = False
            if uid:
                cur.execute("SELECT 1 FROM post_likes WHERE user_id=%s AND comic_id=%s LIMIT 1",
                            (uid, comic["id"]))
                liked = cur.fetchone() is not None

            cur.execute("SELECT COUNT(*) AS c FROM post_likes WHERE comic_id=%s", (comic["id"],))
            like_count = cur.fetchone()["c"]

            cur.execute("SELECT AVG(rating) AS avg_rating, COUNT(*) AS total FROM ratings WHERE comic_id=%s", (comic["id"],))
            rate_info = cur.fetchone() or {"avg_rating": 0, "total": 0}

            # Lấy điểm của user hiện tại (nếu đã đăng nhập)
            user_rating = 0
            if uid:
                cur.execute("SELECT rating FROM ratings WHERE comic_id=%s AND user_id=%s", (comic["id"], uid))
                row = cur.fetchone()
                if row:
                    user_rating = row["rating"]

            return render_template(
                "detail.html",
                comic=comic,
                chapters=chapters,
                followed=followed,
                genres=genres,
                follow_count=follow_count,
                liked=liked,
                like_count=like_count,
                view_count=view_count,
                rate_info=rate_info,
                user_rating=user_rating
            )



# Trang đọc chương theo slug + số chương
# /doc/<slug>/<number>
@app.route("/doc/<slug>/<int:number>")
def read_chapter(slug, number):
    with get_conn() as conn:
        with conn.cursor() as cur:
            # lấy comic
            cur.execute("SELECT id, title, slug FROM comics WHERE slug=%s", (slug,))
            comic = cur.fetchone()
            if not comic: return "Không tìm thấy truyện", 404
            cur.execute("UPDATE comics SET view_count = view_count + 1 WHERE slug=%s", (slug,))

            # lấy chương
            cur.execute("SELECT id, number, title FROM chapters WHERE comic_id=%s AND number=%s",
                        (comic["id"], number))
            chapter = cur.fetchone()
            if not chapter: return "Không tìm thấy chương", 404

            # lấy ảnh
            cur.execute("""SELECT page_number, image_url
                           FROM chapter_images
                           WHERE chapter_id=%s
                           ORDER BY page_number ASC""", (chapter["id"],))
            pages = cur.fetchall()

            # lấy toàn bộ chương để prev/next
            cur.execute("SELECT number, title FROM chapters WHERE comic_id=%s ORDER BY number ASC",
                        (comic["id"],))
            chapters = cur.fetchall()

    # 👉 Ghi lịch sử nếu user đã login
    user_id = session.get("user_id")
    if user_id:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO reading_history(user_id, comic_id, viewed_at)
                    VALUES (%s, %s, NOW())
                """, (user_id, comic["id"]))

    nums = [c["number"] for c in chapters]
    i = nums.index(number) if number in nums else 0
    prev_num = nums[i-1] if i > 0 else None
    next_num = nums[i+1] if i < len(nums)-1 else None

    return render_template("reader.html",
        comic=comic, chapter=chapter, pages=pages,
        chapters=chapters, prev_num=prev_num, next_num=next_num)

# Thể loại
@app.route("/the-loai/<slug>")
def genre_page(slug):
    # lấy info thể loại
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, name, slug FROM genres WHERE slug=%s LIMIT 1", (slug,))
            genre = cur.fetchone()
            if not genre:
                return "Không tìm thấy thể loại", 404

            # lấy danh sách truyện thuộc thể loại này (mới cập nhật trước)
            cur.execute("""
                SELECT c.id, c.title, c.slug, c.cover_url, c.latest_chapter, c.updated_at, c.status, c.country
                FROM comics c
                JOIN comic_genres cg ON cg.comic_id = c.id
                WHERE cg.genre_id = %s
                ORDER BY c.updated_at DESC
            """, (genre["id"],))
            rows = cur.fetchall()

    # gắn nhãn "x giờ trước" nếu bạn muốn (tận dụng helper sẵn có)
    try:
        from datetime import datetime
        for r in rows:
            if r.get("updated_at"):
                # dùng humanize_delta nếu bạn đã có hàm này trong app
                # nếu chưa, có thể bỏ dòng dưới
                r["ago"] = humanize_delta(r["updated_at"])
    except:
        pass

    return render_template("the-loai.html", genre=genre, rows=rows)



from routes_admin import admin_bp
app.register_blueprint(admin_bp, url_prefix='/admin', name='admin')


from flask import g, session

@app.before_request
def load_role():
    # lấy role từ session; mặc định là 'user'
    g.role = session.get('role', 'user')

@app.context_processor
def inject_role():
    # bơm biến vào mọi template
    return {"current_role": g.role}





from flask import jsonify

@app.post("/api/follow/<slug>/toggle")
def toggle_follow(slug):
    uid = session.get("user_id")
    if not uid:
        return jsonify({"ok": False, "error": "NOT_LOGIN"}), 401

    with get_conn() as conn:
        with conn.cursor() as cur:
            # Lấy thêm title để làm message
            cur.execute("SELECT id, title FROM comics WHERE slug=%s LIMIT 1", (slug,))
            row = cur.fetchone()
            if not row:
                return jsonify({"ok": False, "error": "NOT_FOUND"}), 404
            comic_id = row["id"]
            comic_title = row.get("title") or slug.replace("-", " ").title()

            # Kiểm tra đang theo dõi chưa
            cur.execute("SELECT 1 FROM follows WHERE user_id=%s AND comic_id=%s", (uid, comic_id))
            has = cur.fetchone() is not None

            if has:
                cur.execute("DELETE FROM follows WHERE user_id=%s AND comic_id=%s", (uid, comic_id))
                followed = False
            else:
                cur.execute("INSERT INTO follows(user_id, comic_id) VALUES (%s, %s)", (uid, comic_id))
                followed = True
                # 🔔 Ghi thông báo cho chính user vừa ấn theo dõi
                cur.execute(
                    "INSERT INTO notifications (user_id, message) VALUES (%s, %s)",
                    (uid, f"Bạn đã theo dõi truyện {comic_title}")
                )

            # Đếm lại
            cur.execute("SELECT COUNT(*) AS c FROM follows WHERE comic_id=%s", (comic_id,))
            count = cur.fetchone()["c"]
            # Đếm số thông báo chưa đọc cho user hiện tại
            cur.execute("SELECT COUNT(*) AS c FROM notifications WHERE user_id=%s AND is_read=0", (uid,))
            unread = int(cur.fetchone()["c"])


    return jsonify({"ok": True, "followed": followed, "count": count, "unread": unread})


@app.post("/api/like/<slug>/toggle")
def toggle_like(slug):
    uid = session.get("user_id")
    if not uid:
        return jsonify({"ok": False, "error": "NOT_LOGIN"}), 401

    with get_conn() as conn:
        with conn.cursor() as cur:
            # lấy id + title để ghi thông báo đẹp hơn
            cur.execute("SELECT id, title FROM comics WHERE slug=%s LIMIT 1", (slug,))
            row = cur.fetchone()
            if not row:
                return jsonify({"ok": False, "error": "NOT_FOUND"}), 404
            comic_id   = row["id"]
            comic_title= row.get("title") or slug.replace("-", " ").title()

            # đã like chưa?
            cur.execute("SELECT 1 FROM post_likes WHERE user_id=%s AND comic_id=%s",
                        (uid, comic_id))
            has = cur.fetchone() is not None

            if has:
                cur.execute("DELETE FROM post_likes WHERE user_id=%s AND comic_id=%s",
                            (uid, comic_id))
                liked = False
            else:
                cur.execute("INSERT INTO post_likes(user_id, comic_id) VALUES (%s,%s)",
                            (uid, comic_id))
                liked = True
                # 🔔 thêm thông báo cho chính user
                cur.execute(
                    "INSERT INTO notifications (user_id, message) VALUES (%s,%s)",
                    (uid, f"Bạn đã thích truyện {comic_title}")
                )

            # đếm lại
            cur.execute("SELECT COUNT(*) AS c FROM post_likes WHERE comic_id=%s", (comic_id,))
            count = cur.fetchone()["c"]
            # Đếm số thông báo chưa đọc cho user hiện tại
            cur.execute("SELECT COUNT(*) AS c FROM notifications WHERE user_id=%s AND is_read=0", (uid,))
            unread = int(cur.fetchone()["c"])
    return jsonify({"ok": True, "liked": liked, "count": count, "unread": unread})




from flask import render_template, session, redirect, url_for, flash

@app.route("/following")
def following_page():
    uid = session.get("user_id")
    if not uid:
        return redirect(url_for("home"))

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                  c.id, c.title, c.slug, c.cover_url, c.latest_chapter, c.updated_at,
                  f.created_at AS followed_at
                FROM follows f
                JOIN comics c ON c.id = f.comic_id
                WHERE f.user_id = %s
                ORDER BY f.created_at DESC
            """, (uid,))
            comics = cur.fetchall()

    return render_template("following.html", comics=comics)

@app.get("/liked")   # hoặc đổi thành /yeu-thich nếu bạn thích
def liked_page():
    uid = session.get("user_id")
    if not uid:
        return redirect(url_for("login"))  # hoặc url_for("home")

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT c.*
                FROM post_likes pl
                JOIN comics c ON c.id = pl.comic_id
                WHERE pl.user_id = %s
                ORDER BY pl.created_at DESC
            """, (uid,))
            comics = cur.fetchall()

    return render_template("liked.html", comics=comics)

from datetime import datetime

@app.template_filter('timeago')
def timeago(dt):
    if not dt:
        return ""
    now = datetime.now()
    diff = now - dt
    s = int(diff.total_seconds())
    if s < 60:
        return f"{s} giây trước"
    m = s // 60
    if m < 60:
        return f"{m} phút trước"
    h = m // 60
    if h < 24:
        return f"{h} giờ trước"
    d = h // 24
    if d < 30:
        return f"{d} ngày trước"
    mo = d // 30
    if mo < 12:
        return f"{mo} tháng trước"
    y = mo // 12
    return f"{y} năm trước"



@app.route('/')
def index():
    cn = get_conn()
    with cn.cursor(pymysql.cursors.DictCursor) as cur:
        # 🔹 Top 10 truyện mới nhất (chỉ lấy truyện không bị ẩn)
        cur.execute("""
            SELECT id, slug, title, cover_url, updated_at, latest_chapter
            FROM comics
            WHERE is_hidden = 0
            ORDER BY updated_at DESC
            LIMIT 10
        """)
        top_comics = cur.fetchall()

        # 🔹 Các truyện còn lại (bắt đầu từ truyện thứ 11, cũng chỉ lấy truyện hiển thị)
        cur.execute("""
            SELECT id, slug, title, cover_url, updated_at, latest_chapter
            FROM comics
            WHERE is_hidden = 0
            ORDER BY updated_at DESC
            LIMIT 18446744073709551615 OFFSET 10
        """)
        all_comics = cur.fetchall()

    cn.close()
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT name, slug FROM genres ORDER BY name")
            genres = cur.fetchall()

    return render_template('index.html', top_comics=top_comics, all_comics=all_comics, genres=genres, current_role=session.get("role"))





from werkzeug.security import check_password_hash, generate_password_hash

@app.route("/api/profile/change_password", methods=["POST"])
def api_change_password():
    uid = session.get("user_id")
    if not uid:
        return redirect(url_for("home"))

    cur_pwd = (request.form.get("current_password") or "").strip()
    new_pwd = (request.form.get("new_password") or "").strip()
    cf_pwd  = (request.form.get("confirm_password") or "").strip()

    # validate
    if len(new_pwd) < 8 or new_pwd != cf_pwd:
        # có thể flash thông báo nếu muốn
        return redirect(url_for("profile_page"))

    # lấy hash hiện tại
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT password_hash FROM users WHERE id=%s", (uid,))
            row = cur.fetchone()
            if not row or not check_password_hash(row["password_hash"], cur_pwd):
                return redirect(url_for("profile_page"))

            # cập nhật hash mới
            new_hash = generate_password_hash(new_pwd)
            cur.execute("UPDATE users SET password_hash=%s WHERE id=%s", (new_hash, uid))

    return redirect(url_for("profile_page"))



from markupsafe import Markup

from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename
import os

@app.route("/api/save_profile", methods=["POST"])
def api_save_profile():
    uid = session.get("user_id")
    if not uid:
        return redirect(url_for("index"))  # hoặc 'home' nếu có alias

    display_name = (request.form.get("display_name") or "").strip()
    phone        = (request.form.get("phone") or "").strip()
    bio          = (request.form.get("bio") or "").strip()

    cur_pwd = (request.form.get("current_password") or "").strip()
    new_pwd = (request.form.get("new_password") or "").strip()
    cf_pwd  = (request.form.get("confirm_password") or "").strip()

    avatar = request.files.get("avatar")
    avatar_url = None

    # ----- cập nhật avatar + thông tin cơ bản -----
    if avatar and avatar.filename:
        fname = secure_filename(avatar.filename)
        save_dir = os.path.join(app.static_folder, "uploads")
        os.makedirs(save_dir, exist_ok=True)
        save_path = os.path.join(save_dir, fname)
        avatar.save(save_path)
        avatar_url = f"/static/uploads/{fname}"

    with get_conn() as conn:
        with conn.cursor() as cur:
            if avatar_url:
                cur.execute("""UPDATE users
                               SET username=%s, phone=%s, bio=%s, avatar_url=%s
                               WHERE id=%s""",
                            (display_name, phone, bio, avatar_url, uid))
            else:
                cur.execute("""UPDATE users
                               SET username=%s, phone=%s, bio=%s
                               WHERE id=%s""",
                            (display_name, phone, bio, uid))

    # ----- đổi mật khẩu nếu có nhập ô mật khẩu -----
    def html_msg(text, color, target, ms=2000):
        # trả HTML nhỏ + auto-redirect sau ms
        return Markup(f"""
        <html><head><meta charset="utf-8"><title>Thông báo</title>
        <style>
        body{{display:flex;align-items:center;justify-content:center;height:100vh;background:#0b0f13;color:{color};
             font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;font-size:22px}}
        .card{{text-align:center}}
        small{{display:block;opacity:.7;margin-top:6px;color:#9fb2c7}}
        </style>
        <script>setTimeout(function(){{window.location.href='{target}';}}, {ms});</script>
        </head><body><div class="card">{text}<small>Đang chuyển trang...</small></div></body></html>
        """)

    # Nếu user chạm vào phần mật khẩu: cần đủ 3 ô
    if cur_pwd or new_pwd or cf_pwd:
        # thiếu ô nào → báo lỗi và quay về profile
        if not (cur_pwd and new_pwd and cf_pwd):
            return html_msg("❗ Vui lòng nhập đủ 3 ô mật khẩu.", "#ff6b6b", url_for("profile_page"))

        # xác thực mật khẩu hiện tại
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT password_hash FROM users WHERE id=%s", (uid,))
                row = cur.fetchone()
        if not row or not check_password_hash(row["password_hash"], cur_pwd):
            return html_msg("❌ Mật khẩu hiện tại không đúng.", "#ff6b6b", url_for("profile_page"))

        # kiểm tra khớp
        if new_pwd != cf_pwd:
            return html_msg("❌ Nhập lại mật khẩu mới không khớp.", "#ff6b6b", url_for("profile_page"))

        # độ dài cơ bản
        # if len(new_pwd) < 8:
        #     return html_msg("❗ Mật khẩu mới phải ≥ 8 ký tự.", "#ffb020", url_for("profile_page"))

        # cập nhật hash mới
        new_hash = generate_password_hash(new_pwd)
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE users SET password_hash=%s WHERE id=%s", (new_hash, uid))

    # --- thành công: quay về index sau 2s ---
    return html_msg("✅ Cập nhật thành công!", "#4ade80", url_for("index"), ms=1500)


from flask import jsonify, session
import mysql.connector

@app.route("/notifications")
def api_notifications():
    user_id = session.get("user_id")
    if not user_id:
        return jsonify([])

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, message, is_read, created_at
                FROM notifications
                WHERE user_id=%s
                ORDER BY created_at DESC
            """, (user_id,))
            data = cur.fetchall()
    return jsonify(data)
@app.get("/notifications/unread-count")
def api_notifications_unread_count():
    uid = session.get("user_id")
    if not uid:
        return jsonify({"count": 0})
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) AS c FROM notifications WHERE user_id=%s AND is_read=0", (uid,))
            c = (cur.fetchone() or {}).get("c", 0)
    return jsonify({"count": int(c)})

@app.post("/notifications/mark-read")
def api_notifications_mark_read():
    uid = session.get("user_id")
    if not uid:
        return ("", 204)
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE notifications SET is_read=1 WHERE user_id=%s AND is_read=0", (uid,))
    return ("", 204)

from flask import request, jsonify

@app.get("/api/search")
def api_search():
    q = (request.args.get("q") or "").strip()
    if not q:
        return jsonify({"ok": True, "data": []})

    with get_conn() as conn:
        with conn.cursor() as cur:
            # Nếu đã tạo FULLTEXT thì dùng MATCH ... AGAINST cho chuẩn
            try:
                cur.execute("""
                    SELECT id, slug, title, description, authors, cover_url, latest_chapter, updated_at,
                           MATCH(title, description, authors) AGAINST (%s IN NATURAL LANGUAGE MODE) AS score
                    FROM comics
                    WHERE MATCH(title, description, authors) AGAINST (%s IN NATURAL LANGUAGE MODE)
                    AND is_hidden = 0
                    ORDER BY score DESC, updated_at DESC
                    LIMIT 50
                """, (q, q))
                rows = cur.fetchall()
            except Exception:
                # Fallback nếu chưa có FULLTEXT
                like = f"%{q}%"
                cur.execute("""
                    SELECT id, slug, title, description, authors, cover_url, latest_chapter, updated_at
                    FROM comics
                    WHERE title LIKE %s OR description LIKE %s OR authors LIKE %s
                    ORDER BY updated_at DESC
                    LIMIT 50
                """, (like, like, like))
                rows = cur.fetchall()

    return jsonify({"ok": True, "data": rows})

@app.get("/tim-truyen")
def page_search():
    q = (request.args.get("q") or "").strip()
    rows = []
    if q:
        with get_conn() as conn:
            with conn.cursor() as cur:
                like = f"%{q}%"
                cur.execute("""
                    SELECT id, slug, title, description, authors, cover_url, latest_chapter, updated_at
                    FROM comics
                    WHERE title LIKE %s OR description LIKE %s OR authors LIKE %s
                    ORDER BY updated_at DESC
                """, (like, like, like))
                rows = cur.fetchall()
    return render_template("search_results.html", q=q, results=rows)

# Bình luận
from flask import request, jsonify, session

# Lấy danh sách bình luận theo slug (có phân trang nhẹ)
@app.get("/api/comments/<slug>")
def api_comments(slug):
    page = max(int(request.args.get("page", 1) or 1), 1)
    limit = 20
    offset = (page - 1) * limit

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM comics WHERE slug=%s LIMIT 1", (slug,))
            r = cur.fetchone()
            if not r:
                return jsonify({"ok": True, "data": [], "total": 0})

            comic_id = r["id"]

            # tổng số bình luận
            cur.execute("SELECT COUNT(*) AS c FROM comments WHERE comic_id=%s", (comic_id,))
            total = int(cur.fetchone()["c"])

            # lấy danh sách
            cur.execute("""
                SELECT c.id, c.content, c.created_at,
                    u.username, u.avatar_url
                FROM comments c
                JOIN users u ON u.id = c.user_id
                WHERE c.comic_id=%s
                ORDER BY c.id DESC
                LIMIT %s OFFSET %s
            """, (comic_id, limit, offset))

            rows = cur.fetchall()

    return jsonify({"ok": True, "data": rows, "total": total, "page": page, "limit": limit})


# Đăng bình luận cho 1 truyện
# Đăng bình luận cho 1 truyện
@app.post("/api/comments/<slug>")
def api_comment_create(slug):
    uid = session.get("user_id")
    if not uid:
        return jsonify({"ok": False, "error": "NOT_LOGIN"}), 401

    content = (request.form.get("content") or request.json.get("content") or "").strip()
    if not content:
        return jsonify({"ok": False, "error": "EMPTY"}), 400
    if len(content) > 2000:
        return jsonify({"ok": False, "error": "TOO_LONG"}), 400

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM comics WHERE slug=%s LIMIT 1", (slug,))
            r = cur.fetchone()
            if not r:
                return jsonify({"ok": False, "error": "NOT_FOUND"}), 404
            comic_id = r["id"]

            # insert
            cur.execute(
                "INSERT INTO comments (comic_id, user_id, content) VALUES (%s, %s, %s)",
                (comic_id, uid, content)
            )
            new_id = cur.lastrowid

            # (tuỳ chọn) thông báo
            cur.execute(
                "INSERT INTO notifications (user_id, message) VALUES (%s,%s)",
                (uid, "Bạn đã bình luận một truyện")
            )

            # 🔥 lấy lại bình luận vừa tạo (kèm username + avatar)
            cur.execute("""
                SELECT c.id, c.content, c.created_at, u.username, u.avatar_url
                FROM comments c JOIN users u ON u.id = c.user_id
                WHERE c.id=%s
            """, (new_id,))
            new_row = cur.fetchone()

    return jsonify({"ok": True, "comment": new_row})

# yêu cầu dịch truyện
from flask import render_template, request, redirect, url_for, flash, session, jsonify

@app.route("/yeu-cau-dich", methods=["GET", "POST"])
def request_translate():
    if request.method == "POST":
        name   = (request.form.get("name") or "").strip()
        email  = (request.form.get("email") or "").strip()
        title  = (request.form.get("comic_title") or "").strip()
        chap   = (request.form.get("chapter") or "").strip()
        lang   = (request.form.get("lang_to") or "").strip()
        note   = (request.form.get("note") or "").strip()

        # Validate rất cơ bản
        err = None
        if not name or not email or not title or not chap or not lang:
            err = "Vui lòng điền đầy đủ các trường bắt buộc."
        elif "@" not in email or "." not in email:
            err = "Email không hợp lệ."

        if err:
            flash(err, "error")
            return render_template("request_translate.html",
                                   form={"name":name,"email":email,"comic_title":title,
                                         "chapter":chap,"lang_to":lang,"note":note})

        uid = session.get("user_id")

        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO translate_requests (user_id, name, email, comic_title, chapter, lang_to, note)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (uid, name, email, title, chap, lang, note or None))

                # 🔔 đẩy 1 thông báo vào chuông cho user nếu có đăng nhập
                if uid:
                # Thông báo cho người gửi
                    cur.execute("""
                        INSERT INTO notifications (user_id, message)
                        VALUES (%s, %s)
                    """, (uid, f"Đã gửi yêu cầu dịch: {title} - Chương {chap} → {lang}"))    

                # Thông báo cho admin rằng đã nhận yêu cầu dịch
                cur.execute("SELECT id FROM users WHERE role = 'admin'")
                admins = cur.fetchall()
                for admin in admins:
                    admin_id = admin["id"]
                    cur.execute("""
                        INSERT INTO notifications (user_id, message)
                        VALUES (%s, %s)
                    """, (admin_id, f"Hệ thống đã nhận yêu cầu dịch mới: {title} - Chương {chap} → {lang}"))

        flash("Đã gửi yêu cầu dịch. Cảm ơn bạn!", "success")
        return redirect(url_for("request_translate"))

    # GET
    return render_template("request_translate.html", form={})


## ================= FANPAGE ==================
@app.route("/fanpage")
def fanpage():
    return redirect("https://www.facebook.com/share/1Cp9bcaezV/?mibextid=wwXIfr")
# ============ ROUTE THẢO LUẬN ============
@app.route("/thaoluan", methods=["GET", "POST"])
def thaoluan():
    with get_conn() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                msg = request.form["noidung"]
                user = session.get("username", "Khách")
                cur.execute("INSERT INTO discussions (username, message) VALUES (%s, %s)", (user, msg))
                conn.commit()

            cur.execute("SELECT username, message, created_at FROM discussions ORDER BY created_at DESC")
            comments = cur.fetchall()

    return render_template("thao-luan.html", comments=comments)
from flask import redirect

# đánh giá
@app.post("/api/rate/<slug>")
def api_rate(slug):
    uid = session.get("user_id")
    if not uid:
        return jsonify({"ok": False, "msg": "Vui lòng đăng nhập để đánh giá."}), 401

    data = request.get_json(force=True)
    rating = int(data.get("rating", 0))
    if rating < 1 or rating > 5:
        return jsonify({"ok": False, "msg": "Điểm không hợp lệ."}), 400

    with get_conn() as conn:
        with conn.cursor() as cur:
            # lấy id truyện
            cur.execute("SELECT id FROM comics WHERE slug=%s", (slug,))
            row = cur.fetchone()
            if not row:
                return jsonify({"ok": False, "msg": "Không tìm thấy truyện."}), 404
            cid = row["id"]

            # chèn hoặc cập nhật điểm đánh giá
            cur.execute("""
                INSERT INTO ratings (comic_id, user_id, rating)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE rating=VALUES(rating)
            """, (cid, uid, rating))

            # tính trung bình + tổng lượt
            cur.execute("SELECT AVG(rating) AS avg_rating, COUNT(*) AS total FROM ratings WHERE comic_id=%s", (cid,))
            info = cur.fetchone()

    return jsonify({
        "ok": True,
        "avg": round(info["avg_rating"], 1),
        "total": info["total"]
    })

# mục xếp hạng
@app.route("/xep-hang/xem")
def xep_hang_xem():
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT id, title, slug, cover_url, view_count
                FROM comics
                WHERE view_count > 0  
                ORDER BY view_count DESC
                LIMIT 30
            """)
            comics = cur.fetchall()
    return render_template("xep_hang.html", title="Top truyện được xem nhiều nhất", type="xem", comics=comics)



@app.route("/xep-hang/thich")
def xep_hang_thich():
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT c.id, c.title, c.slug, c.cover_url,
                       COUNT(pl.user_id) AS like_count
                FROM comics c
                LEFT JOIN post_likes pl ON pl.comic_id = c.id
                GROUP BY c.id
                HAVING like_count > 0   
                ORDER BY like_count DESC
                LIMIT 30
            """)
            comics = cur.fetchall()
    return render_template("xep_hang.html", title="Top truyện được yêu thích nhất", type="thich", comics=comics)



@app.route("/xep-hang/theo-doi")
def xep_hang_theodoi():
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT c.id, c.title, c.slug, c.cover_url,
                       COUNT(f.user_id) AS follow_count
                FROM comics c
                LEFT JOIN follows f ON f.comic_id = c.id
                GROUP BY c.id
                HAVING follow_count > 0
                ORDER BY follow_count DESC
                LIMIT 30
            """)
            comics = cur.fetchall()
    return render_template("xep_hang.html", title="Top truyện có nhiều người theo dõi nhất", type="theo-doi", comics=comics)



@app.route("/xep-hang/danh-gia")
def xep_hang_danhgia():
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT c.id, c.title, c.slug, c.cover_url,
                       AVG(r.rating) AS avg_rating
                FROM comics c
                LEFT JOIN ratings r ON r.comic_id = c.id
                GROUP BY c.id
                HAVING avg_rating > 0   -- 👈 chỉ hiện truyện đã được đánh giá
                ORDER BY avg_rating DESC
                LIMIT 30
            """)
            comics = cur.fetchall()
    return render_template("xep_hang.html", title="Top truyện được đánh giá cao nhất", type="danh-gia", comics=comics)




from datetime import datetime, timedelta

@app.route("/xep-hang/<string:period>")
def xep_hang_thoi_gian(period):
    now = datetime.now()
    if period == "ngay":
        time_limit = now - timedelta(days=1)
        label = "trong ngày"
    elif period == "tuan":
        time_limit = now - timedelta(days=7)
        label = "trong tuần"
    elif period == "thang":
        time_limit = now - timedelta(days=30)
        label = "trong tháng"
    else:
        time_limit = None
        label = "mọi thời đại"

    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Lấy top theo lượt thích (bạn có thể đổi sang 'views' hay 'follows' tuỳ ý)
            if time_limit:
                cur.execute("""
                    SELECT c.id, c.title, c.slug, c.cover_url, COUNT(pl.id) AS total
                    FROM comics c
                    JOIN post_likes pl ON pl.comic_id = c.id
                    WHERE pl.created_at >= %s
                    GROUP BY c.id
                    ORDER BY total DESC
                    LIMIT 20
                """, (time_limit,))
            else:
                cur.execute("""
                    SELECT c.id, c.title, c.slug, c.cover_url, COUNT(pl.id) AS total
                    FROM comics c
                    JOIN post_likes pl ON pl.comic_id = c.id
                    GROUP BY c.id
                    ORDER BY total DESC
                    LIMIT 20
                """)
            rows = cur.fetchall()

    return render_template("xep_hang.html",
                           comics=rows,
                           title=f"Top truyện được yêu thích {label}",
                           period=period)





# ================== MAIN ==================
def setup():
    os.makedirs("static/img", exist_ok=True)
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    init_db()

if __name__ == "__main__":
    setup()
    app.run(debug=True, host="127.0.0.1", port=int(os.getenv("PORT", "5000")))