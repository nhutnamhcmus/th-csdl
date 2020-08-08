USE master
GO 
IF DB_ID('QUANLYTHAMQUAN') IS NOT NULL
	DROP DATABASE QUANLYTHAMQUAN
GO 
CREATE DATABASE QUANLYTHAMQUAN
GO 
USE QUANLYTHAMQUAN
GO 
SET ANSI_NULLS ON
GO
-- TẠO BẢNG VÀ TẠO KHOÁ CHÍNH
CREATE TABLE TINH_THANH (
	QuocGia CHAR(5),
	MaTinhThanh CHAR(5),
	DanSo INT,
	DienTich REAL,
	TenTT NVARCHAR(30),

	CONSTRAINT PK_TINH_THANH PRIMARY KEY (MaTinhThanh)
)

CREATE TABLE QUOC_GIA (
	MaQG CHAR(5),
	TenQG NVARCHAR(20),
	ThuDo CHAR(5),
	DanSo INT,
	DienTich REAL

	CONSTRAINT PK_QUOC_GIA PRIMARY KEY (MaQG)
)

CREATE TABLE DIEM_THAM_QUAN (
	MaDTQ CHAR(10),
	TenDTQ NVARCHAR(30),
	TinhThanh CHAR(5),
	QuocGia CHAR(5),
	DacDiem NVARCHAR(50),

	CONSTRAINT PK_DIEM_THAM_QUAN PRIMARY KEY (MaDTQ)
)

ALTER TABLE dbo.QUOC_GIA
ADD CONSTRAINT FK_QUOC_GIA_TINH_THANH
FOREIGN KEY (ThuDo)
REFERENCES dbo.TINH_THANH(MaTinhThanh)

ALTER TABLE dbo.DIEM_THAM_QUAN
ADD CONSTRAINT FK_DIEM_THAM_QUAN_TINHTHANH
FOREIGN KEY (TinhThanh)
REFERENCES dbo.TINH_THANH(MaTinhThanh)

ALTER TABLE dbo.DIEM_THAM_QUAN
ADD CONSTRAINT FK_DIEM_THAM_QUAN_QUOC_GIA
FOREIGN KEY (QuocGia)
REFERENCES dbo.QUOC_GIA(MaQG)


INSERT dbo.TINH_THANH
(
    QuocGia,
    MaTinhThanh,
    DanSo,
    DienTich,
    TenTT
)
VALUES
(   'QG002',  -- QuocGia - char(5)
    'TT001',  -- MaTinhThanh - char(5)
    2500000,   -- DanSo - int
    972.39, -- DienTich - real
    N'Hà Nội'  -- TenTT - nvarchar(30)
    )

INSERT dbo.TINH_THANH
(
    QuocGia,
    MaTinhThanh,
    DanSo,
    DienTich,
    TenTT
)
VALUES
(   'QG002',  -- QuocGia - char(5)
    'TT002',  -- MaTinhThanh - char(5)
    5344000,   -- DanSo - int
    5009.00, -- DienTich - real
    N'Huế'  -- TenTT - nvarchar(30)
    )

INSERT dbo.TINH_THANH
(
    QuocGia,
    MaTinhThanh,
    DanSo,
    DienTich,
    TenTT
)
VALUES
(   'QG003',  -- QuocGia - char(5)
    'TT003',  -- MaTinhThanh - char(5)
    12084000,   -- DanSo - int
    2187.00, -- DienTich - real
    N'Tokyo'  -- TenTT - nvarchar(30)
    )

INSERT dbo.QUOC_GIA
(
    MaQG,
    TenQG,
    ThuDo,
    DanSo,
    DienTich
)
VALUES
(   'QG002',  -- MaQG - char(5)
    N'Việt Nam', -- TenQG - nvarchar(20)
    NULL,  -- ThuDo - char(5)
    115000000,   -- DanSo - int
    331688.00  -- DienTich - real
    )

INSERT dbo.QUOC_GIA
(
    MaQG,
    TenQG,
    ThuDo,
    DanSo,
    DienTich
)
VALUES
(   'QG003',  -- MaQG - char(5)
    N'Nhật Bản', -- TenQG - nvarchar(20)
    NULL,  -- ThuDo - char(5)
    129500000,   -- DanSo - int
    337834.00  -- DienTich - real
    )

UPDATE dbo.QUOC_GIA
SET ThuDo = 'TT001'
WHERE TenQG = N'Việt Nam'

UPDATE dbo.QUOC_GIA
SET ThuDo = 'TT003'
WHERE TenQG = 'Nhật Bản'


INSERT dbo.DIEM_THAM_QUAN
(
    MaDTQ,
    TenDTQ,
    TinhThanh,
    QuocGia,
    DacDiem
)
VALUES
(   'DTQ001',  -- MaDTQ - char(10)
    N'Văn Miếu', -- TenDTQ - nvarchar(30)
    'TT001',  -- TinhThanh - char(5)
    'QG002',  -- QuocGia - char(5)
    N'Di tích cổ'  -- DacDiem - nvarchar(50)
    )

INSERT dbo.DIEM_THAM_QUAN
(
    MaDTQ,
    TenDTQ,
    TinhThanh,
    QuocGia,
    DacDiem
)
VALUES
(   'DTQ002',  -- MaDTQ - char(10)
    N'Hoàng Lăng', -- TenDTQ - nvarchar(30)
    'TT002',  -- TinhThanh - char(5)
    'QG002',  -- QuocGia - char(5)
    N'Di tích cổ'  -- DacDiem - nvarchar(50)
    )

INSERT dbo.DIEM_THAM_QUAN
(
    MaDTQ,
    TenDTQ,
    TinhThanh,
    QuocGia,
    DacDiem
)
VALUES
(   'DTQ003',  -- MaDTQ - char(10)
    N'Tháp Tokyo', -- TenDTQ - nvarchar(30)
    'TT003',  -- TinhThanh - char(5)
    'QG003',  -- QuocGia - char(5)
    N'Công trình hiện đại'  -- DacDiem - nvarchar(50)
    )

-- Câu 3
SELECT DTQ.MaDTQ AS [Mã điểm tham quan], DTQ.TenDTQ AS [Tên điểm tham quan]
FROM dbo.DIEM_THAM_QUAN AS DTQ
WHERE DTQ.TinhThanh IN (SELECT TT.MaTinhThanh
					FROM dbo.TINH_THANH AS TT JOIN dbo.QUOC_GIA AS QG ON QG.MaQG = TT.QuocGia
					WHERE TT.DienTich > (QG.DienTich / 100 )
					)

-- Câu 4
SELECT QG.MaQG AS [Mã quốc gia], QG.TenQG AS [Tên quốc gia]
FROM dbo.QUOC_GIA AS QG JOIN dbo.TINH_THANH AS TT ON TT.QuocGia = QG.MaQG
GROUP BY TT.QuocGia
HAVING COUNT(*) > 30

