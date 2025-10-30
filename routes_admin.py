# routes_admin.py
from flask import Blueprint, render_template, request, redirect, url_for, flash, current_app
from werkzeug.utils import secure_filename
from db import get_conn
import os, time, pymysql
from functools import wraps
from flask import session

# ⚙️ Khởi tạo blueprint admin
admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

# ========== Decorator chặn quyền truy cập ==========
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session or session.get("role") != "admin":
            flash("Bạn không có quyền truy cập trang này!", "danger")
            return redirect(url_for("index"))
        return f(*args, **kwargs)
    return decorated_function


# ========== NẠP TRUYỆN ==========
@admin_bp.route("/add_comic", methods=["GET", "POST"])

def add_comic():
    import os
    from werkzeug.utils import secure_filename

    if request.method == "POST":
        title = (request.form.get("title") or "").strip()
        slug  = (request.form.get("slug") or "").strip()
        description = request.form.get("description")
        authors     = request.form.get("authors")
        audience    = request.form.get("audience")
        status      = request.form.get("status")
        country     = request.form.get("country")

        # --- 1️⃣ Xử lý ảnh bìa ---
        cover_url = None
        f = request.files.get("cover_url")  # upload mới
        if f and f.filename:
            ext = f.filename.rsplit(".", 1)[-1].lower()
            fname = secure_filename(f"{(slug or 'comic')}-{int(time.time())}.{ext}")
            save_dir = os.path.join(current_app.static_folder, "uploads")
            os.makedirs(save_dir, exist_ok=True)
            save_path = os.path.join(save_dir, fname)
            if not os.path.exists(save_path):  # tránh lưu trùng
                f.save(save_path)
            cover_url = f"/static/uploads/{fname}"
        else:
            # nếu không upload → lấy từ dropdown
            cover_choice = request.form.get("cover_choice")
            if cover_choice:
                cover_url = cover_choice

        # --- 2️⃣ Lưu truyện ---
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO comics(title, slug, description, authors, audience, status, country, cover_url, updated_at)
                    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,NOW())
                """, (title, slug, description, authors, audience, status, country, cover_url))
                comic_id = cur.lastrowid

        # --- 3️⃣ Lưu thể loại ---
        genre_ids = request.form.getlist("genre_ids")
        if genre_ids:
            with get_conn() as conn:
                with conn.cursor() as cur:
                    for gid in genre_ids:
                        cur.execute("INSERT INTO comic_genres(comic_id, genre_id) VALUES (%s,%s)", (comic_id, int(gid)))

        # --- 4️⃣ Tạo chương 1 + ảnh nội dung ---
        chapter1_title = request.form.get("chapter1_title", "Chapter 1").strip()
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO chapters(comic_id, number, title, created_at)
                    VALUES(%s, %s, %s, NOW())
                """, (comic_id, 1, chapter1_title))
                chapter_id = cur.lastrowid

        files = [x for x in request.files.getlist("chapter1_pages") if getattr(x, "filename", "")]
        if files:
            save_root = os.path.join(current_app.static_folder, "chapters", slug or str(comic_id))
            os.makedirs(save_root, exist_ok=True)
            page_no = 0
            with get_conn() as conn:
                with conn.cursor() as cur:
                    for file in files:
                        page_no += 1
                        ext = file.filename.rsplit(".", 1)[-1].lower()
                        fname = secure_filename(f"1-{page_no}.{ext}")
                        file.save(os.path.join(save_root, fname))
                        image_url = f"/static/chapters/{slug or comic_id}/{fname}"
                        cur.execute("""
                            INSERT INTO chapter_images(comic_id, chapter_id, page_number, image_url)
                            VALUES (%s, %s, %s, %s)
                        """, (comic_id, chapter_id, page_no, image_url))
                    cur.execute("UPDATE comics SET latest_chapter=%s, updated_at=NOW() WHERE id=%s", (1, comic_id))

        # flash("✅ Đã thêm truyện và chương đầu tiên!", "success")
                    # --- 🔔 Gửi thông báo cho tất cả user (kể cả admin) khi có truyện mới ---
                # --- 🔔 Gửi thông báo ---
        try:
            with get_conn() as conn2:
                with conn2.cursor() as cur2:
                    # 1️⃣ Thông báo cho tất cả user (trừ admin)
                    cur2.execute("""
                        INSERT INTO notifications (user_id, message)
                        SELECT id, %s
                        FROM users
                        WHERE role IS NULL OR role != 'admin'
                    """, (f"Truyện mới: {title} vừa được đăng, xem ngay thôi!",))

                    # 2️⃣ Thông báo riêng cho admin (người đang đăng)
                    cur2.execute("""
                        INSERT INTO notifications (user_id, message)
                        VALUES (%s, %s)
                    """, (session.get("user_id"), f"Bạn vừa đăng truyện {title} thành công!"))

                    conn2.commit()
        except Exception as e:
            print("⚠️ Lỗi khi gửi thông báo:", e)

        


        return redirect(url_for("index"))

    # --- 5️⃣ GET: hiển thị form + danh sách ảnh có sẵn ---
    img_dir = os.path.join(current_app.static_folder, "img")
    images = []
    if os.path.isdir(img_dir):
        images = [f for f in os.listdir(img_dir) if f.lower().endswith(('.jpg', '.png', '.jpeg', '.webp', '.gif'))]

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, name, slug FROM genres ORDER BY name")
            genres = cur.fetchall()

    return render_template("admin_add_comic.html", genres=genres, images=images)




# ========== SỬA TRUYỆN ==========
@admin_bp.route("/comic/<slug>/edit", methods=["POST"])
def edit_comic(slug):
    import os
    from werkzeug.utils import secure_filename

    title   = (request.form.get("title") or "").strip()
    newSlug = (request.form.get("slug")  or slug).strip() or slug
    authors = request.form.get("authors")
    status  = request.form.get("status")
    country = request.form.get("country")
    desc    = request.form.get("description")
    f       = request.files.get("cover_url")

    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Lấy ảnh cũ để giữ lại nếu không upload mới
            cur.execute("SELECT cover_url FROM comics WHERE slug=%s", (slug,))
            row = cur.fetchone()
            old_cover = row["cover_url"] if row else None

            # Nếu có file mới → lưu file và cập nhật đường dẫn
            cover_url = old_cover
            if f and f.filename:
                filename = secure_filename(f.filename)
                upload_dir = os.path.join("static", "img")
                os.makedirs(upload_dir, exist_ok=True)
                upload_path = os.path.join(upload_dir, filename)
                f.save(upload_path)
                cover_url = f"/static/img/{filename}"

            # Cập nhật dữ liệu
            cur.execute("""
                UPDATE comics
                SET title=%s, slug=%s, authors=%s, status=%s, country=%s,
                    description=%s, cover_url=%s, updated_at=NOW()
                WHERE slug=%s
            """, (title, newSlug, authors, status, country, desc, cover_url, slug))
            conn.commit()

    # Gửi thông báo cho người theo dõi
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("SELECT id, title FROM comics WHERE slug=%s LIMIT 1", (newSlug,))
            row = cur.fetchone()
            if row:
                comic_id = row["id"]
                comic_title = row["title"] or title
                cur.execute("""
                    INSERT INTO notifications (user_id, message)
                    SELECT f.user_id, %s
                    FROM follows f
                    WHERE f.comic_id = %s
                """, (f"Truyện {comic_title} vừa được cập nhật thông tin.", comic_id))
                conn.commit()

    # flash("✅ Đã cập nhật truyện thành công!", "success")
    return redirect(url_for("comic_detail", slug=newSlug))



# ========== THÊM CHƯƠNG ==========
@admin_bp.route("/comic/<slug>/chapter/add", methods=["POST"])
def add_chapter(slug):
    number = request.form.get("number", type=int)
    title  = (request.form.get("title") or "").strip()

    if not number or number < 1:
        return {"ok": False, "error": "Số chương không hợp lệ"}

    files = [f for f in request.files.getlist("pages") if getattr(f, "filename", "")]
    if not files:
        return {"ok": False, "error": "Bạn chưa chọn ảnh nội dung cho chương."}

    save_root = os.path.join(current_app.static_folder, "chapters", slug)
    os.makedirs(save_root, exist_ok=True)

    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                # Kiểm tra chương đã tồn tại
                cur.execute("""
                    SELECT id FROM chapters
                    WHERE comic_id = (SELECT id FROM comics WHERE slug=%s)
                    AND number = %s
                """, (slug, number))
                if cur.fetchone():
                    return {"ok": False, "error": f"Chương {number} đã tồn tại."}

                # Lấy comic_id
                cur.execute("SELECT id, title FROM comics WHERE slug=%s LIMIT 1", (slug,))
                row = cur.fetchone()
                if not row:
                    return {"ok": False, "error": "Không tìm thấy truyện"}
                comic_id = row["id"]
                comic_title = row.get("title") or slug.replace("-", " ").title()

                # Tạo chương
                cur.execute("""
                    INSERT INTO chapters(comic_id, number, title, created_at)
                    VALUES (%s, %s, %s, NOW())
                """, (comic_id, number, title or None))
                chapter_id = cur.lastrowid

                # Lưu file + ghi bảng ảnh
                page_no = 0
                for f in files:
                    page_no += 1
                    ext = (f.filename.rsplit(".", 1)[-1] or "jpg").lower()
                    fname = secure_filename(f"{number}-{page_no}.{ext}")
                    f.save(os.path.join(save_root, fname))

                    image_url = f"/static/chapters/{slug}/{fname}"
                    cur.execute("""
                        INSERT INTO chapter_images(comic_id, chapter_id, page_number, image_url)
                        VALUES (%s, %s, %s, %s)
                    """, (comic_id, chapter_id, page_no, image_url))

                # Cập nhật latest_chapter
                cur.execute(
                    "UPDATE comics SET latest_chapter=%s, updated_at=NOW() WHERE id=%s",
                    (number, comic_id)
                )

                # Thông báo cho follower
                cur.execute("""
                    INSERT INTO notifications (user_id, message)
                    SELECT f.user_id, %s FROM follows f WHERE f.comic_id=%s
                """, (f"Chương {number}{(': ' + title) if title else ''} của {comic_title} đã ra mắt!", comic_id))

            conn.commit()

        return {"ok": True}

    except Exception as e:
        try: conn.rollback()
        except: pass
        return {"ok": False, "error": "Lỗi khi thêm chương: " + str(e)}

# ========== XÓA CHƯƠNG ==========
@admin_bp.post("/comic/<slug>/chapter/<int:chapter_id>/delete")
def delete_chapter(slug, chapter_id):
    # Lấy comic_id từ slug
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM comics WHERE slug=%s LIMIT 1", (slug,))
            comic = cur.fetchone()
            if not comic:
                flash("Không tìm thấy truyện", "error")
                return redirect(url_for("home"))
            comic_id = comic["id"]

            # Lấy danh sách ảnh của chương để xóa file
            cur.execute("SELECT image_url FROM chapter_images WHERE chapter_id=%s", (chapter_id,))
            imgs = cur.fetchall()

    # Xóa file vật lý
    import os
    from flask import current_app
    for r in imgs:
        p = r["image_url"]
        if p and p.startswith("/static/"):
            abs_path = os.path.join(current_app.root_path, p.lstrip("/"))
            try:
                if os.path.exists(abs_path):
                    os.remove(abs_path)
            except:
                pass

    # Xóa dữ liệu chương + ảnh trong DB
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM chapter_images WHERE chapter_id=%s", (chapter_id,))
            cur.execute("DELETE FROM chapters WHERE id=%s AND comic_id=%s", (chapter_id, comic_id))

            # Cập nhật latest_chapter
            cur.execute("SELECT COALESCE(MAX(number), 0) AS mx FROM chapters WHERE comic_id=%s", (comic_id,))
            mx = cur.fetchone()["mx"]
            cur.execute("UPDATE comics SET latest_chapter=%s, updated_at=NOW() WHERE id=%s", (mx, comic_id))

    # flash("Đã xóa chương.", "success")
    return redirect(url_for("comic_detail", slug=slug))

@admin_bp.post("/comic/<slug>/delete")
def delete_comic(slug):
    import shutil, os
    from flask import current_app

    # Lấy comic + id + cover để xóa file
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, cover_url FROM comics WHERE slug=%s LIMIT 1", (slug,))
            comic = cur.fetchone()
            if not comic:
                flash("Không tìm thấy truyện", "error")
                return redirect(url_for("home"))
            comic_id = comic["id"]
            cover_url = comic.get("cover_url")

            # Lấy toàn bộ ảnh chương để xóa file
            cur.execute("SELECT image_url FROM chapter_images WHERE comic_id=%s", (comic_id,))
            imgs = cur.fetchall()

    # Xóa file ảnh chương
    for r in imgs:
        p = r["image_url"]
        if p and p.startswith("/static/"):
            abs_path = os.path.join(current_app.root_path, p.lstrip("/"))
            try:
                if os.path.exists(abs_path):
                    os.remove(abs_path)
            except:
                pass

    # Xóa cả thư mục chapters/<slug> (nhanh gọn)
    chapters_dir = os.path.join(current_app.static_folder, "chapters", slug)
    try:
        if os.path.isdir(chapters_dir):
            shutil.rmtree(chapters_dir)
    except:
        pass

    # Xóa file cover (nếu bạn muốn)
    if cover_url and cover_url.startswith("/static/"):
        cover_path = os.path.join(current_app.root_path, cover_url.lstrip("/"))
        try:
            if os.path.exists(cover_path):
                os.remove(cover_path)
        except:
            pass

    # Xóa dữ liệu DB theo thứ tự phụ thuộc
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM chapter_images WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM chapters       WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM comic_genres   WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM follows        WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM post_likes     WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM reading_history WHERE comic_id=%s", (comic_id,))
            cur.execute("DELETE FROM comics         WHERE id=%s", (comic_id,))

    # flash("✅ Đã xóa toàn bộ truyện.", "success")
    return redirect(url_for("index"))




# from flask import Blueprint, render_template, redirect, url_for, request, flash, session
# from db import get_conn
# from functools import wraps

# admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

# def admin_required(func):
#     @wraps(func)
#     def wrapper(*args, **kwargs):
#         if session.get("role") != "admin":
#             flash("Bạn không có quyền truy cập!", "danger")
#             return redirect(url_for("index"))
#         return func(*args, **kwargs)
#     return wrapper


# # # 🧱 QUẢN LÝ TOÀN BỘ TRUYỆN
# @admin_bp.route("/qly_truyen")
# @admin_required
# def qly_truyen():
#     with get_conn() as conn:
#         with conn.cursor() as cur:
#             cur.execute("SELECT * FROM comics ORDER BY updated_at DESC")
#             comics = cur.fetchall()
#     return render_template("qly_truyen.html", comics=comics)


# # ✏️ SỬA TRUYỆN
# @admin_bp.route("/comics/edit/<int:id>", methods=["GET", "POST"])
# @admin_required
# def admin_edit_comic(slug):
#     with get_conn() as conn:
#         with conn.cursor() as cur:
#             if request.method == "POST":
#                 title = request.form["title"]
#                 author = request.form["author"]
#                 status = request.form["status"]
#                 cur.execute("""
#                     UPDATE comics SET title=%s, author=%s, status=%s, updated_at=NOW()
#                     WHERE id=%s
#                 """, (title, author, status, id))
#                 conn.commit()
#                 flash("Cập nhật truyện thành công!", "success")
#                 return redirect(url_for("admin.qly_truyen"))
#             cur.execute("SELECT * FROM comics WHERE id=%s", (id,))
#             comic = cur.fetchone()
#     return render_template("qly_truyen.html", comic=comic)

# import pymysql

# # # ẨN / HIỆN TRUYỆN
# @admin_bp.route("/toggle_comic/<int:id>", methods=["POST"])
# @admin_required
# def admin_toggle_comic(id):
#     with get_conn() as conn:
#         with conn.cursor(pymysql.cursors.DictCursor) as cur:
#             cur.execute("SELECT is_hidden FROM comics WHERE id=%s", (id,))
#             comic = cur.fetchone()
#             if not comic:
#                 flash("Không tìm thấy truyện!", "danger")
#                 return redirect(url_for("admin.qly_truyen"))

#             new_status = 0 if comic["is_hidden"] else 1
#             cur.execute("UPDATE comics SET is_hidden=%s WHERE id=%s", (new_status, id))
#             conn.commit()

#     flash("Đã cập nhật trạng thái ẩn/hiện của truyện!", "info")
#     return redirect(url_for("admin.qly_truyen"))
# ========== QUẢN LÝ TOÀN BỘ TRUYỆN ==========
from flask import session
from functools import wraps
import pymysql
# ========== TRANG QUẢN LÝ TẤT CẢ TRUYỆN ==========
@admin_bp.route("/manage_all_comics")
@admin_required
def manage_all_comics():
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT id, title, slug, authors, status, country, updated_at,
                       latest_chapter, cover_url, is_hidden
                FROM comics
                ORDER BY updated_at DESC
            """)
            comics = cur.fetchall()
    return render_template("admin_manage_all.html", comics=comics)

# ========== ẨN / HIỆN TRUYỆN ==========
@admin_bp.route("/toggle_comic/<int:id>", methods=["POST"])
@admin_required
def toggle_comic(id):
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("SELECT is_hidden FROM comics WHERE id=%s", (id,))
            comic = cur.fetchone()
            if not comic:
                flash("Không tìm thấy truyện!", "danger")
                return redirect(url_for("admin.manage_all_comics"))

            new_status = 0 if comic["is_hidden"] else 1
            cur.execute("UPDATE comics SET is_hidden=%s WHERE id=%s", (new_status, id))
            conn.commit()
            
    return redirect(url_for("admin.manage_all_comics"))

# ========== CHỈNH SỬA TRUYỆN ==========
@admin_bp.route("/sua_comic/<slug>", methods=["GET", "POST"])
@admin_required
def sua_comic(slug):
    import os
    from werkzeug.utils import secure_filename
    with get_conn() as conn:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            if request.method == "POST":
                title = request.form.get("title")
                authors = request.form.get("authors")
                status = request.form.get("status")
                country = request.form.get("country")
                f = request.files.get("cover_url")

                cover_url = None
                if f and f.filename:
                    filename = secure_filename(f.filename)
                    upload_path = os.path.join("static/img", filename)
                    f.save(upload_path)
                    cover_url = f"/static/img/{filename}"

                if cover_url:
                    cur.execute("""
                        UPDATE comics
                        SET title=%s, authors=%s, status=%s, country=%s, cover_url=%s, updated_at=NOW()
                        WHERE slug=%s
                    """, (title, authors, status, country, cover_url, slug))
                else:
                    cur.execute("""
                        UPDATE comics
                        SET title=%s, authors=%s, status=%s, country=%s, updated_at=NOW()
                        WHERE slug=%s
                    """, (title, authors, status, country, slug))
                conn.commit()
                flash("Đã cập nhật truyện!", "success")
                return redirect(url_for("admin.manage_all_comics"))

            cur.execute("SELECT * FROM comics WHERE slug=%s", (slug,))
            comic = cur.fetchone()
            return render_template("admin_edit_comic.html", comic=comic)



# ========== QUẢN LÝ THỂ LOẠI ==========

from flask import render_template

@admin_bp.route("/genres/manage")
@admin_required
def manage_genres():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, name, slug FROM genres ORDER BY id ASC")
            genres = cur.fetchall()
    return render_template("admin_genres.html", genres=genres)


@admin_bp.route("/genre/add", methods=["POST"])
@admin_required
def add_genre():
    from flask import request, redirect, url_for, flash
    import re
    name = (request.form.get("name") or "").strip()
    slug = (request.form.get("slug") or "").strip()

    if not name:
        
        return redirect(url_for("admin.manage_genres"))

    if not slug:
        slug = re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO genres (name, slug) VALUES (%s, %s)", (name, slug))
        conn.commit()

    
    return redirect(url_for("admin.manage_genres"))


@admin_bp.post("/genre/<int:id>/delete")
@admin_required
def delete_genre(id):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM genres WHERE id=%s", (id,))
        conn.commit()
    
    return redirect(url_for("admin.manage_genres"))
