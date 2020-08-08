USE	QLDT
GO
-- Câu 01: Viết hàm truyền vào mã giáo viên cho biết số đề tài đã đạt mà giáo viên tham gia
CREATE FUNCTION _Fn_countingTopic (@MaGV CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @ret int
	SET @ret = (SELECT COUNT(DISTINCT tg.MADT) FROM dbo.THAMGIADT AS tg WHERE tg.MAGV = @MaGV GROUP BY tg.MAGV)
	RETURN @ret
END
GO
PRINT dbo._Fn_countingTopic('001')
GO
-- Câu 02: Cho biết thông tin giáo viên và số đề tài đạt của giáo viên tham gia mọi đề tài thuộc cấp trường
SELECT gv.*, dbo._Fn_countingTopic(gv.MAGV)
FROM dbo.GIAOVIEN AS gv, dbo.THAMGIADT AS tg, dbo.DETAI AS dt
WHERE gv.MAGV = tg.MAGV AND dt.MADT = tg.MADT AND dt.CAPQL = N'Trường'

-- Câu 03: Cài đặt stored procedure ‘Thêm tham gia đề tài’
IF OBJECT_ID('spThemThamGiaDT') IS NOT NULL
	DROP PROCEDURE spThemThamGiaDT
GO
CREATE PROCEDURE spThemThamGiaDT @MaGV CHAR(5), @MaDT CHAR(3), @Stt INT, @PhuCap FLOAT
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1
    -- B1. Kiểm tra MaGV, MaDT, STT hợp lệ và chưa tồn tại trong tham gia
	IF (NOT EXISTS(SELECT * FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV))
		BEGIN
			PRINT N'> Lỗi -> MaGV không hợp lệ.'
			SET @check = 0
		END
	IF (NOT EXISTS(SELECT * FROM dbo.DETAI AS dt WHERE dt.MADT = @MaDT))
		BEGIN
			PRINT N'> Lỗi -> MaDT không hợp lệ.'
			SET @check = 0
		END
	IF (NOT EXISTS(SELECT * FROM dbo.THAMGIADT AS tg WHERE tg.STT = tg.STT AND tg.PHUCAP = @PhuCap))
		BEGIN
			PRINT N'> Lỗi -> Stt, PhuCap không hợp lệ.'
			SET @check = 0
		END
	IF (NOT EXISTS(SELECT * FROM dbo.THAMGIADT AS tg WHERE tg.MAGV = @MaGV AND tg.MADT = @MaDT AND tg.STT = @Stt AND tg.PHUCAP = @PhuCap))
		BEGIN
			PRINT N'> Lỗi -> MaGV, MaDT, STT không hợp lệ do tồn tại trong tham gia.'
			SET @check = 0
		END
	-- B2. Kiểm tra phu cấp không rỗng và trong [0,10]
	IF @PhuCap < 0 OR @PhuCap > 10 OR @PhuCap = NULL
		BEGIN
			PRINT N'> Lỗi -> Phụ cấp rỗng hoặc không nằm trong [0,10].'
			SET @check = 0
		END
	-- B3. Kiểm tra MaGV chưa tham gia MaDT
	IF (NOT EXISTS(SELECT * FROM dbo.DETAI AS dt JOIN dbo.THAMGIADT AS tg ON tg.MADT = dt.MADT WHERE tg.MAGV = @MaGV))
		BEGIN
			PRINT N'> MaGV chưa tham gia MaDT.'
			-- B3.1. Thêm tham gia đề tài
			BEGIN
			INSERT INTO dbo.THAMGIADT
			(
			    MAGV,
			    MADT,
			    STT,
			    PHUCAP,
			    KETQUA
			)
			VALUES
			(   @MaGV,  -- MAGV - char(5)
			    @MaDT,  -- MADT - char(3)
			    @Stt,   -- STT - int
			    @PhuCap, -- PHUCAP - float
			    NULL  -- KETQUA - nvarchar(40)
			    )
			Print N'> Phân công thành công.'
			END
		END		
	-- B4. Kiểm tra MaGV đã tham gia MaDT
	IF (EXISTS(SELECT * FROM dbo.THAMGIADT AS tg WHERE tg.MAGV = @MaGV AND tg.MADT = tg.MADT))
		BEGIN
		    -- B4.1. Tìm một GV chưa tham gia MADT để phân công
			DECLARE @mgv CHAR(5)
			SET @mgv = (SELECT tg.MAGV FROM dbo.THAMGIADT AS tg EXCEPT SELECT * FROM dbo.THAMGIADT AS tg WHERE tg.MADT = @MaDT)
			INSERT INTO dbo.THAMGIADT
			(
			    MAGV,
			    MADT,
			    STT,
			    PHUCAP,
			    KETQUA
			)
			VALUES
			(   @mgv,  -- MAGV - char(5)
			    @MaDT,  -- MADT - char(3)
			    @Stt,   -- STT - int
			    @PhuCap, -- PHUCAP - float
			    NULL  -- KETQUA - nvarchar(40)
			    )
			Print N'> Phân công thành công.'
		END
END
GO




