/****** Database QuanLyPhanCongDeAn ******/

-- KHỞI TẠO DATABASE: QUANLYPHANCONGDEAN
CREATE DATABASE QUANLYPHANCONGDEAN

GO
USE QUANLYPHANCONGDEAN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------
-- Bước 1 : TẠO BẢNG VÀ KHÓA CHÍNH
-----------------------------------------------------------
-- KHỞI TẠO BẢNG PHONGBAN
CREATE TABLE PHONGBAN (
	TENPHG 		NVARCHAR(30),
	MAPHG 		INT NOT NULL,
	TRPHG 		CHAR(9),
	NG_NHANCHUC		DATETIME,
	CONSTRAINT PK_PHONGBAN PRIMARY KEY (MAPHG)
)
-- KHỞI TẠO BẢNG NHANVIEN
CREATE TABLE NHANVIEN (
	HONV 		NVARCHAR(30),
	TENLOT 		NVARCHAR(30),
	TENNV 		NVARCHAR(30),
	MANV 		CHAR(9) NOT NULL,
	NGSINH 		DATETIME,
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
	NGSINH 		DATETIME,
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
ADD CONSTRAINT FL_DEAN_PHONGBAN
FOREIGN KEY (PHONG)
REFERENCES dbo.PHONGBAN(MAPHG)

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
    '05/22/1988' -- NG_NHANCHUC - date
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
    '01/01/1995' -- NG_NHANCHUC - date
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
    '06/19/1981' -- NG_NHANCHUC - date
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
    '08/20/1962', -- NGSINH - date
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
    '3/11/1954', -- NGSINH - date
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
    '02/01/1967', -- NGSINH - date
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
    '03/04/1967', -- NGSINH - date
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
    '05/04/1957', -- NGSINH - date
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
	'09/01/1967', -- NGSINH - date
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
   '01/01/1965', -- NGSINH - date
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
UPDATE  NHANVIEN		
SET MA_NQL='005'	
WHERE MANV=N'009'

UPDATE  NHANVIEN 
SET MA_NQL='006' 
WHERE MANV=N'005'

UPDATE  NHANVIEN 
SET MA_NQL='001' 
WHERE MANV='007'

UPDATE  NHANVIEN 
SET MA_NQL='006' 
WHERE MANV='001'

UPDATE  NHANVIEN 
SET MA_NQL='005' 
WHERE MANV='004'

UPDATE  NHANVIEN 
SET MA_NQL='005' 
WHERE MANV='003'

UPDATE  NHANVIEN 
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
    '04/05/1976', -- NGSINH - date
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
    '25/10/1973', -- NGSINH - date
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
    '03/05/1948', -- NGSINH - date
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
    '29/02/1932', -- NGSINH - date
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
    '01/01/1978', -- NGSINH - date
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
    '30/12/1978', -- NGSINH - date
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
    '05/05/1978', -- NGSINH - date
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
