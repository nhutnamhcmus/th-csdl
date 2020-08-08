/****** Database QuanLyPhanCongDeAn ******/

-- KHỞI TẠO DATABASE: QUANLYPHANCONGDEAN
USE master
GO 
IF DB_ID('QUANLYPHANCONGDEAN') IS NOT NULL
	DROP DATABASE QUANLYPHANCONGDEAN
GO 
CREATE DATABASE QUANLYPHANCONGDEAN
GO 
USE QUANLYPHANCONGDEAN
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SELECT FORMAT (getdate(), 'dd/MM/yyyy') as date
GO
-----------------------------------------------------------
-- Bước 1 : TẠO BẢNG VÀ KHÓA CHÍNH
-----------------------------------------------------------
-- KHỞI TẠO BẢNG PHONGBAN
CREATE TABLE PHONGBAN (
	TENPHG 		NVARCHAR(30),
	MAPHG 		INT NOT NULL,
	TRPHG 		CHAR(9),
	NG_NHANCHUC		DATE,
	CONSTRAINT PK_PHONGBAN PRIMARY KEY (MAPHG)
)
-- KHỞI TẠO BẢNG NHANVIEN
CREATE TABLE NHANVIEN (
	HONV 		NVARCHAR(30),
	TENLOT 		NVARCHAR(30),
	TENNV 		NVARCHAR(30),
	MANV 		CHAR(9) NOT NULL,
	NGSINH 		DATE,
	DCHI 		NVARCHAR(50),
	PHAI 		NCHAR(6),
	LUONG 		FLOAT,
	MA_NQL 		CHAR(9),
	PHG 		INT,
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV)
)
-- KHỞI TẠO BẢNG DIADIEM_PHG
CREATE TABLE DIADIEM_PHG(
	MAPHG 	INT NOT NULL,
	DIADIEM	NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_DIADIEM_PHG PRIMARY KEY (MAPHG,DIADIEM)
)
-- KHỞI TẠO BẢNG CONGVIEC
CREATE TABLE CONGVIEC (
	MADA	INT NOT NULL,
	STT		INT NOT NULL,
	TEN_CONG_VIEC	NVARCHAR(50),
	CONSTRAINT PK_CONGVIEC PRIMARY KEY (MADA, STT)
)
-- KHỞI TẠO BẢNG PHANCONG
CREATE TABLE PHANCONG (
	MA_NVIEN	char(9) NOT NULL,
	MADA 		INT NOT NULL,
	STT			INT NOT NULL, 
	THOIGIAN	DECIMAL(5,1),
	CONSTRAINT PK_PHANCONG PRIMARY KEY (MA_NVIEN, MADA, STT)
)
-- KHỞI TẠO BẢNG THANNHAN
CREATE TABLE THANNHAN (
	MA_NVIEN	CHAR(9) NOT NULL,
	TENTN 		NVARCHAR(30) NOT NULL,
	PHAI 		NCHAR(6),
	NGSINH 		DATE,
	QUANHE 		NVARCHAR(16),
	CONSTRAINT PK_THANNHAN PRIMARY KEY (MA_NVIEN, TENTN)
)
-- KHỞI TẠO BẢNG DEAN
CREATE TABLE DEAN(
	TENDA		NVARCHAR(30),
	MADA		INT NOT NULL,
	DDIEM_DA	NVARCHAR(30),
	PHONG		INT,
	CONSTRAINT PK_DEAN PRIMARY KEY (MADA)
)

-----------------------------------------------------------
-- Bước 2 : TẠO RÀNG BUỘC TOÀN VẸN VÀ KHÓA NGOẠI
-----------------------------------------------------------
-- Phái chỉ có Nam, Nữ.
ALTER TABLE dbo.NHANVIEN
ADD CONSTRAINT C_PHAI_NHANVIEN
CHECK (PHAI IN ('Nam', N'Nữ'))

ALTER TABLE dbo.THANNHAN
ADD CONSTRAINT C_PHAI_THANNHAN
CHECK (PHAI IN ('Nam', N'Nữ'))

-- TẠO RÀNG BUỘC KHÓA NGOẠI
----
ALTER TABLE dbo.NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_NHANVIEN
FOREIGN KEY (MA_NQL)
REFERENCES dbo.NHANVIEN(MANV)

ALTER TABLE dbo.NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_PHONGBAN
FOREIGN KEY (PHG)
REFERENCES dbo.PHONGBAN(MAPHG)
----
ALTER TABLE dbo.PHONGBAN
ADD CONSTRAINT FK_PHONGBAN_NHANVIEN
FOREIGN KEY (TRPHG)
REFERENCES dbo.NHANVIEN(MANV)
----
ALTER TABLE dbo.DIADIEM_PHG
ADD CONSTRAINT FK_DIADIEM_PHG_PHONGBAN
FOREIGN KEY (MAPHG)
REFERENCES dbo.PHONGBAN(MAPHG)
----
ALTER TABLE dbo.PHANCONG
ADD CONSTRAINT FK_PHANCONG_NHANVIEN
FOREIGN KEY (MA_NVIEN)
REFERENCES dbo.NHANVIEN(MANV)

ALTER TABLE dbo.PHANCONG
ADD CONSTRAINT FK_PHANCONG_CONGVIEC
FOREIGN KEY (MADA, STT)
REFERENCES dbo.CONGVIEC(MADA, STT)
----
ALTER TABLE dbo.THANNHAN
ADD CONSTRAINT FK_THANNHAN_NHANVIEN
FOREIGN KEY (MA_NVIEN)
REFERENCES dbo.NHANVIEN(MANV)
----
ALTER TABLE dbo.DEAN
ADD CONSTRAINT FK_DEAN_PHONGBAN
FOREIGN KEY (PHONG)
REFERENCES dbo.PHONGBAN(MAPHG)

ALTER TABLE dbo.CONGVIEC
ADD CONSTRAINT FK_CONGVIEN_DEAN
FOREIGN KEY (MADA)
REFERENCES dbo.DEAN(MADA)
-----------------------------------------------------------
-- Bước 3 : INSERT DỮ LIỆU 
-----------------------------------------------------------
-- INSERT PHONGBAN (TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
INSERT INTO dbo.PHONGBAN
(
    TENPHG,
    MAPHG,
    TRPHG,
    NG_NHANCHUC
)
VALUES
(   N'Nghiên cứu',      -- TENPHG - nvarchar(15)
    5,        -- MAPHG - int
    NULL,      -- TRPHG - nvarchar(9)
    CAST(N'05/22/1988' AS DATE) -- NG_NHANCHUC - date
    )

INSERT INTO dbo.PHONGBAN
(
    TENPHG,
    MAPHG,
    TRPHG,
    NG_NHANCHUC
)
VALUES
(   N'Điều hành',      -- TENPHG - nvarchar(15)
    4,        -- MAPHG - int
    NULL,      -- TRPHG - nvarchar(9)
    CAST(N'01/01/1995' AS DATE) -- NG_NHANCHUC - date
    )

INSERT INTO dbo.PHONGBAN
(
    TENPHG,
    MAPHG,
    TRPHG,
    NG_NHANCHUC
)
VALUES
(   N'Quản lý',      -- TENPHG - nvarchar(15)
    1,        -- MAPHG - int
    NULL,      -- TRPHG - nvarchar(9)
    CAST(N'06/19/1981' AS DATE) -- NG_NHANCHUC - date
    )
-- INSERT NHANVIEN (HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Đinh',       -- HONV - nvarchar(15)
    N'Bá',       -- TENLOT - nvarchar(15)
    N'Tiến',       -- TENNV - nvarchar(15)
    N'009',       -- MANV - nvarchar(9)
    '02/11/1960', -- NGSINH - date
    N'119 Cống Quỳnh, Tp HCM',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    30000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    5          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Nguyễn',       -- HONV - nvarchar(15)
    N'Thanh',       -- TENLOT - nvarchar(15)
    N'Tùng',       -- TENNV - nvarchar(15)
    N'005',       -- MANV - nvarchar(9)
    CAST(N'08/20/1962' AS DATE), -- NGSINH - date
    N'332 Nguyễn Thái Học, Tp HCM',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    40000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    5          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Bùi',       -- HONV - nvarchar(15)
    N'Ngọc',       -- TENLOT - nvarchar(15)
    N'Hằng',       -- TENNV - nvarchar(15)
    N'007',       -- MANV - nvarchar(9)
    CAST(N'3/11/1954' AS DATE), -- NGSINH - date
    N'332 Nguyễn Thái Học, Tp HCM',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    25000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    4          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Lê',       -- HONV - nvarchar(15)
    N'Quỳnh',       -- TENLOT - nvarchar(15)
    N'Như',       -- TENNV - nvarchar(15)
    N'001',       -- MANV - nvarchar(9)
    CAST(N'02/01/1967' AS DATE), -- NGSINH - date
    N'291 Hồ Văn Huê,  Tp HCM',       -- DCHI - nvarchar(30)
    N'Nữ',       -- PHAI - nvarchar(3)
    43000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    4          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Nguyễn',       -- HONV - nvarchar(15)
    N'Mạng',       -- TENLOT - nvarchar(15)
    N'Hùng',       -- TENNV - nvarchar(15)
    N'004',       -- MANV - nvarchar(9)
    CAST(N'03/04/1967' AS DATE), -- NGSINH - date
    N'95 Bà Rịa, Vũng Tàu',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    38000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    5          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Trần',       -- HONV - nvarchar(15)
    N'Thanh',       -- TENLOT - nvarchar(15)
    N'Tâm',       -- TENNV - nvarchar(15)
    N'003',       -- MANV - nvarchar(9)
    CAST(N'05/04/1957' AS DATE), -- NGSINH - date
    N'34 Mai Thị Lựu, Tp HCM',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    25000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    5          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Trần',       -- HONV - nvarchar(15)
    N'Hồng',       -- TENLOT - nvarchar(15)
    N'Quang',       -- TENNV - nvarchar(15)
    N'008',       -- MANV - nvarchar(9)
	CAST(N'09/01/1967' AS DATE), -- NGSINH - date
    N'80 Lê Hồng Phong, Tp HCM',       -- DCHI - nvarchar(30)
    N'Nam',       -- PHAI - nvarchar(3)
    25000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    4          -- PHG - int
    )

INSERT INTO dbo.NHANVIEN
(
    HONV,
    TENLOT,
    TENNV,
    MANV,
    NGSINH,
    DCHI,
    PHAI,
    LUONG,
    MA_NQL,
    PHG
)
VALUES
(   N'Phạm',       -- HONV - nvarchar(15)
    N'Văn',       -- TENLOT - nvarchar(15)
    N'Vinh',       -- TENNV - nvarchar(15)
    N'006',       -- MANV - nvarchar(9)
    CAST(N'01/01/1965' AS DATE), -- NGSINH - date
    N'45 Trưng Vương, Hà Nội',       -- DCHI - nvarchar(30)
    N'Nữ',       -- PHAI - nvarchar(3)
    55000,       -- LUONG - real
    NULL,       -- MA_NQL - nvarchar(9)
    1          -- PHG - int
    )

----------------- UPDATE PHONGBAN--------------------
UPDATE dbo.PHONGBAN
SET TRPHG = N'005'
WHERE MAPHG = 5

UPDATE dbo.PHONGBAN
SET TRPHG = N'008'
WHERE MAPHG = 4

UPDATE dbo.PHONGBAN
SET TRPHG = '006'
WHERE MAPHG = 1
----------------- UPDATE NHANVIEN--------------------
UPDATE  dbo.NHANVIEN		
SET MA_NQL='005'	
WHERE MANV=N'009'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='006' 
WHERE MANV=N'005'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='001' 
WHERE MANV='007'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='006' 
WHERE MANV='001'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='005' 
WHERE MANV='004'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='005' 
WHERE MANV='003'

UPDATE  dbo.NHANVIEN 
SET MA_NQL='001' 
WHERE MANV='008'
-----------------INSERT DIADIEM_PHG --------------------
INSERT INTO dbo.DIADIEM_PHG
(
    MAPHG,
    DIADIEM
)
VALUES
(   1,  -- MAPHG - int
    N'TP HCM' -- DIADIEM - nvarchar(15)
    )

INSERT INTO dbo.DIADIEM_PHG
(
    MAPHG,
    DIADIEM
)
VALUES
(   4,  -- MAPHG - int
    N'Hà Nội' -- DIADIEM - nvarchar(15)
    )

INSERT INTO dbo.DIADIEM_PHG
(
    MAPHG,
    DIADIEM
)
VALUES
(   5,  -- MAPHG - int
    N'TAU' -- DIADIEM - nvarchar(15)
    )

INSERT INTO dbo.DIADIEM_PHG
(
    MAPHG,
    DIADIEM
)
VALUES
(   5,  -- MAPHG - int
    N'NHA TRANG' -- DIADIEM - nvarchar(15)
    )

INSERT INTO dbo.DIADIEM_PHG
(
    MAPHG,
    DIADIEM
)
VALUES
(   5,  -- MAPHG - int
    N'TP HCM' -- DIADIEM - nvarchar(15)
    )
----------------- INSERT THANNHAN--------------------
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'005',       -- MA_NVIEN - nvarchar(9)
    N'Trinh',       -- TENTN - nvarchar(15)
    N'Nữ',       -- PHAI - nvarchar(3)
    CAST(N'04/05/1976' AS DATE), -- NGSINH - date
    N'Con gái'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'005',       -- MA_NVIEN - nvarchar(9)
    N'Khang',       -- TENTN - nvarchar(15)
    N'Nam',       -- PHAI - nvarchar(3)
    CAST(N'10/25/1973' AS DATE), -- NGSINH - date
    N'Con trai'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'005',       -- MA_NVIEN - nvarchar(9)
    N'Phương',       -- TENTN - nvarchar(15)
    N'Nữ',       -- PHAI - nvarchar(3)
    CAST(N'05/03/1948' AS DATE), -- NGSINH - date
    N'Vợ chồng'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'001',       -- MA_NVIEN - nvarchar(9)
    N'Minh',       -- TENTN - nvarchar(15)
    N'Nam',       -- PHAI - nvarchar(3)
    CAST(N'02/29/1932' AS DATE), -- NGSINH - date
    N'Vợ chồng'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'009',       -- MA_NVIEN - nvarchar(9)
    N'Tiên',       -- TENTN - nvarchar(15)
    N'Nam',       -- PHAI - nvarchar(3)
    CAST(N'01/01/1978' AS DATE), -- NGSINH - date
    N'Con trai'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'009',       -- MA_NVIEN - nvarchar(9)
    N'Châu',       -- TENTN - nvarchar(15)
    N'Nữ',       -- PHAI - nvarchar(3)
    CAST(N'12/30/1978' AS DATE), -- NGSINH - date
    N'Con gái'        -- QUANHE - nvarchar(15)
    )
INSERT INTO dbo.THANNHAN
(
    MA_NVIEN,
    TENTN,
    PHAI,
    NGSINH,
    QUANHE
)
VALUES
(   N'009',       -- MA_NVIEN - nvarchar(9)
    N'Phương',       -- TENTN - nvarchar(15)
    N'Nữ',       -- PHAI - nvarchar(3)
    CAST(N'05/05/1978' AS DATE), -- NGSINH - date
    N'Vợ chồng'        -- QUANHE - nvarchar(15)
    )
----------------- INSERT DEAN--------------------
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Sản phẩm X', -- TENDA - nvarchar(15)
    1,   -- MADA - int
    N'Vũng Tàu', -- DDIEM_DA - nvarchar(15)
    5    -- PHONG - int
    )
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Sản phẩm Y', -- TENDA - nvarchar(15)
    2,   -- MADA - int
    N'Nha Trang', -- DDIEM_DA - nvarchar(15)
    5    -- PHONG - int
    )
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Sản phẩm Z', -- TENDA - nvarchar(15)
    3,   -- MADA - int
    N'TP HCM', -- DDIEM_DA - nvarchar(15)
    5    -- PHONG - int
    )
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Tin học hóa', -- TENDA - nvarchar(15)
    10,   -- MADA - int
    N'Hà Nội', -- DDIEM_DA - nvarchar(15)
    4    -- PHONG - int
    )
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Cáp quang', -- TENDA - nvarchar(15)
    20,   -- MADA - int
    N'TP HCM', -- DDIEM_DA - nvarchar(15)
    1    -- PHONG - int
    )
INSERT INTO dbo.DEAN
(
    TENDA,
    MADA,
    DDIEM_DA,
    PHONG
)
VALUES
(   N'Đào tạo', -- TENDA - nvarchar(15)
    30,   -- MADA - int
    N'Hà Nội', -- DDIEM_DA - nvarchar(15)
    4    -- PHONG - int
    )
----------------- INSERT CONGVIEC--------------------
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   1,  -- MADA - int
    1,  -- STT - int
    N'Thiết kế sản phẩm X' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   1,  -- MADA - int
    2,  -- STT - int
    N'Thử nghiệm sản phẩm X' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   2,  -- MADA - int
    1,  -- STT - int
    N'Sản xuất sản phẩm Y' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   2,  -- MADA - int
    2,  -- STT - int
    N'Quảng cáo sản phẩm Y' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   3,  -- MADA - int
    1,  -- STT - int
    N'Khuyến mãi sản phẩm Z' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   10,  -- MADA - int
    1,  -- STT - int
    N'Tin học hóa phòng nhân sự' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   10,  -- MADA - int
    2,  -- STT - int
    N'Tin học hóa phòng kinh doanh' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   20,  -- MADA - int
    1,  -- STT - int
    N'Lắp đặt cáp quang' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   30,  -- MADA - int
    1,  -- STT - int
    N'Đào tạo nhân viên Marketing' -- TEN_CONG_VIEC - nvarchar(50)
    )
INSERT INTO dbo.CONGVIEC
(
    MADA,
    STT,
    TEN_CONG_VIEC
)
VALUES
(   30,  -- MADA - int
    2,  -- STT - int
    N'Đào tạo chuyên viên thiết kế' -- TEN_CONG_VIEC - nvarchar(50)
    )
----------------- INSERT PHANCONG--------------------
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'009', -- MA_NVIEN - nvarchar(9)
    1,   -- MADA - int
    1,   -- STT - int
    32  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'009', -- MA_NVIEN - nvarchar(9)
    2,   -- MADA - int
    2,   -- STT - int
    8  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'004', -- MA_NVIEN - nvarchar(9)
    3,   -- MADA - int
    1,   -- STT - int
    40  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'003', -- MA_NVIEN - nvarchar(9)
    1,   -- MADA - int
    2,   -- STT - int
    20.0  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'003', -- MA_NVIEN - nvarchar(9)
    2,   -- MADA - int
    1,   -- STT - int
    20.0  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'008', -- MA_NVIEN - nvarchar(9)
    10,   -- MADA - int
    1,   -- STT - int
    35  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'008', -- MA_NVIEN - nvarchar(9)
    30,   -- MADA - int
    2,   -- STT - int
    5  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'001', -- MA_NVIEN - nvarchar(9)
    30,   -- MADA - int
    1,   -- STT - int
    20  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'001', -- MA_NVIEN - nvarchar(9)
    20,   -- MADA - int
    1,   -- STT - int
    15  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'006', -- MA_NVIEN - nvarchar(9)
    20,   -- MADA - int
    1,   -- STT - int
    30  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'005', -- MA_NVIEN - nvarchar(9)
    3,   -- MADA - int
    1,   -- STT - int
    10  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'005', -- MA_NVIEN - nvarchar(9)
    10,   -- MADA - int
    2,   -- STT - int
    10  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'005', -- MA_NVIEN - nvarchar(9)
    20,   -- MADA - int
    1,   -- STT - int
    10  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'007', -- MA_NVIEN - nvarchar(9)
    30,   -- MADA - int
    2,   -- STT - int
    30  -- THOIGIAN - real
    )
INSERT INTO dbo.PHANCONG
(
    MA_NVIEN,
    MADA,
    STT,
    THOIGIAN
)
VALUES
(   N'007', -- MA_NVIEN - nvarchar(9)
    10,   -- MADA - int
    2,   -- STT - int
    10  -- THOIGIAN - real
    )

-----------------------------------------
-- VIẾT CÁC CÂU TRUY VẤN
-----------------------------------------
-- 1. Cho ds nhân viên gồm họ tên, phái.
SELECT nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv
-- 2. Cho ds nhân viên thuộc phòng số 5.
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv
WHERE nv.PHG = 5
-- 3. Cho ds nhân viên gồm mã nv, họ tên, phái của các nv thuộc phòng số 5
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN], nv.PHAI
FROM dbo.NHANVIEN AS nv
WHERE nv.PHG = 5
-- 4. Danh sach họ tên phái của các nv thuộc phòng ‘nghiên cứu’.
SELECT nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN], nv.PHAI
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
WHERE pb.TENPHG = N'Nghiên cứu'
-- 5. Cho ds các mã nhân viên có tham gia đề án số 4 hoặc 5
SELECT DISTINCT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
WHERE (pc.MADA = 4 OR pc.MADA = 5)
-- 6. Cho ds các mã nhân viên vừa có tham gia đề án số 4 vừa có tham gia đề án số 5.
SELECT DISTINCT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
WHERE (pc.MADA = 4 AND pc.MADA = 5)
-- 7. Cho ds các mã nhân viên có tham gia đề án số 4 mà không có tham gia đề án số 5
SELECT DISTINCT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
WHERE (pc.MADA = 4 AND pc.MADA != 5)
-- 8. Cho biết danh sách thể hiện mọi nhân viên đều tham gia tất cả các đề án.
SELECT DISTINCT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE pc.MA_NVIEN = nv.MANV AND pc.MADA = da.MADA
-- 9. Cho ds các nhân viên và thông tin phòng ban mà nhân viên đó trực thuộc (mã nv, họ tên, mã phòng, tên phòng)
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN], pb.MAPHG, pb.TENPHG
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
-- 10. Cho ds các phòng ban và địa điểm phòng ban (mã pb, tên pb, địa điểm)
SELECT pb.MAPHG, pb.TENPHG, dd_pb.DIADIEM
FROM dbo.PHONGBAN AS pb JOIN dbo.DIADIEM_PHG AS dd_pb ON dd_pb.MAPHG = pb.MAPHG
-- 11. Cho danh sách các nhân viên thuộc phòng ‘Nghiên cứu’
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
WHERE pb.TENPHG = N'Nghiên cứu'
-- 12. Đối với từng nv, cho biết họ tên ngày sinh và tên của nv phụ trách trực tiếp nhân viên đó.
SELECT nv01.HONV + SPACE(1) + nv01.TENLOT + SPACE(1) + nv01.TENNV AS [Ho Ten Nhan Vien], nv02.HONV + SPACE(1) + nv02.TENLOT + SPACE(1) + nv02.TENNV AS [Ho Ten NVQL]
FROM dbo.NHANVIEN AS nv01 JOIN dbo.NHANVIEN AS nv02 ON nv02.MA_NQL = nv01.MANV
-- 13. Ds nv thuộc phòng 5 có tham gia đề án tên là ‘Sản phẩm X’.
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm X'
-- 14. Tương tự 5, thuộc phòng ‘nghiên cứu’ có tham gia đề án tên là ‘Sản phẩm X’.
SELECT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm X' AND pb.TENPHG = N'Nghiên cứu'
-- 15. GÁN: Cho biết có tất cả bao nhiêu nhân viên
SELECT COUNT(*) AS SLNV
FROM dbo.NHANVIEN AS nv
-- 16. Cho biết mỗi phòng ban có bao nhiêu nhân viên (MAPB, TENPB, SLNV)
SELECT pb.MAPHG AS [MAPB], pb.TENPHG AS [TENPB], COUNT(*) AS SLNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
GROUP BY pb.MAPHG, pb.TENPHG
-- 17. Cho biết tổng lương, số lượng nv, lương trung bình, lương bé nhất trong toàn công ty.
SELECT SUM(dbo.NHANVIEN.LUONG) AS TONGLUONG, 
COUNT(*) AS SLNV, 
AVG(dbo.NHANVIEN.LUONG) AS LUONGTRUNGBINH,
MIN(dbo.NHANVIEN.LUONG) AS LUONGBENHAT
FROM dbo.NHANVIEN
-- 18. Ds nhân viên có tham gia đề án
SELECT DISTINCT nv.MANV,nv.HONV, nv.TENLOT
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV

-- 19. Ds nhân viên không có tham gia đề án nào.
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
EXCEPT
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv

-- 20. Mỗi nv tham gia bao nhiêu đề án với tổng thời gian là bao nhiêu
SELECT nv.HONV, nv.TENLOT, nv.TENNV, COUNT(*) AS SLDA, SUM(pc.THOIGIAN) AS TONGTHOIGIAN
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV 
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
GROUP BY  nv.HONV, nv.TENLOT, nv.TENNV

-- 21. Ds nv có tham gia đề án tên là ‘Sản phẩm X ’ hoặc ‘Sản phẩm Y’.
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm X'
UNION
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm Y'
-- 22. Ds nv vừa có tham gia đề án tên ‘Sản phẩm X’ vừa có tham gia đề án ‘Sản phẩm Y’.
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm X'
INTERSECT
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm Y'
-- 23. Ds nv có tham gia đề án tên ‘Sản phẩm X’ mà không có tham gia đề án tên là ‘Sản phẩm Y’.
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm X'
EXCEPT
SELECT nv.MANV, nv.HONV,nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE da.TENDA = N'Sản phẩm Y'
-- 24. Ds nv chỉ có tham gia đề án tên ‘Sản phẩm X’.
SELECT DISTINCT nv.MANV, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [HOTEN]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON nv.MANV = pc.MA_NVIEN
JOIN dbo.DEAN AS da ON da.MADA = pc.MADA
WHERE nv.MANV IN (SELECT nv.MANV
					FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON nv.MANV = pc.MA_NVIEN JOIN dbo.DEAN AS da ON da.MADA = pc.MADA 
					GROUP BY nv.MANV
					HAVING COUNT(*) = 1) AND da.TENDA = N'Sản phẩm X'

-- 25. Ds các đề án chỉ do các nv thuộc phòng “Nghiên cứu” thực hiện.
SELECT pb.MAPHG, pb.TENPHG, da.TENDA
FROM dbo.PHONGBAN AS pb JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE pb.TENPHG = N'Nghiên cứu'
-- 26. Ds các nv có tham gia tất cả các đề án.
SELECT DISTINCT nv.MANV
FROM dbo.NHANVIEN AS nv
WHERE NOT EXISTS (SELECT *
					FROM dbo.DEAN AS da
					WHERE NOT EXISTS ( SELECT *
											FROM dbo.PHANCONG AS pc
											WHERE da.MADA = pc.MADA
											AND nv.MANV = pc.MA_NVIEN
										)
					)
-- 27. Ds nv thuộc phòng ‘Nghiên cứu’ có tham gia tất cả các đề án do phòng số 5 chủ trì
SELECT DISTINCT nv.MANV, nv.HONV, nv.TENLOT, nv.TENNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE pb.TENPHG = N'Nghiên cứu'
-- 28. Cho biết lương trung bình của các phòng ban (mã, tên, lương TB).
SELECT pb.MAPHG, pb.TENPHG, AVG(nv.LUONG) AS [Lương trung bình]
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
GROUP BY pb.MAPHG, pb.TENPHG
-- 29. Cho biết các phòng ban có lương trung bình > 2500.
SELECT pb.MAPHG
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
GROUP BY pb.MAPHG
HAVING AVG(nv.LUONG) > 2500
-- 30. Cho biết các phòng ban có chủ trì đề án có số nhân viên > 3 và có lương trung bình lớn hơn 2500.
SELECT pb.MAPHG, pb.TENPHG
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
GROUP BY pb.MAPHG, pb.TENPHG
HAVING COUNT(nv.MANV) > 3 
AND AVG(nv.LUONG) > 2500
AND 1 <= (SELECT COUNT(MADA) FROM dbo.DEAN JOIN dbo.PHONGBAN ON PHONGBAN.MAPHG =  pb.MAPHG)
-- 31. Cho biết nhân viên nào có lương cao nhất trong từng phòng ban.
SELECT pb.MAPHG, pb.TENPHG, nv.HONV + SPACE(1) + nv.TENLOT + SPACE(1) + nv.TENNV AS [Nhân viên], nv.LUONG
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
WHERE nv.LUONG = (SELECT MAX(nv1.LUONG)
						FROM dbo.NHANVIEN AS nv1
						WHERE nv1.PHG = pb.MAPHG
						)
-- 32. Cho biết phòng ban nào có lương trung bình cao nhất.
SELECT pb.MAPHG, AVG(nv.LUONG) AS TRUNGBINHLUONG
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
GROUP BY pb.MAPHG
HAVING AVG(nv.LUONG) >= ALL (SELECT AVG(nv1.LUONG)
							FROM dbo.NHANVIEN AS nv1 JOIN dbo.PHONGBAN AS pb1 ON pb1.MAPHG = nv1.PHG
							GROUP BY pb1.MAPHG
							)

-- 33. Cho biết phòng ban nào có ít nhân viên nhất.
SELECT pb.MAPHG, pb.TENPHG, COUNT(*) AS SLNV
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
GROUP BY pb.MAPHG, pb.TENPHG
HAVING COUNT(*) <= ALL ( SELECT COUNT(*)
						FROM dbo.NHANVIEN AS nv1 JOIN dbo.PHONGBAN AS pb1 ON pb1.MAPHG = nv1.PHG
						GROUP BY pb1.MAPHG, pb1.TENPHG
)

-- 34. Cho biết phòng ban nào có đông nhân viên nữ nhất.
SELECT pb.MAPHG,pb.TENPHG, COUNT(*) SLNV_Nu
FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
WHERE nv.PHAI = N'Nữ'
GROUP BY pb.MAPHG,pb.TENPHG
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM dbo.NHANVIEN AS nv1 JOIN dbo.PHONGBAN AS pb1 ON pb1.MAPHG = nv1.PHG
						WHERE nv1.PHAI = N'Nữ'
						GROUP BY nv1.MANV
						)
-- 35. Danh sách mã, tên của các phòng ban có chủ trì đề án tên là “SPX” lẫn “SPY”.
SELECT pb.MAPHG, pb.TENPHG
FROM dbo.PHONGBAN AS pb JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm X'
INTERSECT
SELECT pb.MAPHG, pb.TENPHG
FROM dbo.PHONGBAN AS pb JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm Y'
-- 36. Danh sách mã, tên của các phòng ban có chủ trì đề án tên là “SPX” mà không có chủ trì đề án tên là “SPY”.
SELECT pb.MAPHG, pb.TENPHG
FROM dbo.PHONGBAN AS pb JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm X'
EXCEPT
SELECT pb.MAPHG, pb.TENPHG
FROM dbo.PHONGBAN AS pb JOIN dbo.DEAN AS da ON da.PHONG = pb.MAPHG
WHERE da.TENDA = N'Sản phẩm Y'
-- 37. Phân công cho các nhân viên thuộc phòng số 5 tham gia đề án số 10 mỗi người tham gia 10 giờ
DROP TABLE IF EXISTS #tmp
SELECT *
INTO #tmp
FROM tmp.NHANVIEN
WHERE PHG = '5'

SELECT *
FROM #tmp

DECLARE @slnv INT
DECLARE @manv CHAR(10)
DECLARE @mada CHAR(10)
DECLARE @tg INT
SET @slnv = (SELECT count(*) FROM #tmp)
SET @mada = '10'
SET @tg = 10
PRINT N'Số lượng nv phòng 5: ' + CONVERT(VARCHAR, @slnv)
WHILE (@slnv > 0)
BEGIN
	SELECT TOP 1 @manv = MANV FROM #tmp
	print @manv
	INSERT INTO PHANCONG VALUES(@manv, @mada, 1, @tg)
    SET @slnv  = @slnv  - 1
	DELETE #tmp WHERE MANV = @manv
END

SELECT DISTINCT nv.MANV, nv.PHG, pc.*
FROM dbo.NHANVIEN AS nv join dbo.PHANCONG AS pc on nv.MANV = pc.MA_NVIEN
WHERE nv.PHG = '5' and pc.MADA = '10'

-- 38. Xóa tất cả những phân công liên quan đến nhân viên mã là 10.
DELETE FROM dbo.PHANCONG
WHERE MA_NVIEN = '010'

SELECT *
FROM dbo.PHANCONG

-- 39. Xóa tất cả những phân công liên quan đến nhân viên mã là 10 và đề án mã là 20.
DELETE FROM dbo.PHANCONG
where MA_NVIEN = '010' and MADA = '20'

SELECT *
FROM dbo.PHANCONG

-- 40. Tăng 10% giờ tham gia đề án của nhân viên đã tham gia đề án số 10.

UPDATE dbo.PHANCONG
set THOIGIAN = THOIGIAN * 1.1
where MADA = '10'

SELECT *
FROM dbo.PHANCONG

-- 41. Giảm 15% giờ tham gia đề án của các nhân viên thuộc phòng “Nghiên cứu ”đã tham gia đề án số 10

UPDATE dbo.PHANCONG
SET THOIGIAN = THOIGIAN * 0.85
WHERE MADA = '10' and MA_NVIEN in (SELECT MANV
								FROM dbo.NHANVIEN AS nv JOIN dbo.PHONGBAN AS pb ON pb.MAPHG = nv.PHG
								WHERE pb.TENPHG = N'Nghiên cứu')
SELECT *
FROM dbo.PHANCONG



-- 42. Cho biết mỗi phòng ban định vị ở bao nhiêu nơi
SELECT pb.TENPHG, pb.MAPHG, COUNT(*) AS SONOI
FROM dbo.PHONGBAN AS pb JOIN dbo.DIADIEM_PHG AS dd ON dd.MAPHG = pb.MAPHG
GROUP BY pb.TENPHG, pb.MAPHG
-- 43. Cho biết những phòng ban định vị ở nhiều nơi
SELECT pb.TENPHG, pb.MAPHG, COUNT(*) AS SONOI
FROM dbo.PHONGBAN AS pb JOIN dbo.DIADIEM_PHG AS dd ON dd.MAPHG = pb.MAPHG
GROUP BY pb.TENPHG, pb.MAPHG
HAVING COUNT(*) > 1
-- 44. Danh sách các nhân viên đã tham gia nhiều hơn 3 đề án.
SELECT nv.MANV, COUNT(*) AS SLDA
FROM dbo.NHANVIEN AS nv JOIN dbo.PHANCONG AS pc ON pc.MA_NVIEN = nv.MANV
GROUP BY nv.MANV
HAVING COUNT(*) > 3
-- 45. Cho biết các đề án có nhiều hơn 10 nhân viên tham gia.
SELECT pc.MADA, da.TENDA
FROM dbo.PHANCONG pc JOIN dbo.DEAN da ON pc.MADA = da.MADA
GROUP BY pc.MADA, da.TENDA
HAVING COUNT(pc.MA_NVIEN) > 10