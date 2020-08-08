-- Q1. Cho biết họ tên và mức lương của các giáo viên nữ
SELECT gv.HOTEN, gv.LUONG
FROM dbo.GIAOVIEN AS gv
WHERE gv.PHAI = N'Nữ'

-- Q2. Cho biết họ tên của các giao viên và lương của họ sau khi tăng 10%
SELECT gv.HOTEN, gv.LUONG + gv.LUONG*0.1 AS [Lương mới]
FROM dbo.GIAOVIEN AS gv

-- Q3. Cho biết mã của các giáo viên có họ tên bắt đầu là "Nguyễn" và lương trên 2000 hoặc giáo viên là trưởng bộ môn nhận chức sau năm 1995
SELECT gv.MAGV
FROM dbo.GIAOVIEN AS gv, dbo.BOMON AS bm
WHERE gv.HOTEN LIKE 'Nguyễn%' AND gv.LUONG > 2000 OR (bm.TRUONGBM = gv.MAGV AND YEAR(bm.NGAYNHANCHUC) > 1995)

-- Q4. Cho biết tên những giáo viên khoa Công nghệ thông tin
SELECT gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
JOIN dbo.KHOA AS k ON k.MAKHOA = bm.MAKHOA
WHERE k.TENKHOA = N'Công nghệ thông tin'

-- Q5. Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
SELECT *
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV

-- Q6. Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
SELECT *
FROM dbo.BOMON AS bm JOIN dbo.GIAOVIEN AS gv ON gv.MABM = bm.MABM

-- Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
SELECT dt.TENDT, gv.HOTEN AS [Giáo viên chủ nhiệm đề tài]
FROM dbo.DETAI AS dt JOIN dbo.GIAOVIEN AS gv ON gv.MAGV = dt.GVCNDT

-- Q8. Với mỗi khoa cho biết thông tin của trưởng khoa
SELECT *
FROM dbo.KHOA AS k JOIN dbo.GIAOVIEN AS gv ON gv.MAGV = k.TRUONGKHOA

-- Q9. Cho biết các giáo viên của bộ môn 'Vi sinh' có tham gia đề tài 006
SELECT DISTINCT gv.MAGV, gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
WHERE bm.TENBM = N'Vi sinh' AND tg.MADT = '006'

-- Q10. Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng ngày sinh và địa chỉ của người ấy
SELECT dt.MADT, cd.TENCD, gv.HOTEN, gv.NGSINH, gv.DIACHI
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV JOIN dbo.CHUDE AS cd ON cd.MACD = dt.MACD
WHERE dt.CAPQL = N'Thành phố'

-- Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT gv1.HOTEN AS [Họ tên giáo viên], gv2.HOTEN AS [Người phụ trách chuyên môn]
FROM dbo.GIAOVIEN AS gv1 JOIN dbo.GIAOVIEN AS gv2 ON gv2.GVQLCM = gv1.MAGV

-- Q12. Tìm họ tên của những giáo viên được "Nguyễn Thành Tùng" phụ trách trực tiếp
SELECT gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.GIAOVIEN AS gvpt ON gvpt.GVQLCM = gv.MAGV
WHERE gvpt.HOTEN = N'Nguyễn Thanh Tùng'

-- Q13. Cho biết tên giáo viên là trưởng bộ môn Hệ thống thông tin
SELECT gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV
WHERE bm.TENBM = N'Hệ thống thông tin'

-- Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục
SELECT DISTINCT gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV
JOIN dbo.CHUDE AS cd ON cd.MACD = dt.MACD
WHERE cd.TENCD = N'Quản lý giáo dục'

-- Q15. Co biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008
SELECT cv.TENCV
FROM dbo.DETAI AS dt JOIN dbo.CONGVIEC AS cv ON cv.MADT = dt.MADT
WHERE dt.TENDT = N'HTTT quản lý các trường ĐH'
AND MONTH(cv.NGAYBD) = 3

-- Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
SELECT gv1.HOTEN AS [Họ tên giáo viên], gv2.HOTEN AS [Người phụ trách chuyên môn]
FROM dbo.GIAOVIEN AS gv1 JOIN dbo.GIAOVIEN AS gv2 ON gv2.GVQLCM = gv1.MAGV

-- Q17. Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
SELECT *
FROM dbo.CONGVIEC AS cv
WHERE cv.NGAYBD <= CAST(N'01/08/2007' AS DATE) AND cv.NGAYBD >= CAST(N'01/01/2007' AS DATE)

-- Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên Trần Trà Hương
SELECT gv.HOTEN
FROM dbo.GIAOVIEN AS gv
WHERE gv.MABM = (SELECT  gv2.MABM
		FROM dbo.GIAOVIEN AS gv2
		WHERE gv2.HOTEN = N'Trần Trà Hương') AND gv.HOTEN != N'Trần Trà Hương'

--Q19. Tìm"những"giáo"viên"vừa"là"trưởng"bộ"môn"vừa"chủ"nhiệm"đề"tài."
SELECT gv.MAGV, gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV
INTERSECT
SELECT gv.MAGV, gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV
--Q20. Cho"biết"tên"những"giáo"viên"vừa"là"trưởng"khoa"và"vừa"là"trưởng"bộ"môn."
SELECT gv.HOTEN, k.TENKHOA, bm.TENBM
FROM dbo.GIAOVIEN AS gv JOIN dbo.KHOA AS k ON k.TRUONGKHOA = gv.MAGV
JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV
--Q21. Cho"biết"tên"những"trưởng"bộ"môn"mà"vừa"chủ"nhiệm"đề"tài""
SELECT DISTINCT gv.HOTEN
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV
JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV
--Q22. Cho"biết"mã"số"các"trưởng"khoa"có"chủ"nhiệm"đề"tài."
SELECT DISTINCT k.TRUONGKHOA
FROM dbo.GIAOVIEN AS gv JOIN dbo.KHOA AS k ON k.TRUONGKHOA = gv.MAGV
JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV
--Q23. Cho"biết"mã"số"các"giáo"viên"thuộc"bộ"môn"HTTT"hoặc"có"tham"gia"đề"tài"mã"001."
SELECT DISTINCT gv.MAGV
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
WHERE gv.MABM = 'HTTT' OR tg.MADT = '001'
--Q24. Cho"biết"giáo"viên"làm"việc"cùng"bộ"môn"với"giáo"viên"002."
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.MABM = (SELECT * FROM dbo.GIAOVIEN AS gv1 WHERE gv1.MAGV = '002' AND gv1.MABM = gv.MABM)
--Q25. Tìm"những"giáo"viên"là"trưởng"bộ"môn."
SELECT gv.MAGV, gv.HOTEN, bm.MABM, bm.TENBM
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.TRUONGBM = gv.MAGV
--Q26. Cho"biết"họ"tên"và"mức"lương"của"các"giáo"viên."
SELECT gv.HOTEN, gv.LUONG
FROM dbo.GIAOVIEN AS gv
