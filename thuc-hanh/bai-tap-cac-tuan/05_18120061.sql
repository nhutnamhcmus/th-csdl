-- Q35. Cho biết lương cao nhất của các giảng viên
SELECT MAX(gv.LUONG) AS [Lương cao nhất]
FROM dbo.GIAOVIEN AS gv

-- Q36. Cho biết những giáo viên có lương lớn nhất
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.LUONG = (SELECT MAX(gv.LUONG)
					FROM dbo.GIAOVIEN AS gv
					)
-- Q37. Cho biết lương cao nhất trong bộ môn HTTT
SELECT gv.LUONG AS [Lương cao nhất]
FROM dbo.GIAOVIEN AS gv
WHERE gv.MABM = 'HTTT' AND gv.LUONG = (SELECT MAX(gv.LUONG)
										FROM dbo.GIAOVIEN AS gv
										WHERE gv.MABM = 'HTTT'
										)
SELECT MAX(gv.LUONG) AS [Lương cao nhất]
FROM dbo.GIAOVIEN AS gv
WHERE gv.MABM = 'HTTT'
-- SELECT * FROM dbo.GIAOVIEN AS gv WHERE gv.MABM = 'HTTT'

-- Q38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin
SELECT gv.HOTEN AS [Họ tên]
FROM dbo.GIAOVIEN AS gv
WHERE YEAR(gv.NGSINH) = (SELECT MIN(YEAR(gv.NGSINH))
							FROM dbo.GIAOVIEN AS gv 
							WHERE gv.MABM IN (SELECT bm.MABM
									FROM dbo.BOMON AS bm
									WHERE bm.TENBM = N'Hệ thống thông tin')
							)
AND gv.MABM IN (SELECT bm.MABM FROM dbo.BOMON AS bm WHERE bm.TENBM = N'Hệ thống thông tin')
-- Q39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin
SELECT gv.HOTEN AS [Họ tên], gv.NGSINH
FROM dbo.GIAOVIEN AS gv
WHERE YEAR(gv.NGSINH) = (SELECT MAX(YEAR(gv.NGSINH))
							FROM dbo.GIAOVIEN AS gv 
							WHERE gv.MABM IN (SELECT bm.MABM
									FROM dbo.BOMON AS bm
									WHERE bm.MAKHOA IN ( SELECT k.MAKHOA
														FROM dbo.KHOA AS k
														WHERE k.TENKHOA = N'Công nghệ thông tin'
														)
									)
							)
AND 
	MONTH(gv.NGSINH) = (SELECT MAX(MONTH(gv.NGSINH))
							FROM dbo.GIAOVIEN AS gv 
							WHERE gv.MABM IN (SELECT bm.MABM
									FROM dbo.BOMON AS bm
									WHERE bm.MAKHOA IN ( SELECT k.MAKHOA
														FROM dbo.KHOA AS k
														WHERE k.TENKHOA = N'Công nghệ thông tin'
														)
									)
							)
AND 
	DAY(gv.NGSINH) = (SELECT MAX(DAY(gv.NGSINH))
							FROM dbo.GIAOVIEN AS gv 
							WHERE gv.MABM IN (SELECT bm.MABM
									FROM dbo.BOMON AS bm
									WHERE bm.MAKHOA IN ( SELECT k.MAKHOA
														FROM dbo.KHOA AS k
														WHERE k.TENKHOA = N'Công nghệ thông tin'
														)
									)
							)

-- Q40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất
SELECT gv.HOTEN AS [Tên giáo viên], k.TENKHOA
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
JOIN dbo.KHOA AS k ON k.MAKHOA = bm.MAKHOA
WHERE gv.LUONG = (SELECT MAX(gv.LUONG)
					FROM dbo.GIAOVIEN AS gv
					)


-- Q41. Cho biết những giáo viên có lương cao nhất trong bộ môn của họ
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.LUONG >= ALL (SELECT gv1.LUONG
						FROM dbo.GIAOVIEN AS gv1
						WHERE gv.MABM = gv1.MABM 
						AND 
							gv.LUONG <> gv1.LUONG)

-- Q42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
SELECT dt.TENDT
FROM dbo.DETAI AS dt
WHERE dt.MADT NOT IN (SELECT tg.MADT
						FROM dbo.THAMGIADT AS tg
						WHERE tg.MAGV IN (
							SELECT gv.MAGV
							FROM dbo.GIAOVIEN AS gv
							WHERE gv.HOTEN = N'Nguyễn Hoài An'
						)
				)
-- Q43. Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài
SELECT dt.TENDT AS [Tên đề tài], gv.HOTEN AS [Người chủ nhiệm đề tài]
FROM dbo.DETAI AS dt, dbo.GIAOVIEN AS gv
WHERE dt.MADT NOT IN (SELECT tg.MADT
						FROM dbo.THAMGIADT AS tg
						WHERE tg.MAGV IN (
							SELECT gv.MAGV
							FROM dbo.GIAOVIEN AS gv
							WHERE gv.HOTEN = N'Nguyễn Hoài An'
						)
				)
AND 
	dt.GVCNDT = gv.MAGV

-- Q44. Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào
SELECT *
FROM (SELECT * 
		FROM dbo.GIAOVIEN AS gv
		WHERE gv.MABM IN (SELECT bm.MABM
							FROM dbo.BOMON AS bm
							WHERE bm.MAKHOA IN (SELECT k.MAKHOA
												FROM dbo.KHOA AS k
												WHERE k.TENKHOA = N'Công nghệ thông tin'
							)
						)
) AS GV
WHERE GV.MAGV NOT IN ( SELECT tg.MAGV
						FROM dbo.THAMGIADT AS tg
)


-- Q45. Tìm những giáo viên không tham gia bất kì đề tài nào
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.MAGV NOT IN (SELECT tg.MAGV
						FROM dbo.THAMGIADT AS tg)

-- Q46. Cho biết giáo viên có lương lớn hơn lương của giáo viên "Nguyễn Hoài An"
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.LUONG > (SELECT GV.LUONG
					FROM dbo.GIAOVIEN AS GV
					WHERE GV.HOTEN = N'Nguyễn Hoài An')

-- Q47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.MAGV IN (SELECT bm.TRUONGBM
					FROM dbo.BOMON AS bm
				)
AND 
	gv.MAGV IN (SELECT tg.MAGV
				FROM dbo.THAMGIADT AS tg)
-- Q48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE EXISTS (SELECT * 
				FROM dbo.GIAOVIEN AS GV
				WHERE GV.HOTEN = gv.HOTEN
				AND gv.PHAI = GV.PHAI
				AND gv.MAGV <> GV.MAGV
				)
-- Q49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn "Công nghệ phân mềm"
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.LUONG > ANY (SELECT *
						FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS bm
						WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Công nghệ phần mềm')
-- Q50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn "Hệ thống thông tin"
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE gv.LUONG > (SELECT MAX(GV.LUONG)
					FROM dbo.GIAOVIEN AS GV
					WHERE GV.MABM = (SELECT bm.MABM
										FROM dbo.BOMON AS bm
										WHERE bm.TENBM = N'Hệ thống thông tin')
				)

-- Q51. Cho biết tên khoa có đông giáo viên nhất
SELECT k.TENKHOA AS [Tên khoa]
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
JOIN dbo.KHOA AS k ON k.MAKHOA = bm.MAKHOA
GROUP BY k.MAKHOA, k.TENKHOA
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
						JOIN dbo.KHOA AS k ON k.MAKHOA = bm.MAKHOA
						GROUP BY k.MAKHOA
						)
-- Q52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT gv.HOTEN AS [Họ tên]
FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM dbo.GIAOVIEN AS gv JOIN dbo.THAMGIADT AS tg ON tg.MAGV = gv.MAGV
						GROUP BY gv.MAGV
						)
-- Q53. Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT bm.MABM AS [Mã bộ môn]
FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
GROUP BY bm.MABM
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM dbo.GIAOVIEN AS gv JOIN dbo.BOMON AS bm ON bm.MABM = gv.MABM
					GROUP BY bm.MABM
)
-- Q54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất
SELECT gv.HOTEN AS [Tên giáo viên], bm.TENBM AS [Tên bộ môn]
FROM dbo.GIAOVIEN AS gv, dbo.BOMON AS bm
WHERE gv.MABM = bm.MABM AND gv.MAGV IN (SELECT tg.MAGV
					FROM dbo.THAMGIADT AS tg
					GROUP BY tg.MAGV
					HAVING COUNT(DISTINCT tg.MADT) >= ALL
					(SELECT COUNT(DISTINCT TG.MADT)
						FROM dbo.THAMGIADT TG
						GROUP BY TG.MAGV
					)
				)
-- Q55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT
SELECT gv.HOTEN AS [Tên giáo viên]
FROM dbo.GIAOVIEN AS gv, dbo.BOMON AS bm
WHERE gv.MABM = bm.MABM AND gv.MAGV IN (SELECT tg.MAGV
					FROM dbo.THAMGIADT AS tg
					GROUP BY tg.MAGV
					HAVING COUNT(DISTINCT tg.MADT) >= ALL
					(SELECT COUNT(DISTINCT TG.MADT)
						FROM dbo.THAMGIADT TG
						GROUP BY TG.MAGV
					)
				) AND bm.TENBM = N'Hệ thống thông tin'
-- Q56. Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất
SELECT *
FROM dbo.GIAOVIEN AS gv
WHERE  gv.MAGV IN (SELECT NT.MAGV
					FROM dbo.NGUOITHAN AS NT
					GROUP BY NT.MAGV
					HAVING COUNT(*) >= ALL	(SELECT COUNT(*)
												FROM dbo.NGUOITHAN AS NT
												GROUP BY NT.MAGV
											)
					)
-- Q57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất
SELECT gv.HOTEN AS [Tên trưởng bộ môn]
FROM dbo.GIAOVIEN AS gv, dbo.BOMON AS bm
WHERE bm.TRUONGBM = gv.MAGV
AND gv.MAGV IN (SELECT dt.GVCNDT
					FROM dbo.DETAI AS dt
					GROUP BY dt.GVCNDT
					HAVING COUNT(*) >= ALL (SELECT COUNT(*)
											FROM dbo.DETAI AS DT
											GROUP BY DT.GVCNDT)
				)