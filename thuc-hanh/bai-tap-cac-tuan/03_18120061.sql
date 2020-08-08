--Q27. Cho"biết"số"lượng"giáo"viên"viên"và"tổng"lương"của"họ."
SELECT COUNT(*) AS N'Số lượng giáo viên', SUM(gv.LUONG) AS N'Tổng lương'
FROM dbo.GIAOVIEN AS gv
--Q28. Cho"biết"số"lượng"giáo"viên"và"lương"trung"bình"của"từng"bộ"môn."
SELECT  bm.MABM, bm.TENBM, COUNT(*) AS N'Số lượng giáo viên', AVG(gv.LUONG) AS N'Lương trung bình' 
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
GROUP BY bm.MABM, bm.TENBM
--Q29. Cho"biết"tên"chủ"đề"và"số"lượng"đề"tài"thuộc"về"chủ"đề"đó."
SELECT cd.MACD, cd.TENCD, COUNT(*) AS N'Số lượng'
FROM dbo.CHUDE AS cd JOIN dbo.DETAI AS dt ON dt.MACD = cd.MACD
GROUP BY cd.MACD, cd.TENCD
--Q30. Cho"biết"tên"giáo"viên"và"số"lượng"đề"tài"mà"giáo"viên"đó"tham"gia."
SELECT gv.MAGV, gv.HOTEN, COUNT(*) AS SLDT
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON gv.MAGV = tg.MAGV
GROUP BY gv.MAGV, gv.HOTEN
--Q31. Cho"biết"tên"giáo"viên"và"số"lượng"đề"tài"mà"giáo"viên"đó"làm"chủ"nhiệm."
SELECT gv.MAGV, gv.HOTEN, COUNT(*) AS SLDT
FROM dbo.GIAOVIEN AS gv JOIN dbo.DETAI AS dt ON dt.GVCNDT = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN
--Q32. Với"mỗi"giáo"viên"cho"tên"giáo"viên"và"số"người"thân"của"giáo"viên"đó."
SELECT gv.HOTEN, COUNT(*) AS N'Số người thân'
FROM dbo.GIAOVIEN AS gv JOIN dbo.NGUOITHAN AS nt ON nt.MAGV = gv.MAGV
GROUP BY gv.HOTEN
--Q33. Cho"biết"tên"những"giáo"viên"đã"tham"gia"từ"3"đề"tài"trở"lên."
SELECT gv.MAGV, gv.HOTEN, COUNT(*) AS SLDT
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON gv.MAGV = tg.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(*) > 3
--Q34. Cho"biết"số"lượng"giáo"viên"đã"tham"gia"vào"đề"tài"Ứng"dụng"hóa"học"xanh."
SELECT COUNT(*) AS N'Số lượng giáo viên'
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
JOIN dbo.DETAI AS dt ON dt.MADT = tg.MADT
WHERE dt.TENDT = N'Ứng"dụng"hóa"học"xanh'
