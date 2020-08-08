/****** Database QLDeTai ******/
USE master
GO 
IF DB_ID('QLDeTai') IS NOT NULL
	DROP DATABASE QLDeTai
GO 
CREATE DATABASE QLDeTai
GO 
USE QLDeTai
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Bước 1 : TẠO BẢNG VÀ KHÓA CHÍNH

-- KHỞI TẠO BẢNG BOMON
CREATE TABLE BOMON
(
	MABM CHAR(5) NOT NULL,
	TENBM NVARCHAR(40) NULL,
	PHONG CHAR(5) NULL,
	DIENTHOAI CHAR(12) NULL,
	TRUONGBM CHAR(5) NULL,
	MAKHOA CHAR(4) NULL,
	NGAYNHANCHUC DATE NULL,
	CONSTRAINT PK_BOMON PRIMARY KEY (MABM) 
)

-- KHỞI TẠO BẢNG CHUDE
CREATE TABLE CHUDE
(
	MACD CHAR(4) NOT NULL,
	TENCD NVARCHAR(50) NULL,
	CONSTRAINT PK_CHUDE PRIMARY KEY (MACD) 
)

-- KHỞI TẠO BẢNG CONGVIEC
CREATE TABLE CONGVIEC
(
	MADT CHAR(3) NOT NULL,
	SOTT INT  NOT NULL,
	TENCV NVARCHAR(40) NULL,
	NGAYBD DATE NULL,
	NGAYKT DATE NULL,
	CONSTRAINT PK_CONGVIEC PRIMARY KEY (MADT, SOTT) 
)

-- KHỞI TẠO BẢNG DETAI
CREATE TABLE DETAI
(
	MADT CHAR(3) NOT NULL,
	TENDT NVARCHAR(100) NULL,
	CAPQL NVARCHAR(40) NULL,
	KINHPHI NUMERIC(10, 1) NULL,
	NGAYBD DATE  NULL,
	NGAYKT DATE  NULL,
	MACD CHAR(4) NULL,
	GVCNDT CHAR(5) NULL,
	CONSTRAINT PK_DETAI PRIMARY KEY (MADT) 
)

-- KHỞI TẠO BẢNG GIAOVIEN
CREATE TABLE GIAOVIEN
(
	MAGV CHAR(5) NOT NULL,
	HOTEN NVARCHAR(40) NULL,
	LUONG NUMERIC(10, 1) NULL,
	PHAI NVARCHAR(3) NULL,
	NGSINH DATE NULL,
	DIACHI NVARCHAR(100) NULL,
	GVQLCM CHAR(5) NULL,
	MABM CHAR(5) NULL,
	CONSTRAINT PK_GIAOVIEN PRIMARY KEY (MAGV) 
)

-- KHỞI TẠO BẢNG GV_DT
CREATE TABLE GV_DT
(
	MAGV char(5) NOT NULL,
	DIENTHOAI char(12) NOT NULL,
	CONSTRAINT PK_GV_DT PRIMARY KEY (MAGV, DIENTHOAI) 
)

-- KHỞI TẠO BẢNG KHOA
CREATE TABLE KHOA
(
	MAKHOA CHAR(4) NOT NULL,
	TENKHOA NVARCHAR(40) NULL,
	NAMTL INT NULL,
	PHONG CHAR(5) NULL,
	DIENTHOAI CHAR(12) NULL,
	TRUONGKHOA CHAR(5) NULL,
	NGAYNHANCHUC DATE NULL,
	CONSTRAINT PK_KHOA PRIMARY KEY (MAKHOA) 
)

-- KHỞI TẠO BẢNG NGUOITHAN
CREATE TABLE NGUOITHAN
(
	MAGV CHAR(5) NOT NULL,
	TEN NVARCHAR(20) NOT NULL,
	NGSINH DATE NULL,
	PHAI NVARCHAR(3) NULL,
	CONSTRAINT PK_NGUOITHAN PRIMARY KEY (MAGV, TEN) 
)

-- KHỞI TẠO BẢNG THAMGIADT
CREATE TABLE THAMGIADT
(
	MAGV CHAR(5) NOT NULL,
	MADT CHAR(3) NOT NULL,
	STT int NOT NULL,
	PHUCAP NUMERIC(5, 1) NULL,
	KETQUA NVARCHAR(40) NULL,
	CONSTRAINT PK_THAMGIADT PRIMARY KEY (MAGV, MADT, STT) 
)

-- Bước 2 : TẠO KHÓA NGOẠI
ALTER TABLE dbo.BOMON 
ADD CONSTRAINT FK_BOMON_GIAOVIEN 
	FOREIGN KEY(TRUONGBM)
	REFERENCES dbo.GIAOVIEN(MAGV)

ALTER TABLE dbo.BOMON  
ADD CONSTRAINT FK_BOMON_KHOA 
	FOREIGN KEY(MAKHOA)
	REFERENCES dbo.KHOA(MAKHOA)

ALTER TABLE dbo.CONGVIEC  
ADD CONSTRAINT FK_CONGVIEC_DETAI 
	FOREIGN KEY(MADT)
	REFERENCES dbo.DETAI (MADT)

ALTER TABLE dbo.DETAI 
ADD CONSTRAINT FK_DETAI_CHUDE 
	FOREIGN KEY(MACD)
	REFERENCES dbo.CHUDE (MACD)

ALTER TABLE dbo.DETAI 
ADD CONSTRAINT FK_DETAI_GIAOVIEN 
	FOREIGN KEY(GVCNDT)
	REFERENCES dbo.GIAOVIEN (MAGV)

ALTER TABLE dbo.GIAOVIEN 
ADD CONSTRAINT FK_GIAOVIEN_BOMON 
	FOREIGN KEY(MABM)
	REFERENCES dbo.BOMON(MABM)

ALTER TABLE dbo.GIAOVIEN 
ADD CONSTRAINT FK_GIAOVIEN_GIAOVIEN 
	FOREIGN KEY(GVQLCM)
	REFERENCES dbo.GIAOVIEN(MAGV)

ALTER TABLE dbo.GV_DT 
ADD CONSTRAINT FK_GV_DT_GIAOVIEN 
	FOREIGN KEY(MAGV)
	REFERENCES dbo.GIAOVIEN(MAGV)

ALTER TABLE dbo.KHOA 
ADD CONSTRAINT FK_KHOA_GIAOVIEN 
	FOREIGN KEY(TRUONGKHOA)
	REFERENCES dbo.GIAOVIEN (MAGV)

ALTER TABLE dbo.NGUOITHAN 
ADD CONSTRAINT FK_NGUOITHAN_GIAOVIEN 
	FOREIGN KEY(MAGV)
	REFERENCES dbo.GIAOVIEN(MAGV)

ALTER TABLE dbo.THAMGIADT 
ADD CONSTRAINT FK_THAMGIADT_CONGVIEC 
	FOREIGN KEY(MADT, STT)
	REFERENCES dbo.CONGVIEC(MADT, SOTT)

ALTER TABLE dbo.THAMGIADT 
ADD CONSTRAINT FK_THAMGIADT_GIAOVIEN 
	FOREIGN KEY(MAGV)
	REFERENCES dbo.GIAOVIEN(MAGV)

-- Bước 3 : TẠO RÀNG BUỘC DỮ LIỆU
ALTER TABLE dbo.GIAOVIEN
ADD CONSTRAINT CHECK_PHAI_GIAOVIEN
CHECK (PHAI IN ('Nam', N'Nữ'))
--
ALTER TABLE dbo.NGUOITHAN
ADD CONSTRAINT CHECK_PHAI_NGUOITHAN
CHECK (PHAI IN ('Nam', N'Nữ'))

-- Bước 4 : THÊM VÀ UPDATE DỮ LIỆU
--Insert CHUDE(MACD, TENCD)
INSERT INTO dbo.CHUDE
(
    MACD,
    TENCD
)
VALUES
(   'NCPT', -- MACD - char(4)
    N'Nghiên cứu phát triển' -- TENCD - nvarchar(50)
    )
INSERT INTO dbo.CHUDE
(
    MACD,
    TENCD
)
VALUES
(   'QLGD', -- MACD - char(4)
    N'Quản lý giáo dục' -- TENCD - nvarchar(50)
    )
INSERT INTO dbo.CHUDE
(
    MACD,
    TENCD
)
VALUES
(   'ƯDCN', -- MACD - char(4)
    N'Ứng dụng nghiên cứu' -- TENCD - nvarchar(50)
    )
--Insert KHOA(MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, NGAYNHANCHUC)
INSERT INTO dbo.KHOA
(
    MAKHOA,
    TENKHOA,
    NAMTL,
    PHONG,
    DIENTHOAI,
    TRUONGKHOA,
    NGAYNHANCHUC
)
VALUES
(   'CNTT',       -- MAKHOA - char(4)
    N'Công nghệ thông tin',      -- TENKHOA - nvarchar(40)
    1995,        -- NAMTL - int
    'B11',       -- PHONG - char(5)
    '0838123456',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGKHOA - char(5)
    CAST(N'2005-02-20' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.KHOA
(
    MAKHOA,
    TENKHOA,
    NAMTL,
    PHONG,
    DIENTHOAI,
    TRUONGKHOA,
    NGAYNHANCHUC
)
VALUES
(   'HH',       -- MAKHOA - char(4)
    N'Hóa học',      -- TENKHOA - nvarchar(40)
    1980,        -- NAMTL - int
    'B41',       -- PHONG - char(5)
    '0838456456',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGKHOA - char(5)
    CAST(N'2001-10-15' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.KHOA
(
    MAKHOA,
    TENKHOA,
    NAMTL,
    PHONG,
    DIENTHOAI,
    TRUONGKHOA,
    NGAYNHANCHUC
)
VALUES
(   'SH',       -- MAKHOA - char(4)
    N'Sinh học',      -- TENKHOA - nvarchar(40)
    1980,        -- NAMTL - int
    'B31',       -- PHONG - char(5)
    '0838454545',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGKHOA - char(5)
    CAST(N'2000-10-11' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.KHOA
(
    MAKHOA,
    TENKHOA,
    NAMTL,
    PHONG,
    DIENTHOAI,
    TRUONGKHOA,
    NGAYNHANCHUC
)
VALUES
(   'VL',       -- MAKHOA - char(4)
    N'Vật lý',      -- TENKHOA - nvarchar(40)
    1976,        -- NAMTL - int
    'B31',       -- PHONG - char(5)
    '0838223223',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGKHOA - char(5)
    CAST(N'2003-09-18' AS DATE) -- NGAYNHANCHUC - date
    )
--Insert BOMON(MABM, TENBM, PHONG, DIENTHOAI, MAKHOA, NGAYNHANCHUC)
INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'CNTT',       -- MABM - char(5)
    N'Công nghệ tri thức',      -- TENBM - nvarchar(40)
    'B15',       -- PHONG - char(5)
    '0838126126',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'CNTT',       -- MAKHOA - char(4)
    NULL -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'HHC',       -- MABM - char(5)
    N'Hóa hữu cơ',      -- TENBM - nvarchar(40)
    'B44',       -- PHONG - char(5)
    '838222222',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'HH',       -- MAKHOA - char(4)
    NULL -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'HL',       -- MABM - char(5)
    N'Hóa lý',      -- TENBM - nvarchar(40)
    'B42',       -- PHONG - char(5)
    '0838878787',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'HH',       -- MAKHOA - char(4)
    NULL -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'HPT',       -- MABM - char(5)
    N'Hóa phân tích',      -- TENBM - nvarchar(40)
    'B43',       -- PHONG - char(5)
    '0838777777',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'HH',       -- MAKHOA - char(4)
    CAST(N'2007-10-15' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'HTTT',       -- MABM - char(5)
    N'Hệ thống thông tin',      -- TENBM - nvarchar(40)
    'B13',       -- PHONG - char(5)
    '0838125125',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'CNTT',       -- MAKHOA - char(4)
    CAST(N'2004-09-20' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'MMT',       -- MABM - char(5)
    N'Mạng máy tính',      -- TENBM - nvarchar(40)
    'B16',       -- PHONG - char(5)
    '0838676767',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'CNTT',       -- MAKHOA - char(4)
    CAST(N'2005-05-15' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'SH',       -- MABM - char(5)
    N'Sinh hóa',      -- TENBM - nvarchar(40)
    'B33',       -- PHONG - char(5)
    '0838898989',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'SH',       -- MAKHOA - char(4)
    NULL -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'VLĐT',       -- MABM - char(5)
    N'Vật lý điện tử',      -- TENBM - nvarchar(40)
    'B23',       -- PHONG - char(5)
    '0838234234',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'VL',       -- MAKHOA - char(4)
    NULL -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'VLƯD',       -- MABM - char(5)
    N'Vật lý ứng dụng',      -- TENBM - nvarchar(40)
    'B24',       -- PHONG - char(5)
    '0838454545',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'VL',       -- MAKHOA - char(4)
    CAST(N'2006-02-18' AS DATE) -- NGAYNHANCHUC - date
    )

INSERT INTO dbo.BOMON
(
    MABM,
    TENBM,
    PHONG,
    DIENTHOAI,
    TRUONGBM,
    MAKHOA,
    NGAYNHANCHUC
)
VALUES
(   'VS',       -- MABM - char(5)
    N'Vi sinh',      -- TENBM - nvarchar(40)
    'B32',       -- PHONG - char(5)
    '0838909090',       -- DIENTHOAI - char(12)
    NULL,       -- TRUONGBM - char(5)
    'SH',       -- MAKHOA - char(4)
    CAST(N'2007-01-01' AS DATE) -- NGAYNHANCHUC - date
    )
--Insert GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM)
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
(   '001',        -- MAGV - char(5)
    N'Nguyễn Hoài An',       -- HOTEN - nvarchar(40)
    CAST(2000.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1973-02-15' AS Date), -- NGSINH - date
    N'25/3 Lạc Long Quân, Q.10, TP HCM',       -- DIACHI - nvarchar(100)
    NULL,        -- GVQLCM - char(5)
    'MMT'         -- MABM - char(5)
    )

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
(   '002',        -- MAGV - char(5)
    N'Trần Trà Hương',       -- HOTEN - nvarchar(40)
    CAST(2500.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    N'Nữ',        -- PHAI - char(3)
    CAST(N'1960-06-20' AS DATE), -- NGSINH - date
    N'125 Trần Hưng Đạo, Q.1, TP HCM',       -- DIACHI - nvarchar(100)
    NULL,        -- GVQLCM - char(5)
    'HTTT'         -- MABM - char(5)
    )

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
(   '003',        -- MAGV - char(5)
    N'Nguyễn Ngọc Ánh',       -- HOTEN - nvarchar(40)
    CAST(2200.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    N'Nữ',        -- PHAI - char(3)
    CAST(N'1975-05-11' AS DATE), -- NGSINH - date
    N'12/21 Võ Văn Ngân Thủ Đức, TP HCM',       -- DIACHI - nvarchar(100)
    '002',        -- GVQLCM - char(5)
    'HTTT'         -- MABM - char(5)
    )

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
(   '004',        -- MAGV - char(5)
    N'Trương Nam Sơn',       -- HOTEN - nvarchar(40)
    CAST(2300.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1959-06-20' AS DATE), -- NGSINH - date
    N'215 Lý Thường Kiệt, TP Biên Hòa',       -- DIACHI - nvarchar(100)
    NULL,        -- GVQLCM - char(5)
    'VS'         -- MABM - char(5)
    )

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
(   '005',        -- MAGV - char(5)
    N'Lý Hoàng Hà',       -- HOTEN - nvarchar(40)
    CAST(2500.0 AS Numeric(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1954-10-23' AS Date), -- NGSINH - date
    N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM',       -- DIACHI - nvarchar(100)
    NULL,        -- GVQLCM - char(5)
    'VLĐT'         -- MABM - char(5)
    )

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
(   '006',        -- MAGV - char(5)
    N'Trần Bạch Tuyết',       -- HOTEN - nvarchar(40)
    CAST(1500.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    N'Nữ',        -- PHAI - char(3)
    CAST(N'1980-05-20' AS DATE), -- NGSINH - date
    N'127 Hùng Vương, TP Mỹ Tho',       -- DIACHI - nvarchar(100)
    '004',        -- GVQLCM - char(5)
    'VS'         -- MABM - char(5)
    )

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
(   '007',        -- MAGV - char(5)
    N'Nguyễn An Trung',       -- HOTEN - nvarchar(40)
    CAST(2100.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1976-06-05' AS Date), -- NGSINH - date
    N'234 3/2, TP Biên Hòa',       -- DIACHI - nvarchar(100)
    NULL,        -- GVQLCM - char(5)
    'HPT'         -- MABM - char(5)
    )

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
(   '008',        -- MAGV - char(5)
    N'Trần Trung Hiếu',       -- HOTEN - nvarchar(40)
    CAST(1800.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1977-08-06' AS DATE), -- NGSINH - date
    N'22/11 Lý Thường Kiệt, TP Mỹ Tho',       -- DIACHI - nvarchar(100)
    '007',        -- GVQLCM - char(5)
    'HPT'         -- MABM - char(5)
    )

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
(   '009',        -- MAGV - char(5)
    N'Trần Hoàng Nam',       -- HOTEN - nvarchar(40)
    CAST(2000.0 AS NUMERIC(10, 1)),      -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1975-11-22' AS DATE), -- NGSINH - date
    N'234 Trần Não, An Phú, TP HCM',       -- DIACHI - nvarchar(100)
    '001',        -- GVQLCM - char(5)
    'MMT'         -- MABM - char(5)
    )

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
(   '010',        -- MAGV - char(5)
    N'Phạm Nam Thanh',       -- HOTEN - nvarchar(40)
    CAST(1500.0 AS NUMERIC(10, 1)),     -- LUONG - numeric(10, 1)
    'Nam',        -- PHAI - char(3)
    CAST(N'1980-12-12' AS DATE), -- NGSINH - date
    N'221 Hùng Vương, Q.5, TP HCM',       -- DIACHI - nvarchar(100)
    '007',        -- GVQLCM - char(5)
    'HPT'         -- MABM - char(5)
    )
--Update KHOA(TRUONGKHOA)
UPDATE dbo.KHOA
SET dbo.KHOA.TRUONGKHOA = '002'
WHERE dbo.KHOA.MAKHOA = 'CNTT'

UPDATE dbo.KHOA
SET dbo.KHOA.TRUONGKHOA = '007' 
WHERE dbo.KHOA.MAKHOA = 'HH'

UPDATE dbo.KHOA 
SET dbo.KHOA.TRUONGKHOA = '004' 
WHERE dbo.KHOA.MAKHOA = 'SH'

UPDATE dbo.KHOA
SET dbo.KHOA.TRUONGKHOA = '005'
WHERE dbo.KHOA.MAKHOA = 'VL'

--Update BOMON(TRUONGBM)
UPDATE dbo.BOMON
SET dbo.BOMON.TRUONGBM = '007'
WHERE dbo.BOMON.MABM = 'HPT'

UPDATE dbo.BOMON
SET dbo.BOMON.TRUONGBM = '002' 
WHERE dbo.BOMON.MABM = 'HTTT'

UPDATE dbo.BOMON
SET dbo.BOMON.TRUONGBM = '001' 
WHERE BOMON.MABM = 'MMT'

UPDATE dbo.BOMON 
SET dbo.BOMON.TRUONGBM = '005' 
WHERE dbo.BOMON.MABM = 'VLƯD'

UPDATE dbo.BOMON 
SET dbo.BOMON.TRUONGBM = '004' 
WHERE dbo.BOMON.MABM = 'VS'

--Insert GV_DT(MAGV, DIENTHOAI)
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '001', -- MAGV - char(5)
    '0838912112'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '001', -- MAGV - char(5)
    '00903123123'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '002', -- MAGV - char(5)
    '0913454545'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '003', -- MAGV - char(5)
    '0838121212'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '003', -- MAGV - char(5)
    '0903656565'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '003', -- MAGV - char(5)
    '0937125125'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '006', -- MAGV - char(5)
    '0937888888'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '008', -- MAGV - char(5)
    '0653717171'  -- DIENTHOAI - char(12)
    )
INSERT INTO dbo.GV_DT
(
    MAGV,
    DIENTHOAI
)
VALUES
(   '008', -- MAGV - char(5)
    '0913232323'  -- DIENTHOAI - char(12)
    )
--Insert DETAI(MADT, TENDT, CAPQL, KINHPHI, NGAYBD, NGAYKT, MACD, GVCNDT) 
INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '001',        -- MADT - char(3)
    N'HTTT quản lý các trường ĐH',       -- TENDT - nvarchar(100)
    N'ĐHQG',       -- CAPQL - nvarchar(40)
    CAST(20.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2007-10-20' AS DATE), -- NGAYBD - date
    CAST(N'2008-10-20' AS DATE), -- NGAYKT - date
    'QLGD',        -- MACD - char(4)
    '002'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '002',        -- MADT - char(3)
    N'HTTT quản lý giáo vụ cho một khoa',       -- TENDT - nvarchar(100)
    N'Trường',       -- CAPQL - nvarchar(40)
    CAST(20.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2000-10-12' AS DATE), -- NGAYBD - date
    CAST(N'2001-10-12' AS DATE), -- NGAYKT - date
    'QLGD',        -- MACD - char(4)
    '002'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '003',        -- MADT - char(3)
    N'Nghiên cứu chế tạo sợi Nanô Platin',       -- TENDT - nvarchar(100)
    N'ĐHQG',       -- CAPQL - nvarchar(40)
    CAST(300.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2008-05-15' AS DATE), -- NGAYBD - date
    CAST(N'2010-05-15' AS DATE), -- NGAYKT - date
    'NCPT',        -- MACD - char(4)
    '005'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '004',        -- MADT - char(3)
    N'Tạo vật liệu sinh học bằng màng ối người',       -- TENDT - nvarchar(100)
    N'Nhà nước',       -- CAPQL - nvarchar(40)
    CAST(100.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2007-01-01' AS DATE), -- NGAYBD - date
    CAST(N'2009-12-31' AS DATE), -- NGAYKT - date
    'NCPT',        -- MACD - char(4)
    '004'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '005',        -- MADT - char(3)
    N'Ứng dụng hóa học xanh',       -- TENDT - nvarchar(100)
    N'Trường',       -- CAPQL - nvarchar(40)
    CAST(200.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2003-10-10' AS DATE), -- NGAYBD - date
    CAST(N'2004-12-10' AS DATE), -- NGAYKT - date
    'ƯDCN',        -- MACD - char(4)
    '007'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '006',        -- MADT - char(3)
    N'Nghiên cứu tế bào gốc',       -- TENDT - nvarchar(100)
    N'Nhà nước',       -- CAPQL - nvarchar(40)
    CAST(4000.0 AS NUMERIC(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2006-10-20' AS DATE), -- NGAYBD - date
    CAST(N'2009-10-20' AS DATE), -- NGAYKT - date
    'NCPT',        -- MACD - char(4)
    '004'         -- GVCNDT - char(5)
    )

INSERT INTO dbo.DETAI
(
    MADT,
    TENDT,
    CAPQL,
    KINHPHI,
    NGAYBD,
    NGAYKT,
    MACD,
    GVCNDT
)
VALUES
(   '007',        -- MADT - char(3)
    N'HTTT quản lý thư viện ở các trường đại học',       -- TENDT - nvarchar(100)
    N'Trường',       -- CAPQL - nvarchar(40)
    CAST(20.0 AS Numeric(10, 1)),      -- KINHPHI - numeric(10, 1)
    CAST(N'2009-05-10' AS DATE), -- NGAYBD - date
    CAST(N'2010-05-10' AS DATE), -- NGAYKT - date
    'QLGD',        -- MACD - char(4)
    '001'         -- GVCNDT - char(5)
    )
--Insert CONGVIEC(MADT, SOTT, TENCV, NGAYBD, NGAYKT)
INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '001',        -- MADT - char(3)
    1,         -- SOTT - int
    N'Khởi tạo và Lập kế hoạch',       -- TENCV - nvarchar(40)
    CAST(N'2007-10-20' AS DATE), -- NGAYBD - date
    CAST(N'2008-12-20' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '001',        -- MADT - char(3)
    2,         -- SOTT - int
    N'Xác định yêu cầu',       -- TENCV - nvarchar(40)
    CAST(N'2008-12-21' AS DATE), -- NGAYBD - date
    CAST(N'2008-03-21' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '001',        -- MADT - char(3)
    3,         -- SOTT - int
    N'Phân tích hệ thống',       -- TENCV - nvarchar(40)
    CAST(N'2008-03-22' AS DATE), -- NGAYBD - date
    CAST(N'2008-05-22' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '001',        -- MADT - char(3)
    4,         -- SOTT - int
    N'Thiết kế hệ thống',       -- TENCV - nvarchar(40)
    CAST(N'2008-05-23' AS DATE), -- NGAYBD - date
    CAST(N'2008-06-23' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '001',        -- MADT - char(3)
    5,         -- SOTT - int
    N'Cài đặt thử nghiệm',       -- TENCV - nvarchar(40)
    CAST(N'2008-06-24' AS DATE), -- NGAYBD - date
    CAST(N'2008-10-20' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '002',        -- MADT - char(3)
    1,         -- SOTT - int
    N'Khởi tạo và Lập kế hoạch',       -- TENCV - nvarchar(40)
    CAST(N'2009-05-10' AS DATE), -- NGAYBD - date
    CAST(N'2009-07-10' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '002',        -- MADT - char(3)
    2,         -- SOTT - int
    N'Xác định yêu cầu',       -- TENCV - nvarchar(40)
    CAST(N'2009-07-11' AS DATE), -- NGAYBD - date
    CAST(N'2009-10-11' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '002',        -- MADT - char(3)
    3,         -- SOTT - int
    N'Phân tích hệ thống',       -- TENCV - nvarchar(40)
    CAST(N'2009-10-12' AS DATE), -- NGAYBD - date
    CAST(N'2009-12-20' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '002',        -- MADT - char(3)
    4,         -- SOTT - int
    N'Thiết kế hệ thống',       -- TENCV - nvarchar(40)
    CAST(N'2009-12-21' AS DATE), -- NGAYBD - date
    CAST(N'2010-03-22' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '002',        -- MADT - char(3)
    5,         -- SOTT - int
    N'Cài đặt thử nghiệm',       -- TENCV - nvarchar(40)
    CAST(N'2010-03-23' AS DATE), -- NGAYBD - date
    CAST(N'2010-05-10' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '006',        -- MADT - char(3)
    1,         -- SOTT - int
    N'Lấy mẫu',       -- TENCV - nvarchar(40)
    CAST(N'2006-10-20' AS DATE), -- NGAYBD - date
    CAST(N'2007-02-20' AS DATE)  -- NGAYKT - date
    )

INSERT INTO dbo.CONGVIEC
(
    MADT,
    SOTT,
    TENCV,
    NGAYBD,
    NGAYKT
)
VALUES
(   '006',        -- MADT - char(3)
    2,         -- SOTT - int
    N'Nuôi cấy',       -- TENCV - nvarchar(40)
    CAST(N'2007-02-21' AS DATE), -- NGAYBD - date
    CAST(N'2008-08-21' AS DATE)  -- NGAYKT - date
    )
--Insert THAMGIADT(MAGV, MADT, STT, PHUCAP, KETQUA)
INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '001',   -- MAGV - char(5)
    '002',   -- MADT - char(3)
    1,    -- STT - int
    CAST(0.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '001',   -- MAGV - char(5)
    '002',   -- MADT - char(3)
    2,    -- STT - int
    CAST(2.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '002',   -- MAGV - char(5)
    '001',   -- MADT - char(3)
    4,    -- STT - int
    CAST(2.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )

	INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '003',   -- MAGV - char(5)
    '001',   -- MADT - char(3)
    1,    -- STT - int
    CAST(1.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '003',   -- MAGV - char(5)
    '001',   -- MADT - char(3)
    2,    -- STT - int
    CAST(0.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )
INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '003',   -- MAGV - char(5)
    '001',   -- MADT - char(3)
    4,    -- STT - int
    CAST(1.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )
INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '003',   -- MAGV - char(5)
    '002',   -- MADT - char(3)
    2,    -- STT - int
    CAST(0.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )
INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '004',   -- MAGV - char(5)
    '006',   -- MADT - char(3)
    1,    -- STT - int
    CAST(0.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '004',   -- MAGV - char(5)
    '006',   -- MADT - char(3)
    2,    -- STT - int
    CAST(1.0 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '006',   -- MAGV - char(5)
    '006',   -- MADT - char(3)
    2,    -- STT - int
    CAST(1.5 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    N'Đạt'   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '009',   -- MAGV - char(5)
    '002',   -- MADT - char(3)
    3,    -- STT - int
    CAST(0.5 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )

INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   '009',   -- MAGV - char(5)
    '002',   -- MADT - char(3)
    4,    -- STT - int
    CAST(1.5 AS Numeric(5, 1)), -- PHUCAP - numeric(5, 1)
    NULL   -- KETQUA - nvarchar(40)
    )
--Insert NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '001',        -- MAGV - char(5)
    N'Hùng',       -- TEN - nvarchar(20)
    CAST(N'1990-01-14' AS DATE), -- NGSINH - date
    N'Nam'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '001',        -- MAGV - char(5)
    N'Thủy',       -- TEN - nvarchar(20)
    CAST(N'1994-12-08' AS Date), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '003',        -- MAGV - char(5)
    N'Hà',       -- TEN - nvarchar(20)
    CAST(N'1998-09-03' AS DATE), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '003',        -- MAGV - char(5)
    N'Thu',       -- TEN - nvarchar(20)
    CAST(N'1998-09-03' AS DATE), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '007',        -- MAGV - char(5)
    N'Mai',       -- TEN - nvarchar(20)
    CAST(N'2003-03-26' AS DATE), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '007',        -- MAGV - char(5)
    N'Vy',       -- TEN - nvarchar(20)
    CAST(N'2000-02-14' AS DATE), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '008',        -- MAGV - char(5)
    N'Nam',       -- TEN - nvarchar(20)
    CAST(N'1991-05-06' AS DATE), -- NGSINH - date
    N'Nam'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '009',        -- MAGV - char(5)
    N'An',       -- TEN - nvarchar(20)
    CAST(N'1996-08-19' AS DATE), -- NGSINH - date
    N'Nam'        -- PHAI - nvarchar(3)
    )

INSERT INTO dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   '010',        -- MAGV - char(5)
    N'Nguyệt',       -- TEN - nvarchar(20)
    CAST(N'2006-01-14' AS DATE), -- NGSINH - date
    N'Nữ'        -- PHAI - nvarchar(3)
    )