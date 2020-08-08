-- Sinh vien: Le Nhut Nam
-- MSSV: 18120061
USE QLDT
GO 

-- BAI TAP TAI LOP
-- Cau a: In ra câu chào 'Hello World!!!'
IF OBJECT_ID('HELLO_WORLD') IS NOT NULL
	DROP PROCEDURE HELLO_WORLD
GO
CREATE PROCEDURE HELLO_WORLD
AS
BEGIN
	PRINT 'Hello World!!!'
END
GO
EXEC HELLO_WORLD
GO

-- câu b:
IF OBJECT_ID('sumOfTwoPrint') IS NOT NULL
	DROP PROCEDURE sumOfTwoPrint
GO
CREATE PROCEDURE sumOfTwoPrint @firstNumber INT, @secondNumber INT
AS
BEGIN
	DECLARE @Result INT
		SET @Result = @firstNumber + @secondNumber
		PRINT @Result
END
GO
Exec sumOfTwoPrint 1, -2
GO
-- Câu c: In ra tổng hai số
IF OBJECT_ID('sumOfTwoPrintOutput') IS NOT NULL
	DROP PROCEDURE sumOfTwoPrintOutput
GO
CREATE PROCEDURE sumOfTwoPrintOutput @firstNumber INT, @secondNumber INT, @Result INT OUT
AS
BEGIN
	SET @Result = @firstNumber + @secondNumber
END

GO
DECLARE @res INT
EXEC sumOfTwoPrintOutput 1, -2, @res OUTPUT
PRINT @res

--
IF OBJECT_ID('sumOfTwoNumber') IS NOT NULL
	DROP PROCEDURE sumOfTwoNumber
GO
CREATE PROCEDURE sumOfTwoNumber @number_1 INT, @number_2 INT
AS
BEGIN
	DECLARE @Result INT
		SET @result = @number_1 + @number_2
		RETURN @Result
END
GO

DECLARE @VAR INT
EXEC @VAR = sumOfTwoNumber 5, 10
PRINT @VAR
GO
-- Câu d: In ra tổng ba số
IF OBJECT_ID('sumOfThreeNumber') IS NOT NULL
	DROP PROCEDURE sumOfThreeNumber
GO

CREATE PROCEDURE sumOfThreeNumber @number_1 INT, @number_2 INT, @number_3 INT
AS
BEGIN
	DECLARE @Result INT
		EXEC @Result = sumOfTwoNumber @number_1, @number_2
		SET @Result = @Result + @number_3
		RETURN @Result
END
GO
DECLARE @VAR INT
EXEC @VAR = sumOfThreeNumber 5, 10, 15
PRINT @VAR
GO

-- câu e: 
IF OBJECT_ID('sumFromMtoN') IS NOT NULL
	DROP PROCEDURE sumFromMtoN
GO
CREATE PROCEDURE sumFromMtoN @M INT, @N INT
AS
BEGIN
		DECLARE @Sum INT
		DECLARE @Index INT
		SET @Sum = 0
		SET @Index = @M
		WHILE (@Index <= @N)
			BEGIN
				SET @Sum = @Sum + @Index
				SET @Index = @Index + 1
			END
		RETURN @Sum
END
GO
DECLARE @VAR INT
EXEC @VAR = sumFromMtoN 5, 10
PRINT @VAR
GO

-- câu f: 
IF OBJECT_ID('isPrime') IS NOT NULL
	DROP PROCEDURE isPrime
GO
CREATE PROCEDURE isPrime @number INT
AS
BEGIN
	DECLARE @Result BIT
		SET @Result = 1
		IF @number < 2
		BEGIN
			SET @Result = 0
			RETURN @Result
		END
		DECLARE @index INT
		SET @index = 2
		WHILE (@index < @number)
		BEGIN
			IF @number % @index = 0
			BEGIN
				SET @Result = 0
				RETURN @Result
			END
			SET @index = @index + 1
		END
		RETURN @Result
END
GO
DECLARE @VAR INT
EXEC @VAR = isPrime 1
IF @VAR = 1
	PRINT N'Đây là số nguyên tố'
ELSE
	PRINT N'Đây không là số nguyên tố'
GO

-- câu g:
IF OBJECT_ID('sumPrimtBetweenMandN') IS NOT NULL
	DROP PROCEDURE sumPrimtBetweenMandN
GO
CREATE PROCEDURE sumPrimtBetweenMandN @M INT, @N INT
AS
BEGIN
		DECLARE @Sum INT
		DECLARE @Index INT
		SET @Sum = 0
		SET @Index = @M
		WHILE (@Index <= @N)
		BEGIN
			DECLARE @check INT
			EXEC @check = isPrime @Index
			IF @check = 1
				BEGIN
					SET @Sum = @Sum + @Index
					SET @Index = @Index + 1
				END
			ELSE
				BEGIN
					SET @Index = @Index + 1
				END
		END
		RETURN @Sum
END
GO
DECLARE @RES INT
EXEC @RES = sumPrimtBetweenMandN 0, 10
PRINT @RES
GO

-- câu h:
IF OBJECT_ID('_gcd') IS NOT NULL
	DROP PROCEDURE _gcd
GO
CREATE PROCEDURE _gcd @a INT, @b INT
AS
BEGIN
	DECLARE @ret INT
	SET @a = ABS(@a)
	SET @b = ABS(@b)
	
	IF (@a = 0 OR @b = 0)
		BEGIN
			SET @ret = @a + @b
		END
	ELSE
		BEGIN
			While (@a <> @b)
			BEGIN
				IF (@a > @b)
					SET @a = @a - @b
				ELSE
					SET @b = @b - @a
			END
		END
	SET @ret = @a
	RETURN @ret
END
GO
DECLARE @RES INT
EXEC @RES = _gcd 105, 30
PRINT @RES
GO

-- function
IF OBJECT_ID('gcd') IS NOT NULL
	DROP FUNCTION gcd
GO
CREATE FUNCTION gcd (@a INT, @b INT)
RETURNS INT
AS
BEGIN
	DECLARE @ret INT
	SET @a = ABS(@a)
	SET @b = ABS(@b)
	
	IF (@a = 0 OR @b = 0)
		BEGIN
			SET @ret = @a + @b
		END
	ELSE
		BEGIN
			While (@a <> @b)
			BEGIN
				IF (@a > @b)
					SET @a = @a - @b
				ELSE
					SET @b = @b - @a
			END
		END
	SET @ret = @a
	RETURN @ret
END
GO

-- câu i:
IF OBJECT_ID('_lcm') IS NOT NULL
	DROP PROCEDURE _lcm
GO
CREATE PROCEDURE _lcm @a INT, @b INT
AS
BEGIN
	DECLARE @tmp INT
	EXEC @tmp = _gcd @a, @b
	RETURN (@a*@b)/ @tmp
END
GO
DECLARE @RES INT
EXEC @RES = _lcm 105, 30
PRINT @RES
GO

IF OBJECT_ID('lcm') IS NOT NULL
	DROP FUNCTION lcm
GO
CREATE FUNCTION lcm (@a INT, @b INT)
RETURNS INT
AS
BEGIN
	DECLARE @tmp INT
	SET @tmp = dbo.gcd(@a, @b)
	RETURN (@a*@b)/ @tmp
END
GO

-- câu j:
IF OBJECT_ID('_printListTeacher') IS NOT NULL
	DROP PROCEDURE _printListTeacher
GO
CREATE PROCEDURE _printListTeacher
AS
BEGIN
	SELECT * FROM dbo.GIAOVIEN
END
GO
EXEC dbo._printListTeacher
GO
-- câu k:
IF OBJECT_ID('_countingNumberOfTopicsOf') IS NOT NULL
	DROP PROCEDURE _countingNumberOfTopicsOf
GO
CREATE PROCEDURE _countingNumberOfTopicsOf @MaGV CHAR(5)
AS
BEGIN
		DECLARE @ret int
		SET @ret = (SELECT COUNT(DISTINCT tg.MADT) FROM dbo.THAMGIADT AS tg WHERE tg.MAGV = @MaGV GROUP BY tg.MAGV)
		PRINT N'> Số lượng đề tài của GV có MAGV = ' + @MaGV + ': ' + CAST(@ret AS VARCHAR(12))
END
GO
EXEC dbo._countingNumberOfTopicsOf '001'
GO
-- câu l:
IF OBJECT_ID('_showTeacherInformation') IS NOT NULL
	DROP PROCEDURE _showTeacherInformation
GO
CREATE PROCEDURE _showTeacherInformation  @MaGV CHAR(5)
AS
BEGIN
	DECLARE @HoTen NVARCHAR(40)
		SET @HoTen = (SELECT gv.HOTEN FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV)
		PRINT N'> Họ tên: ' + @HoTen
		
		DECLARE @Luong FLOAT
		SET @Luong = (SELECT gv.LUONG FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV)
		PRINT N'> Lương: ' + CAST(@Luong AS VARCHAR(12))
		
		DECLARE @NGSINH date
		SET @NGSINH = (SELECT gv.NGSINH FROM dbo.GIAOVIEN AS gv WHERE MAGV = @MaGV)
		PRINT N'> Ngày sinh: ' + CAST(@NGSINH AS VARCHAR(12))
		
		DECLARE @DiaChi nvarchar(50)
		Set @DiaChi = (SELECT gv.DIACHI FROM dbo.GIAOVIEN AS gv WHERE MAGV = @MaGV)
		PRINT N'> Địa chỉ: ' + @DiaChi
		
		DECLARE @SLDT int
		SET @SLDT = (SELECT COUNT(DISTINCT tg.MADT) FROM dbo.THAMGIADT AS tg WHERE MAGV = @MaGV GROUP BY MAGV)
		Print N'> Số lượng đề tài: ' + CAST(@SLDT AS VARCHAR(12))
		
		DECLARE @SLNT int
		SET @SLNT = (SELECT COUNT(*) FROM dbo.NGUOITHAN AS nt WHERE nt.MAGV = @MaGV GROUP BY MAGV)
		PRINT N'> Số lượng người thân: ' + CAST(@SLNT AS VARCHAR(12))
END
GO
EXEC dbo._showTeacherInformation '001'
GO
-- câu m:
IF OBJECT_ID('_isTeacherExist') IS NOT NULL
	DROP PROCEDURE _isTeacherExist
GO
CREATE PROCEDURE _isTeacherExist  @MaGV CHAR(5)
AS
BEGIN
	DECLARE @check BIT
	IF (EXISTS(SELECT * FROM dbo.GIAOVIEN AS GV WHERE GV.MAGV = @MaGV))
		BEGIN
			Print N'> MAGV = ' + @MaGV + N' -> Tồn tại giáo viên.'
			SET @check = 1
		END
	ELSE
		BEGIN
			Print N'> MAGV = ' + @MaGV + N' -> Không tồn tại giáo viên!'
			SET @check = 0
		END
	RETURN @check
END
GO
EXEC dbo._isTeacherExist @MaGV = '001'
GO
-- câu n:
IF OBJECT_ID('_checkRuleOfEachTeacher') IS NOT NULL
	DROP PROCEDURE _checkRuleOfEachTeacher
GO
CREATE PROCEDURE _checkRuleOfEachTeacher  @MaGV CHAR(5), @MaDT CHAR(3)
AS
BEGIN
	DECLARE @GVCNDT varchar(5)
	DECLARE @check BIT 
	SET @GVCNDT = (SELECT dt.GVCNDT FROM dbo.DETAI AS dt WHERE dt.MADT = @MaDT)
	
	IF ((SELECT gv.MABM FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV) = (SELECT gv.MABM FROM GIAOVIEN AS gv WHERE gv.MAGV = @GVCNDT))
		BEGIN
			Print 'True'
			Set @check = 1
		END
	ELSE
		BEGIN
			Print 'False'
			Set @check = 0
		END
	RETURN @check
END
GO
EXEC _checkRuleOfEachTeacher '001', '003'
GO
EXEC _checkRuleOfEachTeacher '003', '006'
GO
-- câu o:
IF OBJECT_ID('_workAssignment') IS NOT NULL
	DROP PROCEDURE _workAssignment
GO
CREATE PROCEDURE _workAssignment @MaGV CHAR(5), @MaDT CHAR(3), @Stt INT, @PhuCap FLOAT, @Ketqua NVARCHAR(40)
AS
BEGIN
	DECLARE @check bit
	SET @check = 1
	
	IF (NOT EXISTS(SELECT * FROM dbo.GIAOVIEN AS GV WHERE GV.MAGV = @MaGV))
		BEGIN
			Print N'> Lỗi -> Mã GV không tồn tại.'
			SET @check = 0
		END
	
	IF (NOT EXISTS(SELECT * FROM dbo.CONGVIEC WHERE MADT = @MaDT AND SOTT = @Stt))
		BEGIN
			Print N'> Lỗi -> Công việc không tồn tại.'
			SET @check = 0
		END
	DECLARE @GVCNDT CHAR(5)
	SET @GVCNDT = (SELECT dt.GVCNDT FROM dbo.DETAI AS dt WHERE dt.MADT = @MaDT)
	
	IF (@check = 1 AND (SELECT GV.MABM FROM dbo.GIAOVIEN AS GV WHERE GV.MAGV = @MaGV) <> (SELECT GV.MABM FROM dbo.GIAOVIEN AS GV WHERE GV.MAGV = @GVCNDT))
		BEGIN
			Print N'> Lỗi -> Đề tài không do bộ môn của GV làm chủ nhiệm.'
			Set @check = 0
		END
	
	-- Thêm phân công
	IF (@check = 1)
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
			    @PhuCap  -- KETQUA - nvarchar(40)
			    )
			Print N'> Phân công thành công.'
		END
END
GO

-- câu p: Thực hiện xoá một giáo viên theo mã.Nếu giáo viên có thông tin liên quan (Có thân nhân, có làm đề tài, ...) thì báo lỗi
IF OBJECT_ID('_removeTeacher') IS NOT NULL
	DROP PROCEDURE _removeTeacher
GO
CREATE PROCEDURE _removeTeacher @MaGV CHAR(5)
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1
	IF (EXISTS(SELECT * FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV))
	BEGIN
		IF (EXISTS(SELECT * FROM dbo.NGUOITHAN AS nt WHERE nt.MAGV = @MaGV))
			BEGIN
				PRINT N'> Giáo viên có tồn tại người thân -> Lỗi.'
				SET @check = 0;
			END
		IF (EXISTS(SELECT * FROM dbo.KHOA AS k WHERE k.TRUONGKHOA = @MaGV))
			BEGIN
				PRINT N'> Giáo viên đang là trưởng khoa -> Lỗi.'
				SET @check = 0;
			END
		IF (EXISTS(SELECT * FROM dbo.DETAI AS dt WHERE dt.GVCNDT = @MaGV))
			BEGIN
				PRINT N'> Giáo viên đang là chủ nhiệm đề tài -> Lỗi.'
				SET @check = 0;
			END
		IF (EXISTS(SELECT * FROM dbo.GV_DT AS gvdt WHERE gvdt.MAGV = @MaGV))
			BEGIN
				PRINT N'> Giáo viên có điện thoại -> Lỗi.'
				SET @check = 0;
			END
		IF @check = 1
			BEGIN
				DELETE FROM dbo.GIAOVIEN WHERE MAGV = @MaGV
				PRINT N'> Đã xoá giáo viên.'
			END
	END
END
GO
EXEC dbo._removeTeacher '001'
go

-- câu q:
IF OBJECT_ID('_showTeacherOfDepartment') IS NOT NULL
	DROP PROCEDURE _showTeacherOfDepartment
GO
CREATE PROCEDURE _showTeacherOfDepartment 
AS
BEGIN
	DECLARE cs_DSGV CURSOR 
		FOR SELECT MAGV FROM dbo.GIAOVIEN
	OPEN cs_DSGV
	
	DECLARE @MaGV varchar(3)
	FETCH NEXT FROM cs_DSGV INTO @MaGV
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @HoTen nvarchar(40)
		SET @HoTen = (SELECT gv.HOTEN FROM dbo.GIAOVIEN AS gv WHERE gv.MAGV = @MaGV)
		PRINT N'Họ tên: ' + @HoTen
		
		DECLARE @Luong FLOAT
		SET @Luong = (SELECT gv.LUONG FROM dbo.GIAOVIEN AS gv WHERE MAGV = @MaGV)
		PRINT N'Lương: ' + CAST(@Luong AS VARCHAR(12))
		
		DECLARE @NGSINH DATE
		SET @NGSINH = (SELECT gv.NGSINH FROM dbo.GIAOVIEN AS gv WHERE MAGV = @MaGV)
		PRINT N'Ngày sinh: ' + CAST(@NGSINH AS VARCHAR(12))
		
		DECLARE @DiaChi nvarchar(100)
		SET @DiaChi = (SELECT gv.DIACHI FROM dbo.GIAOVIEN AS gv WHERE MAGV = @MaGV)
		PRINT N'Địa chỉ: ' + @DiaChi
		
		DECLARE @SLDT INT
		SET @SLDT = (SELECT COUNT(DISTINCT tg.MADT) FROM dbo.THAMGIADT AS tg WHERE tg.MAGV = @MaGV GROUP BY MAGV)
		PRINT N'SLDT: ' + CAST(@SLDT AS VARCHAR(12))
		
		DECLARE @SLNT INT
		SET @SLNT = (SELECT COUNT(*) FROM NGUOITHAN WHERE MAGV = @MaGV GROUP BY MAGV)
		PRINT N'SLNT: ' + CAST(@SLNT AS VARCHAR(12))
		
		DECLARE @SoGVQL INT
		SET @SoGVQL = (SELECT COUNT(*) FROM GIAOVIEN WHERE GVQLCM = @MaGV)
		PRINT N'Số GV mà GV quản lý: ' + CAST(@SoGVQL AS VARCHAR(12))
		
		PRINT '-------------------------------------------------------------'
		FETCH NEXT FROM cs_DSGV INTO @MaGV  
	END
	
	CLOSE cs_DSGV
	DEALLOCATE cs_DSGV

END
GO
EXEC dbo._showTeacherOfDepartment
GO

-- câu r:
IF OBJECT_ID('_checkRuleTeachers') IS NOT NULL
	DROP PROCEDURE _checkRuleTeachers
GO
CREATE PROCEDURE _checkRuleTeachers @MAGV_1 CHAR(5), @MAGV_2 CHAR(5)
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1
	IF ((SELECT MABM FROM GIAOVIEN WHERE MAGV = @MAGV_1) = (SELECT MABM FROM GIAOVIEN WHERE MAGV = @MAGV_2))
	BEGIN
		IF (EXISTS(SELECT * FROM dbo.BOMON AS bm WHERE bm. TRUONGBM = @MAGV_1))
		BEGIN
			IF ((SELECT LUONG FROM dbo.GIAOVIEN WHERE MAGV = @MAGV_1) < (SELECT LUONG FROM dbo.GIAOVIEN WHERE MAGV = @MAGV_2))
			BEGIN
				SET @check = 0
				RETURN @check
			END
			ELSE
			BEGIN
				SET @check = 1
				RETURN @check
			END
		END
		IF (EXISTS(SELECT * FROM dbo.BOMON AS bm WHERE bm. TRUONGBM = @MAGV_2))
		BEGIN
			IF ((SELECT LUONG FROM dbo.GIAOVIEN WHERE MAGV = @MAGV_2) < (SELECT LUONG FROM dbo.GIAOVIEN WHERE MAGV = @MAGV_1))
			BEGIN
				SET @check = 0
				RETURN @check
			END
			ELSE
			BEGIN
				SET @check = 1
				RETURN @check
			END
		END
	END
	ELSE
	BEGIN
		SET @check = 1
		RETURN @check
	END
END
GO
-- câu s:
IF OBJECT_ID('_addTeacher') IS NOT NULL
	DROP PROCEDURE _addTeacher
GO
CREATE PROCEDURE _addTeacher @MAGV CHAR(5), @HOTEN NVARCHAR(40), @LUONG FLOAT, @PHAI NCHAR(3), @NGSINH DATETIME, @DIACHI NVARCHAR(100), @GVQLCM CHAR(5), @MABM NCHAR(5)
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1
	IF (EXISTS(SELECT * FROM dbo.GIAOVIEN AS GV WHERE GV.HOTEN = @HOTEN))
		BEGIN
			PRINT N'> Lỗi -> Trùng tên.'
			SET @check = 0
		END
	IF (YEAR(GETDATE()) - YEAR(@NGSINH) < 18)
		BEGIN
			PRINT N'> Lỗi -> Tuổi < 18.'
			SET @check = 0
		END
	IF (@LUONG < 0)
		BEGIN
			PRINT N'> Lỗi -> Lương < 0'
			SET @check = 0
		END
	IF (@check = 1)
		BEGIN
			INSERT INTO dbo.GIAOVIEN
			(
			    MAGV,
			    HOTEN,
			    LUONG,
			    PHAI,
			    NGSINH,
			    DIACHI,
			    GVQLCM,
			    MABM
			)
			VALUES
			(   @MAGV,        -- MAGV - char(5)
			    @HOTEN,       -- HOTEN - nvarchar(40)
			    @LUONG,       -- LUONG - float
			    @PHAI,       -- PHAI - nchar(3)
			    @NGSINH, -- NGSINH - datetime
			    @DIACHI,       -- DIACHI - nvarchar(100)
			    @GVQLCM,        -- GVQLCM - char(5)
			    @MABM        -- MABM - nchar(5)
			    )
			PRINT N'> Đã thêm một giáo viên.'
		END
END
GO
-- câu t:
IF OBJECT_ID('_determineTeacherID') IS NOT NULL
	DROP PROCEDURE _determineTeacherID
GO
CREATE PROCEDURE _determineTeacherID @MaGV CHAR(5)
AS
BEGIN
    DECLARE @tmpID CHAR(5)
	DECLARE @number INT
	SET @number = 1
	WHILE (1=1)
	BEGIN
	    IF (@number < 10)
		BEGIN
			SET @tmpID = '00' + CAST(@number as varchar(1))
		END
		ELSE IF (@number < 100)
		BEGIN
			SET @tmpID = '0' + CAST(@number as varchar(2))
		END
		ELSE
        BEGIN
			SET @tmpID = CAST(@number as varchar(3))
		END
		IF (NOT EXISTS(SELECT * FROM dbo.GIAOVIEN AS GV WHERE GV.MAGV = @tmpID))
			BEGIN
				Set @MaGV =  @tmpID
				break
			END
		SET @number = @number + 1
	END
END
GO
-- BAI TAP VE NHA
-- CSDL:
-- PHONG: MAPHONG, TINH, LOAIPHONG, DONGIA
-- KHACH: MAKH, HOTEN, DIACHI, DIEN
-- DATPHONG: MA, MAKH, MAPHONG, NGAYDP, NGAYTRA, THANHTIEN

-- TAO CSDL

-- Giả sử có 3 bảng PHONG, KHACH, DATPHONG ứng với PHÒNG, KHÁCH, ĐẶT PHÒNG trong lược đồ CSDL
-- MAPHONG ứng với MãPhòng, data type là char(9)
-- TINH ứng với Tình, data type là nvarchar(4)
-- LOAIPHONG ứng với LoạiPhòng, data type là char(1) - A,B,C,...
-- DONGIA ứng tới Đơn giá, data type là int
-- MAKH ứng với Mã KH, data type là char(9)
-- HOTEN ứng với Họ tên, data type là nvarchar(30)
-- DIACHI ứng với Địa chỉ, data type là nvarchar(50)
-- DIEN ứng với Điện, data type là char(11)
-- MA ứng với Mã, data type là int
-- MAKH
-- MAPHONG
-- NGAYDP ứng với Ngày ĐP, data type là date
-- NGAYTRA ứng với Ngày Trả, data type là date
-- THANHTIEN ứng với Thành tiền, data type là int

USE master
GO 
IF DB_ID('QLDatPhong') IS NOT NULL
	DROP DATABASE QLDatPhong
GO 
CREATE DATABASE QLDatPhong
GO 
USE QLDatPhong
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE PHONG (
	MAPHONG CHAR(9) NOT NULL,
	TINH NVARCHAR(4),
	LOAIPHONG CHAR(1),
	DONGIA INT
	CONSTRAINT PK_PHONG PRIMARY KEY (MAPHONG)
)

CREATE TABLE KHACH(
	MAKH CHAR(9) NOT NULL,
	HOTEN NVARCHAR(30),
	DIACHI NVARCHAR(50),
	DIEN CHAR(11)
	CONSTRAINT PK_KHACH PRIMARY KEY (MAKH)
)

CREATE TABLE DATPHONG(
	MA INT NOT NULL,
	MAKH CHAR(9) NOT NULL,
	MAPHONG CHAR(9) NOT NULL,
	NGAYDP DATE,
	NGAYTRA DATE,
	THANHTIEN INT
	CONSTRAINT PK_DATPHONG PRIMARY KEY(MA)
)

-- TẠO KHOÁ NGOẠI
ALTER TABLE dbo.DATPHONG
ADD CONSTRAINT FK_DATPHONG_KHACH FOREIGN KEY(MAKH) 
REFERENCES dbo.KHACH (MAKH)

ALTER TABLE dbo.DATPHONG
ADD CONSTRAINT FK_DATPHONG_PHONG FOREIGN KEY (MAPHONG)
REFERENCES dbo.PHONG(MAPHONG)
-- INSERT DỮ LIỆU

INSERT INTO dbo.PHONG
(
    MAPHONG,
    TINH,
    LOAIPHONG,
    DONGIA
)
VALUES
(   '',  -- MAPHONG - char(9)
    N'', -- TINH - nvarchar(4)
    '',  -- LOAIPHONG - char(1)
    0    -- DONGIA - int
    )

-- BAI LAM
-- CAU 01:
IF OBJECT_ID('spDatPhong') IS NOT NULL
	DROP PROCEDURE spDatPhong
GO
CREATE PROCEDURE spDatPhong @makh char(9), @maphong char(9), @ngaydat DATE
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1

	-- Kiểm tra mã khách hàng có tồn tại hay không?
	IF (NOT EXISTS(SELECT * FROM dbo.KHACH AS k WHERE k.MaKH = @makh))
		BEGIN
			PRINT N'> Lỗi -> Mã khách hàng không tồn tại.'
			SET @check = 0
		END
	-- Kiểm tra mã phòng có tồn tại hay không?
	IF (NOT EXISTS(SELECT * FROM dbo.PHONG AS PHG WHERE PHG.MaPhong = @maphong))
		BEGIN
			Print N'> Lỗi -> Mã phòng không tồn tại.'
			SET @check = 0
		END
	-- Kiểm tra phòng ứng với mã phòng có đang "Rảnh" hay không?
	IF (NOT((SELECT Tinh FROM dbo.PHONG  AS PHG WHERE PHG.MaPhong = @maphong) = N'Rảnh'))
		BEGIN
			Print N'> Lỗi -> Phòng ứng với mã phòng đang bận.'
			SET @check = 0
		END
	-- Nếu check hợp lệ thì ghi thông tin đặt phòng xuống CSDL
	DECLARE @madatphong INT
	-- Nếu DATPHONG chưa có dữ liệu nào
	IF (NOT EXISTS(SELECT * FROM dbo.DATPHONG))
		BEGIN
			-- Mã trong DATPHONG sẽ bắt đầu từ 1
			SET @madatphong = 1
		END
	ELSE
		BEGIN
			SET @madatphong = 1 + (SELECT MAX(MA) FROM dbo.DATPHONG GROUP BY MA)
		END
	-- Nếu DATPHONG đã có dữ liệu
	IF @check = 1
		BEGIN
			INSERT INTO dbo.DATPHONG
			(
			    MA,
			    MAKH,
			    MAPHONG,
			    NGAYDP,
			    NGAYTRA,
			    THANHTIEN
			)
			VALUES
			(   @madatphong,         -- MA - int
			    @makh,        -- MAKH - char(9)
			    @maphong,        -- MAPHONG - char(9)
			    @ngaydat, -- NGAYDP - date
				NULL, -- NGAYTRA - date
			    NULL         -- THANHTIEN - int
			    )
		PRINT N'> Đặt phòng thành công.'
		UPDATE dbo.PHONG
		SET TINH = N'Bận'
		WHERE MAPHONG = @maphong
		END
END
GO
-- CAU 02:
IF OBJECT_ID('spTraPhong') IS NOT NULL
	DROP PROCEDURE spTraPhong
GO
CREATE PROCEDURE spTraPhong @madp char(9), @makh char(9)
AS
BEGIN
	DECLARE @check BIT
    SET @check = 1
	-- Kiểm tra tính hợp lệ của mã đặt phòng và mã khách hàng
	IF (NOT EXISTS(SELECT * FROM DATPHONG WHERE Ma = @madp AND MaKH = @makh))
		BEGIN
			Print N'> Lỗi -> Khách hàng chưa thực hiện việc đặt phòng.'
			SET @check = 0
		END
	
	IF (@check = 1)
		BEGIN
			-- Ngày trả phòng chính là ngày hiện hành
			UPDATE DATPHONG
			SET NgayTra = GetDate()
			WHERE Ma = @madp AND MaKH = @makh
			
			-- Tiền thanh toán = Số ngày x đơn giá phòng
			DECLARE @songay INT
			DECLARE @ngaybatdau DATE
			DECLARE @ngayketthuc DATE
			SET @ngaybatdau = (SELECT NGAYDP FROM dbo.DATPHONG WHERE MA = @madp)
			SET @ngayketthuc= GETDATE()
			SET @songay = DATEDIFF(DAY, @ngaybatdau, @ngayketthuc)
			
			DECLARE @maphong char(9)
			SET @maphong = (SELECT MaPhong FROM DATPHONG WHERE Ma = @madp AND MaKH = @makh)
			
			DECLARE @dongia INT
			SET @dongia = (SELECT DonGia FROM PHONG WHERE MaPhong = @maphong)
			
			UPDATE DATPHONG
			SET ThanhTien = @songay * @dongia
			WHERE Ma = @madp AND MaKH = @makh
			
			-- Trả phòng xong, cập nhật lại trạng thái PHONG
			UPDATE PHONG
			SET Tinh = N'Rảnh'
			WHERE MaPhong = @maphong
			
			Print N'> Trả phòng thành công.'
		END
END
GO

