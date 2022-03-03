CREATE DATABASE ThucTap;
GO
USE ThucTap;
GO
CREATE TABLE TBLKhoa
(Makhoa char(10)primary key,
 Tenkhoa char(30),
 Dienthoai char(10));
CREATE TABLE TBLGiangVien(
Magv int primary key,
Hotengv char(30),
Luong decimal(5,2),
Makhoa char(10) references TBLKhoa);
CREATE TABLE TBLSinhVien(
Masv int primary key,
Hotensv char(40),
Makhoa char(10)foreign key references TBLKhoa,
Namsinh int,
Quequan char(30));
CREATE TABLE TBLDeTai(
Madt char(10)primary key,
Tendt char(30),
Kinhphi int,
Noithuctap char(30));
CREATE TABLE TBLHuongDan(
Masv int primary key,
Madt char(10)foreign key references TBLDeTai,
Magv int foreign key references TBLGiangVien,
KetQua decimal(5,2));
INSERT INTO TBLKhoa VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);
INSERT INTO TBLGiangVien VALUES
(11,'Thanh Binh',700,'Geo'),    
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');
INSERT INTO TBLSinhVien VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');
INSERT INTO TBLDeTai VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );
INSERT INTO TBLHuongDan VALUES
(1,'Dt01',13,8),
(2,'Dt03',14,0),
(3,'Dt03',12,10),
(5,'Dt04',14,7),
(6,'Dt01',13,Null),
(7,'Dt04',11,10),
(8,'Dt03',15,6)
SELECT * FROM TBLKHOA
SELECT * FROM TBLSINHVIEN
SELECT * FROM TBLGiangVien
SELECT * FROM TBLDETAI
SELECT * FROM TBLHUONGDAN



--Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
SELECT G.Magv, G.Hotengv, K.Tenkhoa
FROM TBLGiangVien G, TBLKhoa K
WHERE G.Makhoa=K.Makhoa
GO
SELECT TBLGiangVien.Magv, TBLGiangVien.Hotengv, TBLKhoa.Tenkhoa
FROM TBLGiangVien
INNER JOIN 
	TBLKhoa
	ON TBLGiangVien.Makhoa=TBLKhoa.Makhoa
GO
--Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
SELECT G.Magv, G.Hotengv, K.Tenkhoa
FROM TBLGiangVien G
INNER JOIN 
	TBLKhoa K
	ON G.Makhoa=K.Makhoa
WHERE K.Tenkhoa='DIA LY va QLTN' 
GO
--Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) AS 'So SV khoa CNSH'
FROM TBLSinhVien
WHERE Makhoa IN
	(SELECT Makhoa
	FROM TBLKhoa
	WHERE Tenkhoa='CONG NGHE SINH HOC')
GO
--Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
SELECT
	Masv,
	Hotensv,
	ISNULL(
		CAST((YEAR(GETDATE())- Namsinh) AS Varchar),
		'Khong xac dinh') AS 'Tuoi'
FROM TBLSinhVien
GO
--Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) AS 'So GV khoa CNSH'
FROM TBLGiangVien
WHERE Makhoa IN
	(SELECT Makhoa
	FROM TBLKhoa
	WHERE Tenkhoa='CONG NGHE SINH HOC')
GO
--Cho biết thông tin về sinh viên không tham gia thực tập
SELECT S.*
FROM TBLSinhVien S,TBLHuongDan H
WHERE 
	S.Masv=H.Masv
	AND (H.KetQua=0
		OR H.KetQua IS NULL)
GO
SELECT S.*
FROM TBLSinhVien S
INNER JOIN 
	TBLHuongDan H
	ON S.Masv=H.Masv
WHERE 
	H.KetQua=0
	OR H.KetQua IS NULL
GO
--Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT K.Makhoa, K.Tenkhoa, COUNT(G.Magv) AS 'So GV'
FROM TBLKhoa K, TBLGiangVien G
WHERE K.Makhoa=G.Makhoa
GROUP BY K.Makhoa,K.Tenkhoa
GO
SELECT K.Makhoa, K.Tenkhoa, COUNT(G.Magv) AS 'So GV'
FROM TBLKhoa K
INNER JOIN
	TBLGiangVien G
	ON G.Makhoa=K.Makhoa
GROUP BY K.Makhoa, K.Tenkhoa
GO
--Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
SELECT K.Dienthoai
FROM TBLKhoa K, TBLSinhVien S
WHERE 
	K.Makhoa=S.Makhoa
	AND S.Hotensv='Le Van Son'
GO
SELECT K.Dienthoai,K.Makhoa
FROM TBLKhoa K
INNER JOIN
	TBLSinhVien S
	ON K.Makhoa=S.Makhoa
WHERE S.Hotensv='Le Van Son'
GO
--Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
SELECT D.Madt, D.Tendt
FROM TBLGiangVien G, TBLDeTai D, TBLHuongDan H
WHERE 
	G.Magv=H.Magv
	AND D.Madt = H.Madt
	AND G.Hotengv ='Tran Son'
GO
SELECT TBLDeTai.Madt,TBLDeTai.Tendt,*
FROM TBLGiangVien 
INNER JOIN 
	TBLHuongDan
	ON TBLGiangVien.Magv = TBLHuongDan.Magv
INNER JOIN 
	TBLDeTai
	ON TBLDeTai.Madt = TBLHuongDan.Madt
WHERE TBLGiangVien.Hotengv = 'Tran Son'
GO
--Cho biết tên đề tài không có sinh viên nào thực tập
SELECT D.Tendt,*
FROM TBLDeTai D
WHERE NOT EXISTS(
	SELECT *
	FROM TBLHuongDan
	WHERE TBLHuongDan.Madt = D.Madt)
GO
--Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
SELECT G.Magv, G.Hotengv, K.Tenkhoa
FROM TBLGiangVien G 
INNER JOIN 
	TBLKhoa K
	ON G.Makhoa = K.Makhoa
WHERE G.Magv IN (
	SELECT Magv
	FROM TBLHuongDan
	GROUP BY Magv
	HAVING COUNT(MaSV)>=3)
GO
--Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
SELECT TOP 1 Madt, Tendt
FROM TBLDeTai
WHERE Kinhphi IN (
	SELECT MAX(Kinhphi)
	FROM TBLDeTai)
GO
--Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
SELECT Madt, Tendt
FROM TBLDeTai 
WHERE Madt IN (
	SELECT Madt
	FROM TBLHuongDan
	GROUP BY Madt
	HAVING COUNT(Madt)>2)
GROUP BY Madt, Tendt
GO
--Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
SELECT S.Masv, S.Hotensv,H.KetQua
FROM TBLSinhVien S
INNER JOIN 
	TBLHuongDan H
	ON S.Masv=H.Masv
WHERE S.Makhoa IN(
	SELECT Makhoa
	FROM TBLKhoa
	WHERE Tenkhoa='Dia ly va QLTN')
GO
--Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
SELECT T.Tenkhoa, COUNT(S.Makhoa) 'SL SV'
FROM TBLKhoa T, TBLSinhVien S
WHERE T.Makhoa=S.Makhoa
GROUP BY T.Tenkhoa
GO
--Cho biết thông tin về các sinh viên thực tập tại quê nhà
SELECT S.*
FROM TBLSinhVien S
INNER JOIN
	TBLHuongDan H
	ON H.Masv=S.Masv
INNER JOIN
	TBLDeTai D
	ON H.Madt=D.Madt
WHERE D.Noithuctap=S.Quequan
GO
--Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
SELECT S.*
FROM TBLSinhVien S
INNER JOIN
	TBLHuongDan H
	ON H.Masv=S.Masv
WHERE H.KetQua IS NULL
GO
--Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
SELECT S.Masv,S.Hotensv
FROM TBLSinhVien S
INNER JOIN
	TBLHuongDan H
	ON H.Masv=S.Masv
WHERE H.KetQua = 0
GO