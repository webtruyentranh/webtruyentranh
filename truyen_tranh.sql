-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 17, 2025 lúc 04:00 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `truyen_tranh`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chapters`
--

CREATE TABLE `chapters` (
  `id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chapters`
--

INSERT INTO `chapters` (`id`, `comic_id`, `number`, `title`, `created_at`) VALUES
(10, 10, 1, 'Mở đầu', '2025-09-30 21:29:40'),
(11, 10, 2, 'Chuyến tàu vô tận', '2025-09-30 21:32:31'),
(13, 10, 4, 'Làng thợ rèn', '2025-09-30 21:38:39'),
(14, 10, 5, 'Đại trụ đặc huấn', '2025-09-30 21:34:38'),
(20, 16, 1, 'Onepunchman', '2025-10-11 21:33:50'),
(151, 15, 1, 'Sự trở lại của Frieza', '2025-09-30 22:19:15'),
(152, 15, 2, 'Cuộc đổ bộ xuống Trái Đất', '2025-09-30 22:20:01'),
(153, 15, 3, 'Goku vs Frieza: Trận chiến sinh tử', '2025-09-30 22:20:17'),
(166, 55, 1, 'My hero academia', '2025-10-11 21:55:00'),
(167, 55, 2, 'Học viện anh hùng', '2025-10-11 21:57:05'),
(174, 56, 1, 'Pháp sư tập sự Lucy', '2025-10-11 23:35:48'),
(175, 56, 2, 'Hội pháp sư', '2025-10-11 23:47:26'),
(176, 57, 1, 'Ra khơi!!', '2025-10-12 08:22:16'),
(178, 58, 1, 'Sherlock Holmes Nhật Bản', '2025-10-12 08:40:30'),
(179, 58, 2, 'Thám tử teo nhỏ', '2025-10-12 08:45:03'),
(180, 59, 1, 'Đại chiến Titan', '2025-10-12 09:01:01'),
(181, 59, 2, 'Ngày hôm đó', '2025-10-12 09:08:32'),
(182, 59, 3, 'Đêm trước ngày giải tán', '2025-10-12 09:14:18'),
(200, 10, 3, 'Kỹ viện trấn', '2025-10-12 22:07:16'),
(208, 83, 1, '', '2025-10-13 02:13:51'),
(214, 10, 6, 'tt', '2025-10-13 04:23:34'),
(219, 5, 1, 'Cao thủ bóng rổ', '2025-10-15 13:56:12'),
(220, 12, 1, 'Naruto Shippuden', '2025-10-15 13:57:14'),
(221, 87, 1, 'Cuộc Gặp Gỡ Định Mệnh', '2025-10-15 14:11:47'),
(222, 87, 2, 'Phép Thuật và Cơ Bắp', '2025-10-15 14:12:31'),
(223, 87, 3, 'Phép Thuật Không Còn Là Tất Cả', '2025-10-15 14:13:16'),
(224, 88, 1, 'Thiên giới', '2025-10-15 14:21:21'),
(225, 78, 1, 'Bi kịch bắt nạt', '2025-10-15 14:29:55'),
(227, 14, 1, 'Tung cánh bay lên', '2025-10-15 14:36:33'),
(228, 14, 2, 'Vút bay', '2025-10-15 14:38:51'),
(229, 14, 3, 'Clb bóng đá mới - NANKATSU', '2025-10-15 14:41:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chapter_images`
--

CREATE TABLE `chapter_images` (
  `id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `chapter_id` int(11) NOT NULL,
  `page_number` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chapter_images`
--

INSERT INTO `chapter_images` (`id`, `comic_id`, `chapter_id`, `page_number`, `image_url`) VALUES
(5, 16, 20, 1, '/static/chapters/1-onepunchman.png'),
(10, 15, 151, 1, '/static/chapters/1-DB.jpg'),
(11, 15, 152, 1, '/static/chapters/2-DB.jpg'),
(12, 15, 153, 1, '/static/chapters/3-DB.jpg'),
(100, 10, 10, 1, '/static/chapters/1-demonslayer.jpg'),
(101, 10, 10, 2, '/static/chapters/2-demonslayer.jpg'),
(103, 10, 10, 3, '/static/chapters/3-demonslayer.jpg'),
(104, 10, 10, 4, '/static/chapters/4-demonslayer.jpg'),
(105, 10, 10, 5, '/static/chapters/5-demonslayer.jpg'),
(106, 10, 10, 6, '/static/chapters/6-demonslayer.jpg'),
(107, 10, 10, 7, '/static/chapters/7-demonslayer.jpg'),
(108, 10, 10, 8, '/static/chapters/8-demonslayer.jpg'),
(109, 10, 10, 9, '/static/chapters/9-demonslayer.jpg'),
(110, 10, 10, 10, '/static/chapters/10-demonslayer.jpg'),
(111, 10, 10, 11, '/static/chapters/11-demonslayer.jpg'),
(112, 10, 10, 12, '/static/chapters/12-demonslayer.jpg'),
(113, 10, 10, 13, '/static/chapters/13-demonslayer.jpg'),
(114, 10, 10, 14, '/static/chapters/14-demonslayer.jpg'),
(115, 10, 10, 15, '/static/chapters/15-demonslayer.jpg'),
(116, 10, 10, 16, '/static/chapters/16-demonslayer.jpg'),
(117, 10, 10, 17, '/static/chapters/17-demonslayer.jpg'),
(118, 10, 10, 18, '/static/chapters/18-demonslayer.jpg'),
(119, 10, 10, 19, '/static/chapters/19-demonslayer.jpg'),
(120, 10, 10, 20, '/static/chapters/20-demonslayer.jpg'),
(121, 10, 11, 1, '/static/chapters/2.1-demonslayer.jpg'),
(122, 10, 11, 2, '/static/chapters/2.2-demonslayer.jpg'),
(123, 10, 11, 3, '/static/chapters/2.3-demonslayer.jpg'),
(124, 10, 11, 4, '/static/chapters/2.4-demonslayer.jpg'),
(125, 10, 11, 5, '/static/chapters/2.5-demonslayer.jpg'),
(151, 15, 151, 1, '/static/chapters/1-DB.jpg'),
(152, 15, 151, 2, '/static/chapters/2-DB.jpg'),
(153, 15, 151, 3, '/static/chapters/3-DB.jpg'),
(154, 15, 151, 4, '/static/chapters/4-DB.jpg'),
(155, 15, 151, 5, '/static/chapters/5-DB.jpg'),
(194, 55, 166, 1, '/static/chapters/hocvienanhhung/1-1.png'),
(199, 56, 174, 1, '/static/chapters/fairy-tail/1-1.png\r\n'),
(200, 56, 175, 1, '/static/chapters/fairy-tail/2-1.png'),
(201, 57, 176, 1, '/static/chapters/one-piece/1-1.png'),
(202, 58, 178, 1, '/static/chapters/detective-conan/1-1.png'),
(203, 58, 179, 1, '/static/chapters/detective-conan/2-1.png'),
(204, 59, 180, 1, '/static/chapters/attack-on-titan/1-1.png'),
(205, 59, 181, 1, '/static/chapters/attack-on-titan/2-1.png'),
(206, 59, 182, 1, '/static/chapters/attack-on-titan/3-1.png'),
(253, 10, 200, 1, '/static/chapters/KimetsuNoYaiba/3-1.png'),
(254, 10, 200, 2, '/static/chapters/KimetsuNoYaiba/3-2.png'),
(255, 10, 200, 3, '/static/chapters/KimetsuNoYaiba/3-3.png'),
(256, 10, 200, 4, '/static/chapters/KimetsuNoYaiba/3-4.png'),
(257, 10, 200, 5, '/static/chapters/KimetsuNoYaiba/3-5.png'),
(258, 10, 200, 6, '/static/chapters/KimetsuNoYaiba/3-6.png'),
(259, 10, 200, 7, '/static/chapters/KimetsuNoYaiba/3-7.png'),
(260, 10, 200, 8, '/static/chapters/KimetsuNoYaiba/3-8.png'),
(261, 10, 200, 9, '/static/chapters/KimetsuNoYaiba/3-9.png'),
(262, 10, 200, 10, '/static/chapters/KimetsuNoYaiba/3-10.png'),
(263, 10, 200, 11, '/static/chapters/KimetsuNoYaiba/3-11.png'),
(267, 5, 219, 1, '/static/chapters/slamdunk/1-1.png'),
(268, 12, 220, 1, '/static/chapters/NarutoShippuden/1-1.png'),
(269, 87, 221, 1, '/static/chapters/mashle-magic-and-muscles/1-1.png'),
(270, 87, 222, 1, '/static/chapters/mashle-magic-and-muscles/2-1.png'),
(271, 87, 223, 1, '/static/chapters/mashle-magic-and-muscles/3-1.png'),
(272, 88, 224, 1, '/static/chapters/gachiakuta/1-1.png'),
(273, 78, 225, 1, '/static/chapters/howtofight/1-1.png'),
(275, 14, 227, 1, '/static/chapters/CaptainTsubasa/1-1.png'),
(276, 14, 228, 1, '/static/chapters/CaptainTsubasa/2-1.png'),
(277, 14, 229, 1, '/static/chapters/CaptainTsubasa/3-1.png');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comics`
--

CREATE TABLE `comics` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `authors` text DEFAULT NULL,
  `latest_chapter` varchar(50) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `audience` enum('con_gai','con_trai') DEFAULT 'con_gai',
  `status` enum('Đang cập nhật','Hoàn thành') DEFAULT NULL,
  `country` enum('Trung Quốc','Việt Nam','Hàn Quốc','Nhật Bản','Mỹ') DEFAULT 'Nhật Bản',
  `view_count` int(11) DEFAULT 0,
  `is_hidden` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `comics`
--

INSERT INTO `comics` (`id`, `title`, `slug`, `cover_url`, `description`, `authors`, `latest_chapter`, `updated_at`, `audience`, `status`, `country`, `view_count`, `is_hidden`) VALUES
(1, 'Vương Hậu Đi Học', 'vuonghaudihoc', '/static/img/vuong-hau-di-hoc.jpg', NULL, NULL, 'Chapter 60', '2025-09-20 10:04:32', 'con_gai', 'Đang cập nhật', 'Hàn Quốc', 0, 0),
(2, 'I Am Cool', 'iamcool', '/static/img/cool.jpg', 'Bộ truyện lấy bối cảnh chính tại Trường Trung học Suzuran (tên gọi khác là \"Trường Quạ\" vì chỉ có những kẻ cá biệt, đầu gấu mới theo học), một ngôi trường nổi tiếng với bạo lực và những cuộc chiến tranh giành vị thế giữa các băng nhóm học sinh. Mục tiêu cao nhất của mọi học sinh Suzuran là thống trị được ngôi trường này.', NULL, 'Chapter 4', '2025-09-19 10:04:32', 'con_gai', 'Đang cập nhật', 'Trung Quốc', 0, 0),
(3, 'Go To Go', 'gotogo', '/static/img/go-to-go.jpg', NULL, NULL, 'Chapter 1', '2025-09-19 10:04:32', 'con_gai', 'Đang cập nhật', 'Nhật Bản', 0, 0),
(5, 'Slam Dunk', 'slamdunk', '/static/img/Slamdunk.jpg', 'Slam Dunk là một bộ manga (và sau đó là anime) huyền thoại về đề tài bóng rổ, được sáng tác bởi Inoue Takehiko. Bộ truyện này được xem là một trong những tác phẩm có ảnh hưởng lớn nhất đến thể loại manga thể thao và đã truyền cảm hứng cho rất nhiều thế hệ yêu bóng rổ.', 'thanhtuan', '1', '2025-10-16 01:05:22', '', 'Hoàn thành', 'Nhật Bản', 1, 0),
(8, 'Dr Stone', 'DrStone', '/static/img/DrStone.jpg', ' Dr. Stone là một bộ manga/anime khoa học viễn tưởng, sinh tồn và phiêu lưu rất độc đáo, được viết bởi Inagaki Riichiro và minh họa bởi Boichi.', NULL, NULL, '2025-09-30 21:15:43', '', 'Hoàn thành', 'Hàn Quốc', 0, 0),
(10, 'Kimetsu No Yaiba', 'KimetsuNoYaiba', '/static/img/KimetsuNoYaiba.jpg', '\r\nThanh Gươm Diệt Quỷ (Tên gốc: Kimetsu no Yaiba) là một bộ manga/anime nổi tiếng của tác giả Koyoharu Gotouge, thuộc thể loại giả tưởng đen tối (dark fantasy) và hành động kiếm thuật.\r\n\r\nBộ truyện lấy bối cảnh tại Nhật Bản thời Taisho, nơi những con quỷ ăn thịt người ẩn nấp trong bóng tối và chỉ xuất hiện vào ban đêm.', 'Koyoharu Gotouge', '3', '2025-10-12 22:07:34', '', 'Đang cập nhật', 'Nhật Bản', 2389812, 0),
(11, 'Gintama', 'Gintama', '/static/img/Gintama.jpg', 'Gintama (Tên gốc: Ngân Hồn) là một bộ manga/anime độc nhất vô nhị của tác giả Sorachi Hideaki, nổi tiếng với sự kết hợp hỗn loạn giữa hài kịch, châm biếm, khoa học viễn tưởng và hành động samurai nghiêm túc.', NULL, NULL, '2025-09-30 21:24:17', '', 'Hoàn thành', 'Hàn Quốc', 0, 0),
(12, 'Naruto Shippuden', 'NarutoShippuden', '/static/img/Naruto.jpg', 'Cốt truyện của Shippuden bắt đầu hai năm rưỡi sau khi phần Naruto (phần I) kết thúc. Trong thời gian này, nhân vật chính Uzumaki Naruto đã rời Làng Lá (Konoha) để theo học và luyện tập cùng một trong ba Sannin huyền thoại, Jiraiya.\r\n\r\nKhi trở về, Naruto đã trưởng thành hơn, mạnh mẽ hơn và quyết tâm hơn bao giờ hết.', NULL, '1', '2025-10-15 13:57:15', '', 'Đang cập nhật', 'Nhật Bản', 0, 0),
(13, 'Pokemon', 'Pokemon', '/static/img/Pokemon.jpg', 'Thế giới Pokémon là một vũ trụ nơi con người và các sinh vật được gọi là Pokémon cùng tồn tại. Pokémon là những sinh vật sở hữu nhiều sức mạnh và khả năng đặc biệt. Chúng có thể tiến hóa, học chiêu thức và thường sống hài hòa với con người.\r\n\r\nCon người tương tác với Pokémon chủ yếu thông qua việc trở thành Huấn Luyện Viên Pokémon (Pokémon Trainer). Huấn Luyện Viên sẽ bắt, nuôi dưỡng và huấn luyện Pokémon của mình.', NULL, NULL, '2025-09-30 21:25:45', '', 'Hoàn thành', 'Nhật Bản', 0, 0),
(14, 'Captain Tsubasa', 'CaptainTsubasa', '/static/img/Tsubasa.jpg', 'Captain Tsubasa (Tên gốc: Tsubasa – Giấc mơ sân cỏ) là bộ manga/anime kinh điển về bóng đá của tác giả Takahashi Yōichi, đã truyền cảm hứng cho vô số cầu thủ chuyên nghiệp và người hâm mộ bóng đá trên toàn thế giới.', 'thanhtuan', '3', '2025-10-16 00:54:38', '', 'Hoàn thành', 'Nhật Bản', 7899, 0),
(15, 'Dragon Ball – Frieza Hồi Sinh', 'DragonBall', '/static/img/dragonball.png', 'Đây là một bộ phim hoạt hình điện ảnh ra mắt năm 2015 và là phần tiếp theo của Dragon Ball Z: Battle of Gods. Cốt truyện chính có thể tóm tắt ngắn gọn như sau:', NULL, '3', '2025-09-30 22:16:44', '', 'Đang cập nhật', 'Nhật Bản', 6786554, 0),
(16, 'One Punch Man', 'onepunchman', '/static/img/onepunchman.jpg', 'Onepunch-Man là một Manga thể loại siêu anh hùng với đặc trưng phồng tôm đấm phát chết luôn… Lol!!! Nhân vật chính trong Onepunch-man là Saitama, một con người mà nhìn đâu cũng thấy “tầm thường”, từ khuôn mặt vô hồn, cái đầu trọc lóc, cho tới thể hình long tong. Tuy nhiên, con người nhìn thì tầm thường này lại chuyên giải quyết những vấn đề hết sức bất thường. Anh thực chất chính là một siêu anh hùng luôn tìm kiếm cho mình một đối thủ mạnh. Vấn đề là, cứ mỗi lần bắt gặp một đối thủ tiềm năng, thì đối thủ nào cũng như đối thủ nào, chỉ ăn một đấm của anh là… chết luôn. Liệu rằng Onepunch-Man Saitaman có thể tìm được cho mình một kẻ ác dữ dằn đủ sức đấu với anh? Hãy theo bước Saitama trên con đường một đấm tìm đối cực kỳ hài hước của anh!!', 'Murata Yuusuke, One', 'Chapter 60', '2025-09-30 23:07:52', '', 'Đang cập nhật', 'Nhật Bản', 0, 0),
(17, 'Jujutsu Kaisen - Chú Thuật Hồi Chiến', 'JujutsuKaisen', '/static/img/jujutsukaisen.jpg', 'Yuuji Itadori là một thiên tài có tốc độ và sức mạnh, nhưng cậu ấy muốn dành thời gian của mình trong Câu lạc bộ Tâm Linh. Một ngày sau cái chết của ông mình, anh gặp Megumi Fushiguro, người đang tìm kiếm vật thể bị nguyền rủa mà các thành viên CLB đã tìm thấy.\r\n\r\n \r\n\r\nĐối mặt với những con quái vật khủng khiếp bị \"Ám\", Yuuji nuốt vật thể bị phong ấn để có được sức mạnh của nó và cứu bạn bè của mình! Nhưng giờ Yuuji là người bị \"Ám\", và cậu ấy sẽ bị kéo vào thế giới ma quỷ ly kỳ của Megumi và những con quái vật độc ác ...', 'Akutami Gege', 'Chapter 273', '2025-09-24 23:15:23', '', 'Đang cập nhật', 'Nhật Bản', 4576, 0),
(18, 'Blue Lock', 'BlueLock', '/static/img/blue-lock.jpg', 'Tên khác: Blue Lock (FULL HD); Bluelock\r\n\r\nYoichi Isagi đã bỏ lỡ cơ hội tham dự giải Cao Trung toàn quốc do đã chuyền cho đồng đội thay vì tự thân mình dứt điểm. Cậu là một trong 300 chân sút U-18 được tuyển chọn bởi Jinpachi Ego, người đàn ông được Hiệp Hội Bóng Đá Nhật Bản thuê sau hồi FIFA World Cup năm 2018, nhằm dẫn dắt Nhật Bản vô địch World Cup bằng cách tiêu diệt nền bóng đá Nhật Bản. Kế hoạch của Ego gồm việc cô lập 300 tay sút trong một nhà ngục - dưới một tổ chức với tên gọi là \"Blue Lock\", với mục tiêu là tạo ra chân sút \"tự phụ\" nhất thế giới, điều mà nền bóng đá Nhật Bản còn thiếu.', 'Kaneshiro Muneyuki, Nomura Yuusuke', 'Chapter 318', '2025-09-30 23:20:30', '', 'Đang cập nhật', 'Nhật Bản', 0, 0),
(19, 'Fairy Tail: Nhiệm Vụ 100 Năm', 'fairytail', '/static/img/fairytail.jpg', 'Fairy Tail là một bộ manga/anime thuộc thể loại giả tưởng, phiêu lưu và hành động nổi tiếng của tác giả Mashima Hiro. Bộ truyện lấy bối cảnh là một thế giới phép thuật, nơi sức mạnh của tình bạn và sự gắn kết được đề cao.\r\n\r\nCâu chuyện diễn ra ở Earth-land, một thế giới tràn ngập phép thuật và các Pháp sư (Mages) tập hợp thành những bang hội (Guilds) để nhận nhiệm vụ và kiếm sống. Hội Fairy Tail là một trong những bang hội nổi tiếng nhất, được biết đến không chỉ vì sức mạnh mà còn vì bản tính phá hoại và tinh thần tự do, ngang tàng.', NULL, 'Chapter 1093', '2025-09-25 23:22:34', '', 'Đang cập nhật', 'Nhật Bản', 56743, 0),
(21, 'Tokyo Revengers', 'Tokyo Revengers', '/static/img/tokyo_revengers.jpg', 'Takemichi, thanh niên thất nghiệp còn trinh, được biết rằng người con gái đầu tiên và cũng là duy nhất cho đến bây giờ mà anh hẹn hò từ trung học đã chết. Sau một vụ tai nạn, anh ta thấy mình được quay về những ngày cấp hai. Anh ta thề sẽ thay đổi tương lai và giữ lấy người con gái ấy, để làm việc đó, anh ta quyết định sẽ vươn lên làm trùm băng đảng khét tiếng nhất ở vùng Kantou. ', NULL, 'Chapter 60', '2025-09-22 01:42:46', '', 'Đang cập nhật', 'Nhật Bản', 0, 0),
(55, 'Học viện anh hùng', 'hocvienanhhung', '/static/img/hocvienanhhung-1760194500.jpg', 'Vào tương lai, lúc mà con người với những sức mạnh siêu nhiên là điều thường thấy quanh thế giới. Đây là câu chuyện về Izuku Midoriya, từ một kẻ bất tài trở thành một siêu anh hùng. Tất cả ta cần là mơ ước.', 'Đang cập nhật', '2', '2025-10-12 12:32:02', NULL, 'Đang cập nhật', 'Nhật Bản', 0, 0),
(56, 'Fairy Tail', 'fairy-tail', '/static/img/fairy-tail-1760199667.png', 'Xin đón chào các bạn đến với Fairy Tail – một thế giới tràn đầy phép thuật, những pháp sư có thể hô mưa, gọi gió, những con mèo biết bay và những quái vật trong truyền thuyết. Tại vùng đất Fiore, bạn sẽ gặp được tổ chức Fairy Tail, một tổ chức pháp sư có những thành viên vui tính, thú vị và mạnh mẽ nhất. Câu chuyện bắt đầu khi cô gái trẻ Lucy, người có khả năng kêu gọi các tinh linh và ước mơ được gia nhập một tổ chức phù thủy gặp được hỏa pháp sư Natsu đang trên đường tìm kiếm cha nuôi của mình tại thị trấn cảng Harujion… Trong Fairy Tail, bạn sẽ gặp gỡ cặp “chó mèo” Natsu “khạc ra lửa” và “xơi lửa” cùng Gray “băng giá”, Lucy, Erza tài giỏi và “sexy”, theo kèm là những chú mèo ngộ nghĩnh cùng rất nhiều các pháp sư với đủ loại phép thuật kỳ lạ.', 'Hiro Mashima', '2', '2025-10-11 23:47:26', NULL, 'Hoàn thành', 'Nhật Bản', 0, 0),
(57, 'One piece', 'one-piece', '/static/img/one-piece-1760232136.jpg', 'One Piece là câu truyện kể về Luffy và các thuyền viên của mình. Khi còn nhỏ, Luffy ước mơ trở thành Vua Hải Tặc. Cuộc sống của cậu bé thay đổi khi cậu vô tình có được sức mạnh có thể co dãn như cao su, nhưng đổi lại, cậu không bao giờ có thể bơi được nữa. Giờ đây, Luffy cùng những người bạn hải tặc của mình ra khơi tìm kiếm kho báu One Piece, kho báu vĩ đại nhất trên thế giới. Trong One Piece, mỗi nhân vật trong đều mang một nét cá tính đặc sắc kết hợp cùng các tình huống kịch tính, lối dẫn truyện hấp dẫn chứa đầy các bước ngoặt bất ngờ và cũng vô cùng hài hước đã biến One Piece trở thành một trong những bộ truyện nổi tiếng nhất không thể bỏ qua. Hãy đọc One Piece để hòa mình vào một thế giới của những hải tặc rộng lớn, đầy màu sắc, sống động và thú vị, cùng đắm chìm với những nhân vật yêu tự do, trên hành trình đi tìm ước mơ của mình.', 'Eiichiro Oda', '1', '2025-10-12 08:22:16', NULL, 'Đang cập nhật', 'Nhật Bản', 0, 0),
(58, 'Detective Conan', 'detective-conan', '/static/img/detective-conan-1760232649.jpg', 'Nhân vật chính của truyện là một thám tử học sinh trung học có tên là Kudo Shinichi, người đã bị biến thành một cậu bé cỡ học sinh tiểu học và luôn cố gắng truy tìm tung tích tổ chức Áo Đen nhằm lấy lại hình dáng cũ.', 'Aoyama Gōshō', '2', '2025-10-12 08:45:03', NULL, 'Đang cập nhật', 'Nhật Bản', 486589, 0),
(59, 'Attack on Titan', 'attack-on-titan', '/static/img/attack-on-titan-1760234461.jpg', 'Hơn 100 năm trước, giống người khổng lồ Titan đã tấn công và đẩy loài người tới bờ vực tuyệt chủng. Những con người sống sót tụ tập lại, xây bao quanh mình 1 tòa thành 3 lớp kiên cố và tự nhốt mình bên trong để trốn tránh những cuộc tấn công của người khổng lồ. Họ tìm mọi cách để tiêu diệt người khổng lồ nhưng không thành công. Và sau 1 thế kỉ hòa bình, giống khổng lồ đã xuất hiện trở lại, một lần nữa đe dọa sự tồn vong của con người....  Elen và Mikasa phải chứng kiến một cảnh tượng cực kinh khủng - mẹ của mình bị ăn thịt ngay trước mắt. Elen thề rằng cậu sẽ giết tất cả những tên khổng lồ mà cậu gặp.....', 'Hajime Isayama', '3', '2025-10-12 09:14:18', NULL, 'Đang cập nhật', 'Nhật Bản', 43654, 0),
(78, 'How To Fight', 'howtofight', '/static/img/ho-1760283469.jpg', 'Câu chuyện xoay quanh Yoo Hobin, một nam sinh trung học có vẻ ngoài bình thường, thậm chí là yếu đuối. Cậu luôn là mục tiêu của những kẻ bắt nạt trong trường, bị sỉ nhục và không có cách nào phản kháng. Cuộc sống của Hobin dường như không lối thoát, cho đến một ngày, một sự kiện bất ngờ đã thay đổi tất cả.', 'Taejun Park', '1', '2025-10-15 14:29:56', NULL, 'Đang cập nhật', 'Nhật Bản', 453, 0),
(83, 'Black Clover - Thế Giới Phép Thuật', 'black-clover', '/static/img/black-clover.jpg', 'Aster và Yuno là hai đứa trẻ bị bỏ rơi ở nhà thờ và cùng nhau lớn lên tại đó. Khi còn nhỏ, chúng đã hứa với nhau xem ai sẽ trở thành Ma pháp vương tiếp theo. Thế nhưng, khi cả hai lớn lên, mọi sô chuyện đã thay đổi. Yuno là thiên tài ma pháp với sức mạnh tuyệt đỉnh trong khi Aster lại không thể sử dụng ma pháp và cố gắng bù đắp bằng thể lực. Khi cả hai được nhận sách phép vào tuổi 15, Yuno đã được ban cuốn sách phép cỏ bốn bá (trong khi đa số là cỏ ba lá) mà Aster lại không có cuốn nào. Tuy nhiên, khi Yuno bị đe dọa, sự thật về sức mạnh của Aster đã được giải mã- cậu ta được ban cuốn sách phép cỏ năm lá, cuốn sách phá ma thuật màu đen. Bấy giờ, hai người bạn trẻ đang hướng ra thế giới, cùng chung mục tiêu.', 'Tabata Yuuki', NULL, '2025-10-13 02:13:51', NULL, 'Đang cập nhật', 'Nhật Bản', 0, 0),
(87, 'Mashle: Magic And Muscles', 'mashle-magic-and-muscles', '/static/img/mashle-magic-and-muscles_1580393483.jpg', 'Ngày xửa ngày xưa, có một thế giới nơi phép thuật có thể chi phối mọi thứ. Nhưng sâu trong rừng có một thanh niên dành thời gian để luyện tập cơ bắp. Mặc dù không thể sử dụng phép thuật, nhưng cậu ta có một cuộc sống yên bình với cha mình. Rồi một ngày, cuộc sống của cậu gặp nguy hiểm! Cơ thể của Saitama sẽ bảo vệ cậu ta khỏi những pháp sư? Cơ bắp được luyện tập của cậu có thể sánh vai với các pháp sư ưu tú ...? Câu chuyện về Saitama ở Hogwarts bắt đầu!', 'Hajime Komoto', '3', '2025-10-15 14:13:16', NULL, 'Đang cập nhật', '', 5541, 0),
(88, 'Gachiakuta', 'gachiakuta', '/static/img/gachiakuta.jpg', 'Thành phố, nơi các tầng lớp văn minh sinh sống - khu ổ chuột nơi tụ tập các đời con cháu của bọn tội phạm, hằng ngày đều bị người khác sỉ nhục, khinh bỉ, gọi họ là những thứ rác rưởi, lũ \"dân tộc\" gớm ghiếc, hai mặt trái của xã hội được ngăn cách bởi những bức tường cao vút, và bên dưới nơi ấy - Abyss - một bãi rác nơi bọn tội phạm bị lưu đày, ngay cả những người dân của khu ổ chuột dù đã quen sống bẩn thỉu nhưng vẫn rất sợ nơi này. Một cậu bé mồ côi - Rudo sống trong khu ổ chuột với người cha nuôi Regto sống sót bằng cách thực hiện các hoạt động tội phạm. Mặc sức Regto khuyên ngăn, Rudo vẫn không có ý định dừng lại vì cậu ta tin rằng đó là cách duy nhất để kiếm tiền và giúp đỡ Regto vì đã nuôi dạy cậu. Nhưng một ngày nọ, khi về đến nhà, những hình ảnh quen thuộc thường ngày được thay thế bằng một cảnh tượng mà cậu không thể nào tin được. Regto đã bị sát hại còn cậu thì bị buộc tội giết người. Bị kết án xuống Vực thẳm - địa ngục ghê tởm ấy, Rudo đã gào thét, thề với tất cả sự giận dữ lẫn nỗi thất vọng trong mình rằng chắc chắn cậu sẽ giết kẻ gây án và tiêu diệt tất cả những người đã buộc tội cậu sát hại gia đình mình.', ' Gachi Akuta', '1', '2025-10-15 14:21:40', NULL, 'Đang cập nhật', 'Nhật Bản', 1, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comic_genres`
--

CREATE TABLE `comic_genres` (
  `comic_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `comic_genres`
--

INSERT INTO `comic_genres` (`comic_id`, `genre_id`) VALUES
(3, 1),
(5, 8),
(8, 5),
(10, 1),
(10, 6),
(14, 7),
(15, 1),
(16, 1),
(18, 7),
(78, 1),
(78, 3),
(78, 5),
(78, 6),
(78, 8),
(83, 1),
(83, 3),
(83, 5),
(83, 6),
(87, 1),
(87, 3),
(87, 6),
(88, 1),
(88, 2),
(88, 5),
(88, 6),
(88, 8);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `comments`
--

INSERT INTO `comments` (`id`, `comic_id`, `user_id`, `content`, `created_at`) VALUES
(1, 55, 1, 'truyện hay', '2025-10-13 03:38:10'),
(2, 59, 1, 'hay quá', '2025-10-13 03:51:49'),
(17, 59, 10, 'ngầu', '2025-10-13 04:10:42'),
(18, 10, 12, 'khang kiki', '2025-10-13 05:37:51'),
(19, 88, 12, 'aaa', '2025-10-15 14:21:51'),
(20, 78, 12, 'giau co\\', '2025-10-15 14:42:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `discussions`
--

CREATE TABLE `discussions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(120) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `follows`
--

CREATE TABLE `follows` (
  `user_id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `follows`
--

INSERT INTO `follows` (`user_id`, `comic_id`, `created_at`) VALUES
(1, 10, '2025-10-13 02:29:01'),
(1, 14, '2025-10-08 22:40:03'),
(1, 15, '2025-10-13 03:24:56'),
(1, 21, '2025-10-13 03:24:43'),
(1, 55, '2025-10-13 02:42:42'),
(1, 56, '2025-10-13 02:42:48'),
(1, 57, '2025-10-13 02:42:45'),
(1, 58, '2025-10-13 02:42:34'),
(1, 83, '2025-10-17 03:02:45'),
(10, 10, '2025-10-09 14:00:53'),
(10, 15, '2025-10-09 14:00:59'),
(10, 78, '2025-10-15 14:43:39'),
(11, 14, '2025-10-08 22:51:23'),
(12, 10, '2025-10-09 13:34:33'),
(12, 12, '2025-10-09 14:40:44'),
(12, 14, '2025-10-08 22:55:43'),
(12, 15, '2025-10-09 14:40:16'),
(12, 59, '2025-10-12 23:55:59'),
(12, 78, '2025-10-15 15:00:40'),
(12, 87, '2025-10-16 01:06:44'),
(12, 88, '2025-10-15 15:02:16'),
(13, 10, '2025-10-16 01:11:57'),
(13, 11, '2025-10-08 23:01:53'),
(13, 14, '2025-10-08 23:01:57'),
(13, 58, '2025-10-16 01:12:28'),
(13, 78, '2025-10-16 01:11:53'),
(13, 87, '2025-10-16 01:11:42'),
(14, 12, '2025-10-09 14:49:50'),
(14, 14, '2025-10-09 14:49:47'),
(14, 15, '2025-10-09 14:49:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `genres`
--

CREATE TABLE `genres` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `slug` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `genres`
--

INSERT INTO `genres` (`id`, `name`, `slug`) VALUES
(1, 'Hành động', 'hanh-dong'),
(2, 'Phiêu lưu', 'phieu-luu'),
(3, 'Hài hước', 'hai-huoc'),
(4, 'Lãng mạn', 'lang-man'),
(5, 'Dramma', 'dramma'),
(6, 'Giả tưởng', 'gia-tuong'),
(7, 'Thể thao', 'the-thao'),
(8, 'Học đường', 'hoc-duong');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `message`, `is_read`, `created_at`) VALUES
(1, 1, 'Bạn vừa theo dõi Attack on Titan', 1, '2025-10-13 01:52:51'),
(2, 1, 'Chương mới của One Piece đã ra!', 1, '2025-10-13 01:52:51'),
(3, 1, 'Bạn đã theo dõi truyện Detective Conan', 1, '2025-10-13 02:42:34'),
(4, 1, 'Bạn đã theo dõi truyện Học viện anh hùng', 1, '2025-10-13 02:42:42'),
(5, 1, 'Bạn đã theo dõi truyện One piece', 1, '2025-10-13 02:42:45'),
(6, 1, 'Bạn đã theo dõi truyện Fairy Tail', 1, '2025-10-13 02:42:48'),
(7, 1, 'Bạn đã theo dõi truyện Gachiakuta', 1, '2025-10-13 02:42:52'),
(8, 1, 'Bạn đã theo dõi truyện How To Fight', 1, '2025-10-13 02:46:21'),
(9, 1, 'Bạn đã thích truyện Học viện anh hùng', 1, '2025-10-13 02:53:32'),
(10, 1, 'Bạn đã thích truyện Tokyo Revengers', 1, '2025-10-13 03:24:42'),
(11, 1, 'Bạn đã theo dõi truyện Tokyo Revengers', 1, '2025-10-13 03:24:43'),
(12, 1, 'Bạn đã theo dõi truyện Dragon Ball – Frieza Hồi Sinh', 1, '2025-10-13 03:24:56'),
(13, 1, 'Bạn đã thích truyện Dragon Ball – Frieza Hồi Sinh', 1, '2025-10-13 03:24:57'),
(14, 1, 'Bạn đã thích truyện Captain Tsubasa', 1, '2025-10-13 03:32:15'),
(15, 1, 'Bạn đã bình luận một truyện', 1, '2025-10-13 03:38:10'),
(16, 1, 'Bạn đã bình luận một truyện', 1, '2025-10-13 03:51:49'),
(17, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:00:05'),
(18, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:01:21'),
(19, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:01:23'),
(20, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:01:25'),
(21, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:01:29'),
(22, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:08'),
(23, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:10'),
(24, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:12'),
(25, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:13'),
(26, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:15'),
(27, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:17'),
(28, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:18'),
(29, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:19'),
(30, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:06:20'),
(31, 10, 'Bạn đã bình luận một truyện', 1, '2025-10-13 04:10:42'),
(32, 1, 'Truyện mới: cc', 1, '2025-10-13 04:22:27'),
(33, 12, 'Truyện mới: cc', 1, '2025-10-13 04:22:27'),
(34, 13, 'Truyện mới: cc', 1, '2025-10-13 04:22:27'),
(35, 14, 'Truyện mới: cc', 0, '2025-10-13 04:22:27'),
(36, 11, 'Truyện mới: cc', 0, '2025-10-13 04:22:27'),
(37, 10, 'Truyện mới: cc', 1, '2025-10-13 04:22:27'),
(39, 1, 'Truyện mới: aa', 1, '2025-10-13 04:22:56'),
(40, 12, 'Truyện mới: aa', 1, '2025-10-13 04:22:56'),
(41, 13, 'Truyện mới: aa', 1, '2025-10-13 04:22:56'),
(42, 14, 'Truyện mới: aa', 0, '2025-10-13 04:22:56'),
(43, 11, 'Truyện mới: aa', 0, '2025-10-13 04:22:56'),
(44, 10, 'Truyện mới: aa', 1, '2025-10-13 04:22:56'),
(46, 1, 'Truyện mới: tt', 1, '2025-10-13 04:23:34'),
(47, 12, 'Truyện mới: tt', 1, '2025-10-13 04:23:34'),
(48, 13, 'Truyện mới: tt', 1, '2025-10-13 04:23:34'),
(49, 14, 'Truyện mới: tt', 0, '2025-10-13 04:23:34'),
(50, 11, 'Truyện mới: tt', 0, '2025-10-13 04:23:34'),
(51, 10, 'Truyện mới: tt', 1, '2025-10-13 04:23:34'),
(53, 12, 'Bạn đã theo dõi truyện Dịch Vụ Thuê Bạn Gái', 1, '2025-10-13 04:25:07'),
(54, 12, 'Bạn đã thích truyện Dịch Vụ Thuê Bạn Gái', 1, '2025-10-13 04:25:08'),
(55, 12, 'Bạn đã thích truyện Dịch Vụ Thuê Bạn Gái', 1, '2025-10-13 04:25:09'),
(56, 1, 'Chương 1: 1 của How To Fight đã ra!', 1, '2025-10-13 04:29:03'),
(57, 12, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-13 05:03:54'),
(58, 12, 'Bạn đã bình luận một truyện', 1, '2025-10-13 05:37:51'),
(59, 12, 'Chương 1: Naruto Shippuden của Naruto Shippuden đã ra!', 1, '2025-10-15 13:57:15'),
(60, 14, 'Chương 1: Naruto Shippuden của Naruto Shippuden đã ra!', 0, '2025-10-15 13:57:15'),
(62, 12, 'Bạn đã bình luận một truyện', 1, '2025-10-15 14:21:51'),
(63, 1, 'Chương 1: Bi kịch bắt nạt của How To Fight đã ra!', 1, '2025-10-15 14:29:56'),
(64, 1, 'Chương 1 của Captain Tsubasa đã ra!', 1, '2025-10-15 14:32:31'),
(65, 11, 'Chương 1 của Captain Tsubasa đã ra!', 0, '2025-10-15 14:32:31'),
(66, 12, 'Chương 1 của Captain Tsubasa đã ra!', 1, '2025-10-15 14:32:31'),
(67, 13, 'Chương 1 của Captain Tsubasa đã ra!', 1, '2025-10-15 14:32:31'),
(68, 14, 'Chương 1 của Captain Tsubasa đã ra!', 0, '2025-10-15 14:32:31'),
(71, 1, 'Chương 1: Tung cánh bay lên của Captain Tsubasa đã ra!', 1, '2025-10-15 14:36:33'),
(72, 11, 'Chương 1: Tung cánh bay lên của Captain Tsubasa đã ra!', 0, '2025-10-15 14:36:33'),
(73, 12, 'Chương 1: Tung cánh bay lên của Captain Tsubasa đã ra!', 1, '2025-10-15 14:36:33'),
(74, 13, 'Chương 1: Tung cánh bay lên của Captain Tsubasa đã ra!', 1, '2025-10-15 14:36:33'),
(75, 14, 'Chương 1: Tung cánh bay lên của Captain Tsubasa đã ra!', 0, '2025-10-15 14:36:33'),
(78, 1, 'Chương 2: Vút bay của Captain Tsubasa đã ra!', 1, '2025-10-15 14:38:51'),
(79, 11, 'Chương 2: Vút bay của Captain Tsubasa đã ra!', 0, '2025-10-15 14:38:51'),
(80, 12, 'Chương 2: Vút bay của Captain Tsubasa đã ra!', 1, '2025-10-15 14:38:51'),
(81, 13, 'Chương 2: Vút bay của Captain Tsubasa đã ra!', 1, '2025-10-15 14:38:51'),
(82, 14, 'Chương 2: Vút bay của Captain Tsubasa đã ra!', 0, '2025-10-15 14:38:51'),
(85, 1, 'Chương 3: Clb bóng đá mới - NANKATSU của Captain Tsubasa đã ra!', 1, '2025-10-15 14:41:56'),
(86, 11, 'Chương 3: Clb bóng đá mới - NANKATSU của Captain Tsubasa đã ra!', 0, '2025-10-15 14:41:56'),
(87, 12, 'Chương 3: Clb bóng đá mới - NANKATSU của Captain Tsubasa đã ra!', 1, '2025-10-15 14:41:56'),
(88, 13, 'Chương 3: Clb bóng đá mới - NANKATSU của Captain Tsubasa đã ra!', 1, '2025-10-15 14:41:56'),
(89, 14, 'Chương 3: Clb bóng đá mới - NANKATSU của Captain Tsubasa đã ra!', 0, '2025-10-15 14:41:56'),
(92, 12, 'Bạn đã bình luận một truyện', 1, '2025-10-15 14:42:43'),
(93, 10, 'Bạn đã theo dõi truyện How To Fight', 1, '2025-10-15 14:43:39'),
(94, 10, 'Bạn đã thích truyện How To Fight', 1, '2025-10-15 14:43:39'),
(95, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 14:45:38'),
(96, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 14:46:47'),
(97, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → 日本語 (Japanese)', 1, '2025-10-15 14:52:47'),
(98, 10, 'Đã gửi yêu cầu dịch: doraemon - Chương 1 → 日本語 (Japanese)', 1, '2025-10-15 14:53:11'),
(99, 10, 'Đã gửi yêu cầu dịch: doraemon - Chương 1 → English', 1, '2025-10-15 14:54:29'),
(100, 10, 'Đã gửi yêu cầu dịch: doraemon - Chương 1 → English', 1, '2025-10-15 14:54:54'),
(101, 10, 'Đã gửi yêu cầu dịch: doraemon - Chương 1 → 日本語 (Japanese)', 1, '2025-10-15 14:55:35'),
(102, 12, 'Bạn đã theo dõi truyện How To Fight', 1, '2025-10-15 15:00:40'),
(103, 12, 'Bạn đã thích truyện How To Fight', 1, '2025-10-15 15:00:40'),
(104, 12, 'Bạn đã theo dõi truyện Gachiakuta', 1, '2025-10-15 15:02:16'),
(105, 12, 'Bạn đã thích truyện Gachiakuta', 1, '2025-10-15 15:02:16'),
(106, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 15:39:27'),
(107, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 15:41:11'),
(108, 10, 'Đã nhận yêu cầu dịch: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 15:42:34'),
(109, 12, 'Hệ thống đã nhận yêu cầu dịch mới: doraemon - Chương 1 → Tiếng Việt', 1, '2025-10-15 15:42:34'),
(110, 12, 'Bạn đã thích truyện Mashle: Magic And Muscles', 1, '2025-10-16 01:06:43'),
(111, 12, 'Bạn đã theo dõi truyện Mashle: Magic And Muscles', 1, '2025-10-16 01:06:44'),
(112, 13, 'Bạn đã theo dõi truyện Mashle: Magic And Muscles', 1, '2025-10-16 01:11:42'),
(113, 13, 'Bạn đã thích truyện Mashle: Magic And Muscles', 1, '2025-10-16 01:11:43'),
(114, 13, 'Bạn đã theo dõi truyện How To Fight', 1, '2025-10-16 01:11:53'),
(115, 13, 'Bạn đã thích truyện How To Fight', 1, '2025-10-16 01:11:53'),
(116, 13, 'Bạn đã theo dõi truyện Kimetsu No Yaiba', 1, '2025-10-16 01:11:57'),
(117, 13, 'Bạn đã thích truyện Kimetsu No Yaiba', 1, '2025-10-16 01:11:58'),
(118, 13, 'Bạn đã theo dõi truyện Detective Conan', 1, '2025-10-16 01:12:28'),
(119, 13, 'Bạn đã thích truyện Detective Conan', 1, '2025-10-16 01:12:29'),
(120, 1, 'Đã nhận yêu cầu dịch: demon slayer - Chương 2 → English', 1, '2025-10-17 02:40:52'),
(121, 12, 'Hệ thống đã nhận yêu cầu dịch mới: demon slayer - Chương 2 → English', 1, '2025-10-17 02:40:52'),
(122, 1, 'Đã gửi yêu cầu dịch: demon slayer - Chương 1 → 日本語 (Japanese)', 1, '2025-10-17 02:43:57'),
(123, 12, 'Hệ thống đã nhận yêu cầu dịch mới: demon slayer - Chương 1 → 日本語 (Japanese)', 1, '2025-10-17 02:43:57'),
(124, 1, 'Bạn đã theo dõi truyện Black Clover - Thế Giới Phép Thuật', 1, '2025-10-17 03:02:45'),
(125, 1, 'Bạn đã thích truyện Black Clover - Thế Giới Phép Thuật', 1, '2025-10-17 03:02:46'),
(126, 1, 'Bạn đã thích truyện Dragon Ball – Frieza Hồi Sinh', 0, '2025-10-17 03:03:34'),
(127, 12, 'Bạn đã thích truyện Captain Tsubasa', 1, '2025-10-17 08:54:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_likes`
--

CREATE TABLE `post_likes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_likes`
--

INSERT INTO `post_likes` (`id`, `user_id`, `comic_id`, `created_at`) VALUES
(15, 12, 12, '2025-10-11 14:23:51'),
(16, 12, 10, '2025-10-11 14:23:53'),
(20, 10, 15, '2025-10-11 15:10:31'),
(22, 12, 59, '2025-10-12 16:56:00'),
(24, 1, 10, '2025-10-12 19:29:02'),
(32, 10, 78, '2025-10-15 07:43:39'),
(33, 12, 78, '2025-10-15 08:00:40'),
(34, 12, 88, '2025-10-15 08:02:16'),
(35, 12, 87, '2025-10-15 18:06:43'),
(36, 13, 87, '2025-10-15 18:11:43'),
(37, 13, 78, '2025-10-15 18:11:53'),
(38, 13, 10, '2025-10-15 18:11:58'),
(39, 13, 58, '2025-10-15 18:12:29'),
(40, 1, 83, '2025-10-16 20:02:46'),
(41, 1, 15, '2025-10-16 20:03:34'),
(42, 12, 14, '2025-10-17 01:54:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ratings`
--

INSERT INTO `ratings` (`id`, `comic_id`, `user_id`, `rating`, `created_at`) VALUES
(1, 87, 12, 5, '2025-10-15 08:54:19'),
(8, 87, 10, 5, '2025-10-15 08:55:49'),
(12, 14, 10, 5, '2025-10-15 09:16:38'),
(13, 14, 12, 4, '2025-10-15 16:45:05'),
(14, 5, 12, 5, '2025-10-15 18:05:04'),
(15, 88, 12, 5, '2025-10-15 18:06:51'),
(16, 10, 12, 5, '2025-10-15 18:07:13'),
(17, 87, 13, 5, '2025-10-15 18:11:41'),
(18, 78, 13, 5, '2025-10-15 18:11:52'),
(19, 58, 13, 5, '2025-10-15 18:12:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reading_history`
--

CREATE TABLE `reading_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comic_id` int(11) NOT NULL,
  `viewed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `reading_history`
--

INSERT INTO `reading_history` (`id`, `user_id`, `comic_id`, `viewed_at`) VALUES
(1, 1, 1, '2025-09-21 18:15:25'),
(2, 1, 1, '2025-09-21 18:16:49'),
(5, 1, 1, '2025-09-21 18:17:27'),
(6, 1, 2, '2025-09-21 18:17:28'),
(7, 1, 3, '2025-09-21 18:17:29'),
(12, 1, 5, '2025-09-21 18:42:14'),
(15, 10, 5, '2025-09-21 19:00:01'),
(17, 10, 5, '2025-09-21 19:00:35'),
(22, 10, 5, '2025-09-21 19:14:17'),
(26, 10, 5, '2025-09-21 19:19:34'),
(27, 10, 5, '2025-09-21 19:19:38'),
(33, 10, 5, '2025-09-21 19:29:12'),
(34, 10, 5, '2025-09-21 19:29:34'),
(36, 10, 5, '2025-09-21 19:31:45'),
(55, 1, 10, '2025-09-30 14:40:26'),
(56, 1, 10, '2025-09-30 14:40:27'),
(57, 1, 10, '2025-09-30 14:40:29'),
(58, 1, 10, '2025-09-30 14:40:36'),
(59, 1, 10, '2025-09-30 14:44:52'),
(60, 1, 10, '2025-09-30 14:49:42'),
(61, 1, 10, '2025-09-30 14:49:44'),
(68, 1, 15, '2025-09-30 15:26:08'),
(69, 1, 15, '2025-09-30 15:26:33'),
(71, 10, 10, '2025-09-30 17:04:06'),
(72, 10, 15, '2025-09-30 17:04:18'),
(73, 11, 15, '2025-09-30 20:06:26'),
(74, 11, 15, '2025-09-30 20:06:34'),
(75, 10, 10, '2025-09-30 20:30:46'),
(76, 10, 10, '2025-09-30 20:32:14'),
(77, 10, 10, '2025-09-30 20:40:31'),
(78, 10, 10, '2025-09-30 20:47:26'),
(79, 10, 10, '2025-09-30 20:47:54'),
(80, 10, 10, '2025-09-30 20:48:33'),
(81, 10, 10, '2025-09-30 20:58:56'),
(82, 10, 10, '2025-09-30 21:16:47'),
(83, 10, 10, '2025-09-30 21:18:55'),
(84, 10, 10, '2025-09-30 21:19:45'),
(85, 10, 10, '2025-09-30 21:20:01'),
(86, 10, 10, '2025-09-30 21:21:22'),
(87, 10, 10, '2025-09-30 21:21:24'),
(88, 10, 10, '2025-09-30 21:21:52'),
(89, 10, 10, '2025-09-30 21:21:59'),
(90, 10, 10, '2025-09-30 21:23:14'),
(91, 10, 10, '2025-09-30 21:23:39'),
(92, 10, 10, '2025-09-30 21:47:45'),
(93, 10, 10, '2025-09-30 21:47:47'),
(94, 10, 10, '2025-09-30 21:48:36'),
(95, 10, 10, '2025-09-30 22:05:58'),
(96, 10, 10, '2025-09-30 22:07:59'),
(97, 10, 10, '2025-09-30 22:10:08'),
(98, 10, 10, '2025-09-30 22:12:36'),
(99, 10, 10, '2025-09-30 22:12:53'),
(100, 10, 10, '2025-09-30 22:13:11'),
(101, 10, 10, '2025-09-30 22:13:42'),
(102, 10, 10, '2025-09-30 22:14:07'),
(103, 10, 10, '2025-09-30 22:14:30'),
(104, 10, 10, '2025-09-30 22:18:40'),
(105, 10, 10, '2025-09-30 22:18:49'),
(106, 10, 10, '2025-09-30 22:21:07'),
(107, 10, 10, '2025-09-30 22:29:44'),
(108, 10, 10, '2025-09-30 22:31:33'),
(109, 10, 10, '2025-09-30 22:31:40'),
(110, 10, 10, '2025-09-30 22:31:45'),
(111, 10, 10, '2025-09-30 22:32:45'),
(112, 10, 10, '2025-09-30 22:32:47'),
(113, 10, 10, '2025-09-30 22:32:49'),
(114, 10, 10, '2025-09-30 22:32:52'),
(115, 10, 10, '2025-09-30 22:32:53'),
(116, 11, 10, '2025-09-30 22:43:20'),
(117, 11, 15, '2025-09-30 22:54:49'),
(118, 11, 15, '2025-09-30 22:57:12'),
(119, 11, 15, '2025-09-30 22:58:02'),
(120, 11, 15, '2025-09-30 22:58:23'),
(121, 11, 15, '2025-09-30 22:59:57'),
(122, 11, 15, '2025-09-30 23:01:24'),
(123, 11, 15, '2025-09-30 23:02:50'),
(124, 11, 15, '2025-09-30 23:03:19'),
(125, 11, 10, '2025-09-30 23:03:26'),
(126, 10, 10, '2025-10-01 00:25:58'),
(127, 10, 10, '2025-10-01 00:26:03'),
(128, 10, 15, '2025-10-01 00:27:21'),
(129, 10, 15, '2025-10-01 00:27:21'),
(130, 1, 15, '2025-10-01 00:52:56'),
(132, 1, 10, '2025-10-01 01:09:03'),
(133, 1, 10, '2025-10-01 07:30:00'),
(134, 1, 15, '2025-10-01 07:33:36'),
(135, 1, 15, '2025-10-01 07:33:44'),
(136, 1, 15, '2025-10-01 07:33:47'),
(137, 1, 15, '2025-10-01 07:39:03'),
(138, 1, 10, '2025-10-01 07:41:29'),
(139, 1, 15, '2025-10-01 07:42:13'),
(140, 1, 15, '2025-10-01 07:42:21'),
(141, 1, 15, '2025-10-01 07:43:25'),
(142, 1, 10, '2025-10-01 07:48:36'),
(143, 1, 10, '2025-10-01 07:48:51'),
(144, 1, 10, '2025-10-01 07:48:57'),
(146, 10, 15, '2025-10-01 08:17:39'),
(147, 10, 15, '2025-10-01 08:18:12'),
(148, 10, 10, '2025-10-01 08:20:17'),
(149, 10, 10, '2025-10-05 01:39:44'),
(150, 10, 10, '2025-10-05 01:40:02'),
(151, 10, 10, '2025-10-05 01:40:19'),
(152, 10, 15, '2025-10-05 03:03:13'),
(153, 10, 10, '2025-10-08 05:18:51'),
(159, 12, 10, '2025-10-08 14:04:26'),
(160, 12, 15, '2025-10-08 14:04:46'),
(161, 13, 10, '2025-10-08 16:02:12'),
(162, 13, 15, '2025-10-08 16:02:24'),
(163, 12, 10, '2025-10-09 06:36:12'),
(164, 10, 10, '2025-10-09 07:06:05'),
(167, 10, 15, '2025-10-09 12:35:51'),
(168, 10, 15, '2025-10-09 12:36:04'),
(169, 12, 10, '2025-10-09 15:52:09'),
(178, 12, 16, '2025-10-11 14:36:20'),
(179, 12, 16, '2025-10-11 14:44:35'),
(180, 12, 55, '2025-10-11 14:55:19'),
(181, 12, 55, '2025-10-11 14:57:09'),
(182, 12, 55, '2025-10-11 15:12:36'),
(183, 12, 55, '2025-10-11 15:12:45'),
(184, 12, 55, '2025-10-11 15:13:47'),
(185, 12, 55, '2025-10-11 15:14:31'),
(186, 12, 55, '2025-10-11 15:23:18'),
(187, 12, 55, '2025-10-11 15:30:58'),
(188, 12, 55, '2025-10-11 15:33:42'),
(189, 12, 55, '2025-10-11 15:33:44'),
(190, 12, 55, '2025-10-11 15:33:46'),
(191, 12, 55, '2025-10-11 15:33:50'),
(192, 12, 55, '2025-10-11 15:34:01'),
(193, 12, 56, '2025-10-11 16:21:30'),
(194, 12, 56, '2025-10-11 16:35:50'),
(195, 12, 56, '2025-10-11 16:47:29'),
(196, 12, 56, '2025-10-11 16:49:11'),
(197, 12, 56, '2025-10-11 16:51:33'),
(198, 12, 56, '2025-10-11 16:51:37'),
(199, 12, 56, '2025-10-11 16:53:04'),
(200, 12, 56, '2025-10-11 16:53:12'),
(201, 12, 56, '2025-10-11 16:53:15'),
(202, 12, 56, '2025-10-11 16:53:22'),
(203, 12, 56, '2025-10-11 16:54:05'),
(204, 12, 56, '2025-10-11 16:55:29'),
(205, 12, 56, '2025-10-11 16:56:24'),
(206, 12, 55, '2025-10-11 17:02:57'),
(207, 12, 56, '2025-10-11 17:03:51'),
(208, 12, 10, '2025-10-11 17:07:53'),
(209, 12, 10, '2025-10-11 17:35:57'),
(210, 12, 10, '2025-10-11 17:36:00'),
(211, 12, 10, '2025-10-11 17:36:02'),
(212, 12, 10, '2025-10-12 01:14:25'),
(213, 12, 57, '2025-10-12 01:22:25'),
(214, 12, 58, '2025-10-12 01:40:33'),
(215, 12, 58, '2025-10-12 01:45:05'),
(216, 12, 58, '2025-10-12 01:49:51'),
(217, 12, 59, '2025-10-12 02:02:46'),
(218, 12, 59, '2025-10-12 02:08:35'),
(219, 12, 59, '2025-10-12 02:14:23'),
(220, 12, 10, '2025-10-12 02:19:41'),
(229, 12, 56, '2025-10-12 04:46:31'),
(230, 12, 55, '2025-10-12 05:31:54'),
(231, 12, 10, '2025-10-12 15:05:45'),
(232, 12, 10, '2025-10-12 15:07:38'),
(233, 12, 10, '2025-10-12 15:08:50'),
(236, 12, 10, '2025-10-12 15:13:04'),
(237, 12, 57, '2025-10-12 15:14:30'),
(238, 1, 58, '2025-10-12 17:53:54'),
(239, 12, 15, '2025-10-12 18:32:15'),
(240, 10, 15, '2025-10-12 21:14:01'),
(245, 12, 78, '2025-10-12 21:28:47'),
(246, 12, 78, '2025-10-12 21:29:14'),
(247, 12, 55, '2025-10-12 21:30:47'),
(248, 12, 59, '2025-10-15 06:54:43'),
(249, 12, 5, '2025-10-15 06:56:14'),
(250, 12, 12, '2025-10-15 06:57:16'),
(251, 12, 87, '2025-10-15 07:11:53'),
(252, 12, 87, '2025-10-15 07:13:18'),
(253, 12, 78, '2025-10-15 07:22:28'),
(254, 12, 78, '2025-10-15 07:29:57'),
(255, 12, 14, '2025-10-15 07:32:33'),
(256, 12, 14, '2025-10-15 07:36:35'),
(257, 12, 14, '2025-10-15 07:38:54'),
(258, 12, 14, '2025-10-15 07:41:59'),
(259, 12, 87, '2025-10-15 08:49:37'),
(260, 12, 87, '2025-10-15 08:49:42'),
(261, 12, 87, '2025-10-15 08:49:46'),
(262, 12, 87, '2025-10-15 08:49:53'),
(263, 12, 5, '2025-10-15 18:05:26'),
(264, 12, 88, '2025-10-15 18:06:55'),
(265, 12, 10, '2025-10-15 18:07:14'),
(266, 12, 10, '2025-10-15 18:07:26'),
(267, 12, 10, '2025-10-15 18:07:52'),
(268, 13, 87, '2025-10-15 18:11:48'),
(269, 13, 10, '2025-10-15 18:12:00'),
(270, 13, 10, '2025-10-15 18:12:08'),
(271, 13, 10, '2025-10-15 18:12:16'),
(272, 13, 10, '2025-10-15 18:12:22'),
(273, 1, 10, '2025-10-16 19:36:59');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `translate_requests`
--

CREATE TABLE `translate_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(200) NOT NULL,
  `comic_title` varchar(255) NOT NULL,
  `chapter` varchar(64) NOT NULL,
  `lang_to` varchar(64) NOT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `translate_requests`
--

INSERT INTO `translate_requests` (`id`, `user_id`, `name`, `email`, `comic_title`, `chapter`, `lang_to`, `note`, `created_at`) VALUES
(1, 12, 'thanhtuan', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', NULL, '2025-10-13 05:03:54'),
(2, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', '11111', '2025-10-15 14:45:38'),
(3, 10, 'dh22tin07', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', NULL, '2025-10-15 14:46:47'),
(4, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', '日本語 (Japanese)', NULL, '2025-10-15 14:52:47'),
(5, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', '日本語 (Japanese)', NULL, '2025-10-15 14:53:11'),
(6, 10, 'dh22tin07', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'English', NULL, '2025-10-15 14:54:29'),
(7, 10, 'thanh tuấn nguyễn', 'admin@shop.com', 'doraemon', '1', 'English', NULL, '2025-10-15 14:54:54'),
(8, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', '日本語 (Japanese)', NULL, '2025-10-15 14:55:35'),
(9, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', NULL, '2025-10-15 15:39:27'),
(10, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', NULL, '2025-10-15 15:41:11'),
(11, 10, 'thanh tuấn nguyễn', 'nthanhtuan765@gmail.com', 'doraemon', '1', 'Tiếng Việt', NULL, '2025-10-15 15:42:34'),
(12, 1, 'thanhtuan', 'admin@shop.com', 'demon slayer', '2', 'English', 'kkk', '2025-10-17 02:40:52'),
(13, 1, 'thanh tuấn nguyễn', 'thanhtuan100804@gmail.com', 'demon slayer', '1', '日本語 (Japanese)', NULL, '2025-10-17 02:43:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT '/static/img/default-avatar.png',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `phone` varchar(20) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `avatar_url`, `created_at`, `phone`, `bio`, `role`) VALUES
(1, '123', '123@gmail.com', 'scrypt:32768:8:1$eyXg6DBJWkIKwOoq$3e7e0203d2f8eab13feb51a78b02e4058cabddc487e075d2c26031e0542bfe7c45dfdcd3a25b7bafa93fc00b85c90a7653f32cc37b0ac2e9ceb77cfca40d2703', '/static/uploads/u1_o-1760188267.png', '2025-09-17 15:45:49', '0349120201', 'no', 'user'),
(10, 'tuan', 'tuan@gmail.com', 'scrypt:32768:8:1$ZGIoAw2ZXXtjpRvo$6cb1a433ae280ac6bd5956b21102c120b9241e47b21980a92fd0546d5dffdefb1957dd4041dbc0e82d2cb763858ed06b7558d1d3c89d7d74fba66000b02fbd3b', '/static/uploads/u10_jack3.png', '2025-09-20 13:51:38', '0349120201', 'nguyenthanhtuan', 'user'),
(11, 'thanh', 'thanh@gmail.com', 'scrypt:32768:8:1$iUzyvDLomwGmP3mm$37be56d2f556669a504698e3d64a7ba5f804b2b4a3c41d67f956f1bffeb37312b6468aa8bb76b658cf6736959b7c6cf07c68f04eb507527b1a0614943a000c07', '/static/uploads/u11_jack9.png', '2025-09-20 14:22:33', '0349120201', '0', 'user'),
(12, 'admin', 'admin@gmail.com', 'scrypt:32768:8:1$hX9Rv8ykuXBwnejg$abc40640131eed11067435740b182571e1c50331a5f5474e745440ac5a8e28e1689d65f6a0403b763cfd479d5efde9866b2854fbfb74af3324bdb182c6a0956d', '/static/uploads/u12_avt_default.png', '2025-10-08 05:21:21', '', '', 'admin'),
(13, 'khang', 'khang@gmail.com', 'scrypt:32768:8:1$zZE7yKFoLICMtF0C$5d4d9f8bee387f53d9c1f97b0a11b93d3db93eeb3845d56c4861641afbc8e73106f7c53836fc3985127d57aa4e3391876d6ed9f0249540be4dfe00e9ce68b846', '/static/uploads/u13_khang.jpg', '2025-10-08 16:00:06', '0395855414', 'khang kiki', 'user'),
(14, 'son', 'son@gmail.com', 'scrypt:32768:8:1$ghhb4lH6QUc8jEda$9e85677520df3fa558f93c4e2087254b7e40bb75e5bcffe0ba35079422f3f21b5bb9576c6a8588abcbe9a8b30265eabbef59112fa41d89bc71f4857bb1dc1c2d', '/static/uploads/u14_son.jpg', '2025-10-08 16:03:43', '', 'cá heo ngoài khơi', 'user');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chapters`
--
ALTER TABLE `chapters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_comic_chapter` (`comic_id`,`number`);

--
-- Chỉ mục cho bảng `chapter_images`
--
ALTER TABLE `chapter_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comic_id` (`comic_id`),
  ADD KEY `chapter_id` (`chapter_id`);

--
-- Chỉ mục cho bảng `comics`
--
ALTER TABLE `comics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);
ALTER TABLE `comics` ADD FULLTEXT KEY `ft_comics` (`title`,`description`,`authors`);

--
-- Chỉ mục cho bảng `comic_genres`
--
ALTER TABLE `comic_genres`
  ADD PRIMARY KEY (`comic_id`,`genre_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Chỉ mục cho bảng `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_comic` (`comic_id`);

--
-- Chỉ mục cho bảng `discussions`
--
ALTER TABLE `discussions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_user` (`user_id`,`created_at`);

--
-- Chỉ mục cho bảng `follows`
--
ALTER TABLE `follows`
  ADD PRIMARY KEY (`user_id`,`comic_id`),
  ADD KEY `comic_id` (`comic_id`);

--
-- Chỉ mục cho bảng `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_comic` (`user_id`,`comic_id`);

--
-- Chỉ mục cho bảng `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `comic_id` (`comic_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `reading_history`
--
ALTER TABLE `reading_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `comic_id` (`comic_id`);

--
-- Chỉ mục cho bảng `translate_requests`
--
ALTER TABLE `translate_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `chapters`
--
ALTER TABLE `chapters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT cho bảng `chapter_images`
--
ALTER TABLE `chapter_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=278;

--
-- AUTO_INCREMENT cho bảng `comics`
--
ALTER TABLE `comics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `discussions`
--
ALTER TABLE `discussions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `genres`
--
ALTER TABLE `genres`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT cho bảng `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `reading_history`
--
ALTER TABLE `reading_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=274;

--
-- AUTO_INCREMENT cho bảng `translate_requests`
--
ALTER TABLE `translate_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chapters`
--
ALTER TABLE `chapters`
  ADD CONSTRAINT `chapters_ibfk_1` FOREIGN KEY (`comic_id`) REFERENCES `comics` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `chapter_images`
--
ALTER TABLE `chapter_images`
  ADD CONSTRAINT `chapter_images_ibfk_1` FOREIGN KEY (`comic_id`) REFERENCES `comics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chapter_images_ibfk_2` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `comic_genres`
--
ALTER TABLE `comic_genres`
  ADD CONSTRAINT `comic_genres_ibfk_1` FOREIGN KEY (`comic_id`) REFERENCES `comics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comic_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`comic_id`) REFERENCES `comics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `reading_history`
--
ALTER TABLE `reading_history`
  ADD CONSTRAINT `reading_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reading_history_ibfk_2` FOREIGN KEY (`comic_id`) REFERENCES `comics` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
