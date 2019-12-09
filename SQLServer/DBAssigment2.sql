create table USERS
(
	username	VARCHAR(255)	primary key,
	lname		NVARCHAR(255)	NOT NULL,
	minit		NVARCHAR(255)	,
	fname		NVARCHAR(255)	NOT NULL,
	sex			CHAR(1)			NOT NULL,
	bdate		DATE			,
	addr		NVARCHAR(255)	NOT NULL,
	email		VARCHAR(255)	NOT NULL,
	tel			CHAR(10)		NOT NULL,
	type_users	CHAR(2)			NOT NULL,
	passw		VARCHAR(50)		NOT NULL,
	avatar		VARCHAR(255)	,
	constraint chk_tel check (len(tel) = 10),
	constraint chk_sex check (sex = 'F' or sex = 'M')
);
go
create table PRODUCT
(
	pid			VARCHAR(5)		primary key,
	pname		NVARCHAR(255)	NOT NULL,
	pdesc		NTEXT			,
	pmanufac	NVARCHAR(50)	NOT NULL,
	pamount		INT				NOT NULL,
	pcost		MONEY			NOT NULL,
	prate		DECIMAL(2,1)			,
	porigin		NVARCHAR(50)	NOT NULL,
	constraint chk_prate check (prate >= 0 and prate <= 5)
);
go
create table CUSTOMER
(
	username	VARCHAR(255)	primary key,
	constraint fk_user foreign key (username) references USERS(username) ON DELETE CASCADE
);
go
create table TRANS_HIS
(
	tid			VARCHAR(5)		primary key,
	username	VARCHAR(255)	NOT NULL
	constraint fk_trans_his foreign key (username) references CUSTOMER(username) ON DELETE CASCADE
);
go
create table PAYMENT
(
	payid		VARCHAR(5)		primary key,
	paycate		NVARCHAR(255)	NOT NULL,
	constraint chk_paycate check (payid = 'ATM' or payid = 'VISA' or payid = 'TT')
);
go
create table ORD
(
	oid			VARCHAR(5)		primary key,
	ostate		NVARCHAR(255)	NOT NULL,
	otel		CHAR(10)		NOT NULL,
	oaddr		NVARCHAR(255)	NOT NULL,
	ofeeship	MONEY			NOT NULL DEFAULT 0,
	ototal		MONEY			NOT NULL,
	payid		VARCHAR(5)		NOT NULL,
	otime		DATE			NOT NULL,
	ouser		VARCHAR(255)	NOT NULL,	
	tid		VARCHAR(5)		NOT NULL,
	constraint chk_otel check (len(otel) = 10),
	constraint fk_ord_ouser foreign key (ouser) references CUSTOMER(username) ON DELETE CASCADE,
	constraint fk_ord_payid foreign key (payid) references PAYMENT(payid) ON DELETE CASCADE,
	constraint fk_ord_tid foreign key (tid) references TRANS_HIS(tid)
);
go
create table USERCENSOR
(
	username		VARCHAR(255)	primary key,
	username_censor	VARCHAR(255)	,	
	constraint fk_usercensor foreign key (username_censor) references USERS(username) ON DELETE CASCADE
);
go
create table COMMENT
(
	cid			VARCHAR(5)		NOT NULL,
	pid			VARCHAR(5)		NOT NULL,
	comm		NTEXT			,
	cdate		DATE			,
	crate		TINYINT			,
	ctime		TIME(0)			,
	cusercensor	VARCHAR(255)	,
	cuser		VARCHAR(255)	NOT NULL,
	primary key(cid, pid),
	constraint chk_crate check (crate>= 1 and crate <= 5),
	constraint fk_comment_censor foreign key (cusercensor) references USERCENSOR(username),
	constraint fk_comment_user foreign key (cuser) references CUSTOMER(username),
	constraint fk_comment_product foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE
);
go

create table IMG_COMMENT
(
	img			VARCHAR(255)	NOT NULL,
	iid			VARCHAR(5)		NOT NULL,
	cid			VARCHAR(5)		NOT NULL,
	pid			VARCHAR(5)		NOT NULL,
	primary key(iid, cid, pid),
	constraint fk_img_comment foreign key (cid, pid) references COMMENT(cid, pid) ON DELETE CASCADE
);
go
create table IMG_LINK
(
	pid			VARCHAR(5)		NOT NULL,
	ilink		VARCHAR(255)	NOT NULL,
	primary key(pid, ilink),
	constraint fk_img_link foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE
);
go
create table DISTRIBUTOR
(
	did			VARCHAR(5)		primary key,
	daddr		NVARCHAR(255)	NOT NULL,
	dname		NVARCHAR(255)	NOT NULL,
	demail		VARCHAR(50)		NOT NULL,
	dtel		CHAR(10)		NOT NULL
	constraint chk_dtel check(len(dtel) = 10)
);
go
create table CHOOSE_PRODUCT
(
	username	VARCHAR(255)	NOT NULL,
	pid			VARCHAR(5)		NOT NULL,
	did			VARCHAR(5)		NOT NULL,
	amount		INT				DEFAULT 0,
	primary key (username, pid, did),
	constraint chk_amount check (amount >= 0),
	constraint fk_choose_user foreign key (username) references CUSTOMER(username) ON DELETE CASCADE,
	constraint fk_choose_product foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE,
	constraint fk_choose_distributor foreign key (did) references DISTRIBUTOR(did) ON DELETE CASCADE
);
go
create table INCLUDE_ORDER
(
	oid			VARCHAR(5)		NOT NULL,
	pid			VARCHAR(5)		NOT NULL,
	did			VARCHAR(5)		NOT NULL,
	amount		INT				DEFAULT 0,
	price		MONEY			DEFAULT 0,
	primary key (oid, pid, did),
	constraint chk_amount_include_order check (amount >= 0),
	constraint chk_price_include_order check (price >= 0),
	constraint fk_include_order_oid foreign key (oid) references ORD(oid) ON DELETE CASCADE,
	constraint fk_include_order_pid foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE,
	constraint fk_include_order_did foreign key (did) references DISTRIBUTOR(did) ON DELETE CASCADE
);
go
create table BELONG
(
	pid			VARCHAR(5)		NOT NULL,
	did			VARCHAR(5)		NOT NULL,
	promotion	DECIMAL(2)			,
	price		MONEY			DEFAULT 0,
	primary key (pid, did),
	constraint chk_price_belong check (price >=0),
	constraint chk_promotion check (promotion >= 0 and promotion <= 100),
	constraint fk_belong_pid foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE,
	constraint fk_belong_did foreign key (did) references DISTRIBUTOR(did) ON DELETE CASCADE
);
go
create table SHIPPER
(
	spid			VARCHAR(5)		primary key,
	spname			NVARCHAR(255)	NOT NULL,
	sptel			CHAR(10)		NOT NULL,
	sparea			NVARCHAR(255)	NOT NULL,
	spaddr			NVARCHAR(255)	NOT NULL,
	spemail			VARCHAR(50)		NOT NULL,
	price_dis		MONEY			NOT NULL	DEFAULT 0,
	price_area		NVARCHAR(255)	NOT NULL,
	confirm			INT				NOT NULL,
	constraint chk_sptel check (len(sptel) = 10),
	constraint chk_price_dis check (price_dis >= 0)		
);
go
create table PACKAGE
(
	pkid		VARCHAR(5)		primary key,
	oid			VARCHAR(5)		NOT NULL,
	spid		VARCHAR(5)		NOT NULL,
	ptotal_product	MONEY		,
	pprice_shipper	MONEY		,
	pprice_total	MONEY		,
	constraint fk_package_oid foreign key (oid) references ORD(oid) ON DELETE CASCADE,
	constraint fk_package_did foreign key (spid) references SHIPPER(spid) ON DELETE CASCADE
);
go
create table INCLUDE_PACKAGE
(
	pid				VARCHAR(5)		NOT NULL,
	pkid			VARCHAR(5)		NOT NULL,
	primary key (pid, pkid),
	constraint fk_include_package_pid foreign key (pid) references PRODUCT(pid) ON DELETE CASCADE,
	constraint fk_include_pkid foreign key (pkid) references PACKAGE(pkid) ON DELETE CASCADE
);
go
create index idx_users on USERS(sex, bdate)
go
create index idx_product on PRODUCT (pname, pmanufac, porigin, pamount, prate, pcost)
go
create index idx_comment on COMMENT (pid, cid)
go
create index idx_shipper on SHIPPER(spname, price_dis, price_area, confirm)
go
set dateformat DMY
insert into USERS
values
('user1', 'Pham', 'Nguyen Xuan', 'Nguyen', 'M', '28-08-1999', 'Nha Trang', 'user1@gmail.com', '0777525661', 'KD','12345',  'user1.png'),
('user2', 'Ho', 'Minh', 'Hoang', 'M', '01-06-1999', 'Phu Yen', 'user2@gmail.com', '0913590812', 'KD','abcd',  'user2.png'),
('user3', 'Tran', 'Thi', 'Tham', 'F', '26-09-1999', 'Dak Nong', 'user3@gmail.com', '0345193848', 'KD','abc123',  'user3.png'),
('user4', 'Nguyen', 'Ngoc Thu', 'Phuong', 'F', '19-08-1999', 'Quang Ngai', 'user4@gmail.com', '0377193960', 'KH','fb123',  'user4.png'),
('user5', 'Hy Pham', 'Ngoc', 'Linh', 'F', '28-10-1999', 'Lam Đong', 'user5@gmail.com', '0339175882', 'KH','gm123',  'user5.png'),
('user6', 'Nguyen', 'Viet', 'Long', 'M', '17-02-1999', 'Lam Đong', 'user6@gmail.com', '0946265079', 'KH','123a',  'user6.png'),
('user7', 'Tran', 'Chuong', 'Trinh', 'M', '05-06-1999', 'Lam Đong', 'user7@gmail.com', '0343982304', 'KH','987654321',  'user7.png'),
('user8', 'Phan Thi', 'Tuong', 'Vy', 'F', '21-01-1999', 'Binh Đinh', 'user8@gmail.com', '0362649042', 'KH','oke',  'user8.png'),
('user9', 'Phan', 'Ho', 'Phuc', 'M', '08-08-1999', 'Phu Yen', 'user9@gmail.com', '0962375948', '1',  'KD','user9.png'),
('user10', 'Dang Nguyen', 'Minh', 'Thu', 'F', '07-12-1999', 'Vung Tau', 'user10@gmail.com', '0395932226', 'KD','1999',  'user10.png')
go
insert into PRODUCT
values
('SP001', 'Backpack', 'Beautiful color is suitable for students.', 'Converse',10, 99000, 4.5, 'Vietnam'),
('SP002', 'Sony Headphone', 'Earpads are soft, smooth. EXTRA BASS for special sound', 'Sony', 100, 499000, 4.2, 'China'),
('SP003', 'Iphone 11', 'Screen Technology: IPS LCD. Pixels: 828 x 1792 pixels. Wide: 6.1 inches. Rear camera: 12 MP + 12 MP ', 'Apple', 10, 64990000, 4.1, 'Singapore'),
('SP004', 'Xiaomi Bluetooth Speaker', 'Capacity: 3W. Sensitivity: 80dB. Frequency: 120Hz - 20kHz', 'Xiaomi', 10, 890000, 4, 'China'),
('SP005', 'Logitech Keyboard', 'Dimension 445 x 145 x 13mm. Plastic material ABS is waterproof effectively', 'Logitech', 1000, 2350000, 4.7, 'China'),
('SP006', 'Socket', 'High quality, fireproof material shell. Supply: 2 port 5V/2.4A, 2 port 5V/1A', 'OEM', 500, 45000 ,3.8, 'Malaysia'),
('SP007', 'Xiaomi Face Wash', 'Charging time: 3 - 4 hours. Amperage: 300mA', 'Xiaomi',  200, 495000 ,4.3, 'China'),
('SP008', 'Thien Long ballpoint pen', 'Diameter ballpoint pen: 0,5mm', 'Thien Long', 10000, 3000 ,4.7,'Vietnam'),
('SP009', 'Casio Watch', 'Waterproof. Youthful, dynamic style', 'Casio', 1000, 95000 ,5, 'Japan'),
('SP010', 'Colgate Brush', 'Soft bristle brush', 'Colgate', 1000, 35000 ,4.6, 'The USA')
go
insert into CUSTOMER
values
('user4'),
('user5'),
('user6'),
('user8'),
('user7')
go
insert into TRANS_HIS
values
('GD31', 'user4'),
('GD14', 'user8'),
('GD32', 'user6'),
('GD53', 'user4'),
('GD41', 'user7')
go
insert into PAYMENT
values
('VISA', 'Visa card'),
('ATM', 'ATM card'),
('TT', 'Cash')
go
insert into ORD
values
('DH01', 'Transporting', '0969782430', 'Hanoi City', 3000, 103000, 'ATM','01-12-2019', 'user4', 'GD31'),	
('DH02', 'Packing', '0961509809', 'Toan quoc',  15000, 739000, 'TT', '20-07-2014','user8', 'GD14'),	
('DH03', 'Done', '0837006360', 'Nha Trang', 3000, 98000, 'ATM', '31-12-2017','user6', 'GD32'),	
('DH04', 'Loading goods', '0931637301', 'Vung Tau', 19000, 220000, 'VISA', '20-07-2014','user4', 'GD53'),	
('DH05', 'Done', '0963963129', 'Ben Tre', 3100, 107100, 'TT', '28-08-2018','user7', 'GD41')
go
insert into USERCENSOR
values
('user2', 'user1'),
('user3', 'user1'),
('user10', 'user9'),
('user1', 'user9'),
('user9', null)
go
insert into COMMENT
values
('1', 'SP001', '"Awesome"', '02-12-2019', 4, '09:10:00', 'user3', 'user4'),			
('2', 'SP003', '"Terrible!"', '26-07-2014', 1, '09:20:00', 'user10', 'user7'),			
('3', 'SP008', '"Fixed price"', '01-01-2018', 5, '09:30:00', 'user1', 'user8'),			
('4', 'SP004', '"Worth paying"', '26-07-2014', 4, '10:10:00', 'user2', 'user5'),			
('5', 'SP004', '"Bad quality!"', '26-07-2019', 2, '04:10:00', 'user1', 'user4')
go
insert into IMG_COMMENT
values
('sp1.png', 'I0001','2', 'SP003'),	
('sp4.jpg', 'I0002','4', 'SP004'),	
('sp2.png', 'I0003','5', 'SP004')
go
insert into IMG_LINK
values
('SP001', 'tinyurl.com/backpack'),			
('SP002', 'tinyurl.com/headphone'),			
('SP003', 'tinyurl.com/iphone'),			
('SP004', 'tinyurl.com/speaker'),			
('SP005', 'tinyurl.com/keyboard'),			
('SP006', 'tinyurl.com/socket'),			
('SP007', 'tinyurl.com/facewash'),			
('SP008', 'tinyurl.com/ballpointpen'),			
('SP009', 'tinyurl.com/watch'),			
('SP010', 'tinyurl.com/brush')
go
insert into DISTRIBUTOR
values
('PP_01', '268 Ly Thuong Kiet Street, 10 District, Ho Chi Minh City', 'Mall','phanphoimall@gmail.com','0111111111'),	
('PP_02', 'Linh Trung Ward, Thu Duc District, HCM City', 'Auth100','phanphoiauth@gmail.com','0111222333'),	
('PP_03', '31, Provincial Highway 8, My Xuyen District, My Xuyen, Soc Trang Province', 'Karaoke','karaoke@gmail.com','0222333444'),	
('PP_04', '191 Ba Trieu Street, Hai Ba Trung District, Ha Noi City, Vietnam', 'Vincom','vincomBaTrieu@gmail.com','6700000000'),	
('PP_05', '224 30/4 Street, Xuan Khanh Ward, Can Tho City', 'IRIS','irishotel@gmail.com','6600000000')
go
insert into CHOOSE_PRODUCT
values 
('user4', 'SP002', 'PP_01', 10),		
('user8', 'SP002', 'PP_01', 20),		
('user7', 'SP001', 'PP_05', 10),		
('user5', 'SP009', 'PP_02', 5),		
('user4', 'SP008', 'PP_03', 6),		
('user5', 'SP008', 'PP_01', 15)
go
insert into INCLUDE_ORDER
values
('DH01', 'SP002', 'PP_01','5','660000'),	
('DH02', 'SP005', 'PP_04','5','623000'),	
('DH03', 'SP008', 'PP_03','10','2160'),	
('DH04', 'SP008', 'PP_01','50','1960')
go
insert into BELONG
values
('SP001', 'PP_05', 30, 320000),
('SP002', 'PP_01', 26, 750000),
('SP003', 'PP_02', 29, 27000000),
('SP004', 'PP_05', 6, 600000),
('SP005', 'PP_04', 5, 700000),
('SP006', 'PP_02', 61, 80000),
('SP007', 'PP_01', 12, 250000),
('SP008', 'PP_03', 8, 2400),
('SP009', 'PP_02', 33, 540000),
('SP010', 'PP_01', 9, 18000)
go
insert into SHIPPER
values 
('VC_01', 'Giao hang nhanh', '0111333555', 'Nationwide', '231 Ba Dinh Street, Ha Noi City', 'ghn@gmail.com', 3000, 'North', 1),
('VC_02', 'Giao hang nhanh', '0111333555', 'Nationwide', '231 Ba Dinh Street, Ha Noi City', 'ghn@gmail.com', 5000, 'Central', 1),
('VC_03', 'Giao hang nhanh', '0111333555', 'Nationwide', '231 Ba Dinh Street, Ha Noi City', 'ghn@gmail.com', 7000, 'South', 1),
('VC_04', 'LALAMOVE', '0111222444', 'Ha Noi', '12 Cau Giay Street, Ha Noi Street', 'lalamove@gmail.com', 2500, 'North', 1),
('VC_05', 'Giao hang tiet kiem', '0333555777', 'Nationwide', '269 Ly Thuong Kiet Street, 10 District, HCM City', 'ghtk@gmail.com', 7300, 'North', 1),
('VC_06', 'Giao hang tiet kiem', '0333555777', 'Nationwide', '269 Ly Thuong Kiet Street, 10 District, HCM City', 'ghtk@gmail.com', 5100, 'Central', 1),
('VC_07', 'Giao hang tiet kiem', '0333555777', 'Nationwide', '269 Ly Thuong Kiet Street, 10 District, HCM City', 'ghtk@gmail.com', 3100, 'South', 1),
('VC_08', 'Giao hang sieu toc', '0444666888', 'Ho Chi Minh City', '34 Hoang Van Thu Street, Tan Binh District, HCM City', 'ghst@gmail.com', 19000, 'South', 1)
go
insert into PACKAGE
values 
('KH001', 'DH01', 'VC_04', 100000, 3000, 103000),		
('KH002', 'DH02', 'VC_02', 214000, 5000, 219000),		
('KH003', 'DH02', 'VC_02', 145000, 5000, 150000),		
('KH004', 'DH02', 'VC_02', 365000, 5000, 370000),		
('KH005', 'DH03', 'VC_01', 95000, 3000, 98000),
('KH006', 'DH04', 'VC_08', 201000, 19000, 220000),
('KH007', 'DH05', 'VC_07', 104000, 3100, 107100)
go
insert into INCLUDE_PACKAGE
values 
('SP002', 'KH001'),		
('SP005', 'KH002'),		
('SP005', 'KH003'),		
('SP005', 'KH004')

--Phần cá nhân -- Phạm Nguyễn Xuân Nguyên -- 1712393 -- table PACKAGE
--INSERT 
go
create procedure insert_shipper
	@spid			VARCHAR(5),
	@spname			NVARCHAR(255),
	@sptel			CHAR(10),
	@sparea			NVARCHAR(255),
	@spaddr			NVARCHAR(255),
	@spemail		VARCHAR(50),
	@price_dis		MONEY,
	@price_area		NVARCHAR(255),
	@confirm		INT
as
begin
	set nocount on
	if @spid not like 'VC_%'
	begin
		raiserror (N'Shipper ID must begin with VC_', 0, 1)
	end
	else if len(@sptel) > 10
	begin
		raiserror (N'Please input correct telephone', 1, 1)
	end
	else if @confirm = 0
	begin
		raiserror (N'Please enroll business license ', 1, 1)
	end
	else
	insert into SHIPPER values (@spid, @spname, @sptel, @sparea, @spaddr, @spemail, @price_dis, @price_area, @confirm)
end

exec insert_shipper 
	@spid = 'VC_09', 
	@spname = 'LALAMOVE', 
	@sptel ='0777525661', 
	@sparea = 'Nationwide', 
	@spaddr = 'HCM City', 
	@spemail = 'lalamove@gmail.com', 
	@price_dis = 2000, 
	@price_area = 'MB',
	@confirm = 0
--TRIGGER
create trigger check_confirm_shipper
on SHIPPER
instead of delete
as
begin
	declare @spid CHAR(5)
	select @spid = spid from deleted
	declare @confirm int
	select @confirm = confirm from deleted
	if @confirm = 0
		delete from SHIPPER where @spid = spid
	else
	begin
		raiserror(N'You should consider when deleting shipper unit!', 0 ,1)
	end
end
go
delete from SHIPPER where spid = 'VC_01'


create trigger check_belong_shipper
on SHIPPER
after update, insert
as
begin
	declare @price_dis	MONEY
	declare @price_area	NVARCHAR(255)
	declare @spid		VARCHAR(5)
	select @price_dis = price_dis from inserted
	select @price_area = price_area from inserted
	select @spid = spid from inserted
	---------------------
	update PACKAGE
	set pprice_shipper = @price_dis where spid = @spid
	update PACKAGE
	set pprice_total = ptotal_product + pprice_shipper
end

update SHIPPER
set price_dis = 5000 where spid = 'VC_08'
select spid, price_dis from SHIPPER where spid = 'VC_08'
select pkid, spid, pprice_shipper, pprice_total from PACKAGE where spid = 'VC_08'

--SELECT
create procedure select_price_package
	@pkid VARCHAR(5)
as
begin
	select PK.spid, SP.spname
	from PACKAGE PK , SHIPPER SP
	where PK.spid = SP.spid and PK.pkid = @pkid
	ORDER BY PK.spid DESC
end

exec select_price_package 'KH002'

create procedure select_price_package_amount
	@oid VARCHAR(5)
as
begin
	select PK.oid, count(PK.oid) as sokienhang
	from PACKAGE PK, SHIPPER P
	where PK.spid = P.spid and PK.oid = @oid
	GROUP BY PK.oid
	HAVING count(PK.oid) > 1
	ORDER BY PK.oid DESC
end

exec select_price_package_amount 'DH02'
--FUNCTION
create function getAverageShipper(@spname NVARCHAR(255))
returns @average table
(
	Name	NVARCHAR(255),
	AVR		float	
)
as
begin
	if @spname is not NULL 
		begin
			if exists (select spname from SHIPPER where spname = @spname)
				begin
					insert into @average
						select spname, AVG(price_dis) from SHIPPER where spname = @spname group by spname
				end
		end
	return
end
go
select * from  getAverageShipper('Giao hang nhanh')

create function getCheapShipper(@sparea NVARCHAR(255))
returns @cheap table
(
	Name	NVARCHAR(255),
	Area	NVARCHAR(255),
	Price	MONEY
)
as
begin
	if @sparea is not NULL 
		begin
			if exists (select sparea from SHIPPER where price_area = @sparea)
				begin
					declare @cheapest MONEY
					select top 1 @cheapest = price_dis from SHIPPER where price_area = @sparea
					declare @name NVARCHAR(255)
					declare check_cheap cursor for select spname, price_dis from SHIPPER where price_area = @sparea
					open check_cheap
					declare @getCheap MONEY
					declare @getName CHAR(255)
					fetch next from check_cheap into @getName, @getCheap
					while @@FETCH_STATUS = 0
					begin
						if @getCheap < @cheapest
							select @cheapest = @getCheap
							select @name = @getName
						fetch next from check_cheap into @getName, @getCheap
					end
					insert into @cheap values (@name, @sparea ,@cheapest)
				end
		end
	return
end
go
select * from getCheapShipper('South')

--Phần cá nhân của Lê Anh Duy
--Đầu tiên viết procedure để thêm dữ liệu vào bảng PRODUCT có validate và ném lỗi có ý nghĩa.
create procedure insertProducts
@pid		VARCHAR(5),
@pname		NVARCHAR(255),	
@pdesc		NTEXT,						
@pmanufac	NVARCHAR(50),	
@pamount	INT,		
@ppromo		DECIMAL(2),
@pcost		MONEY,					
@porigin	NVARCHAR(50),
@distributor NVARCHAR(255)

as
begin	
	set nocount on
	if @pid not like 'SP%'
	begin
		raiserror (N'Mã sản phẩm phải bắt đầu bằng kí hiệu SP', 0, 1)
	end
	else if (select datalength(@pdesc) / 2 as textField) >= 100
	begin
		raiserror (N'Số lượng kí tự trong mô tả cần nhỏ hơn 100 (kí tự)' , 1, 1)
	end
	else if exists( select * from PRODUCT where pid = @pid )
	begin
		raiserror (N'Sản phẩm đã tồn tại trong danh mục sản phẩm', 1, 1)
	end
	else if @ppromo > 100 or @ppromo < 0
	begin
		raiserror (N'Khuyến mãi phải có giá trị không hợp lệ', 1, 1)
	end
	else
	begin
		declare @id VARCHAR(5)
		select @id = did from DISTRIBUTOR 
		where @distributor = dname

		insert into PRODUCT(pid, pname, pdesc, pmanufac, pamount, pcost, porigin)
		values
		(
		@pid, 
		@pname, 
		@pdesc, 
		@pmanufac, 
		@pamount, 
		@pcost, 
		@porigin
		)
		update 	BELONG
		set did = @id, promotion = @ppromo, price = (@ppromo*0.01 + 1) * @pcost 
		where pid = @pid
	end 
end

drop procedure insertProducts
exec insertProducts 'SP014', N'Giay', N'Hoai co', 'Thuong Dinh', 10000, 3, 110000, N'Vietnam', 'Karaoke'
delete from PRODUCT WHERE pid = 'SP014'

----Trigger----

create trigger insertTrigger
on PRODUCT
after insert, update
as
	begin
		set nocount on
		declare @proid VARCHAR(5), @cost MONEY, @promo DECIMAL(2)
		select @proid = pid, @cost = pcost from inserted
		if exists(select * from BELONG where pid = @proid)
		begin
			select @promo = promotion from BELONG where pid = @proid
			update BELONG
			set price =  (@promo*0.01 + 1) * @cost 
			from BELONG
			join inserted on BELONG.pid = @proid
		end
		else
		begin
			insert into BELONG 
			values 
			(
			@proid, 
			'PP_01',
			null,
			null
			) 
		end
	end

update PRODUCT
set pcost = 300000 where pid = 'SP001'
select * from PRODUCT where pid = 'SP001'
select * from BELONG where pid = 'SP001'
drop trigger insertTrigger

create trigger deleteTrigger
on PRODUCT
instead of delete
as
	begin
		set nocount on
		declare @did VARCHAR(5), @pid VARCHAR(5), @amount INT, @rate decimal(2,1)
		select @pid = pid, @amount = pamount , @rate = prate from deleted
		select @did = did from BELONG where @pid  = pid
		declare @total int
		select @total = count(*) from (
		select * from BELONG where @did = did ) as a

		if(@total < 5 or @amount = 0)
			begin
				delete from PRODUCT where pid = @pid
				delete from BELONG where  pid = @pid
			end
		else
			begin
			raiserror (N'You should not delete this product', 16, 1)
			end
	end
delete from PRODUCT where pid = 'SP001'
select *from PRODUCT where pid = 'SP001'
drop trigger deleteTrigger

----viết procedure----
create procedure searchProductProc 
--Đây là proc giúp người dùng tìm tất cả record sản phẩm mà chứa thông tin người dùng nhập vào trong thanh search
@textEnter NVARCHAR(255)
as
begin
	set nocount on
	declare @resultTable table (pname NVARCHAR(255), pdesc NTEXT, pmanufac NVARCHAR(50), porigin NVARCHAR(50), 
						pamount INT, pcost MONEY, prate DECIMAL(2,1), price MONEY, dname NVARCHAR(255))
	
	insert into @resultTable
	select pname, pdesc, pmanufac, porigin, pamount, pcost, prate, price, dname
	from BELONG as bl join DISTRIBUTOR as dis on bl.did = dis.did join PRODUCT as pro on pro.pid = bl.pid
	where pname like '%' + @textEnter + '%' or 
		  pdesc like '%' + @textEnter + '%' or 
		  pmanufac like '%' + @textEnter + '%' or 
		  porigin like '%' + @textEnter + '%' or 
		  dname like '%' + @textEnter + '%'
	order by pro.pid

	declare @number int

	select @number = count(*)
	from @resultTable

	if @number = 0
		begin
			print(N'Không tìm thấy sản phẩm')
		end  	
	else
		begin
			select * from @resultTable
		end
end

drop procedure searchProductProc

exec searchProductProc N'Watch'

create procedure filterProductPro
    @orgin NVARCHAR(50),
	@manifac NVARCHAR(50),
	@distri_name NVARCHAR(255),
	@startamount int,
	@endamount int,
	@startrating DECIMAL(2,1),
	@endrating DECIMAL(2,1),
	@price MONEY,
	@order char(1)
as        
    begin        
        set nocount on

        declare @SQL NVARCHAR(MAX)        

        set @SQL = N'select pro.pname, pro.pdesc, pro.pmanufac, pro.porigin, pro.pamount, pro.pcost, pro.prate, bl.price, dis.dname 
					 from BELONG as bl join DISTRIBUTOR as dis on bl.did = dis.did join PRODUCT as pro on pro.pid = bl.pid 
					where pro.pid like ''SP%'''

        if len(@orgin) > 0 
            begin        
                set @SQL = @SQL + N' AND pro.porigin = @orgin'    
            end 
			       
		if len(@manifac) > 0
            begin        
                set @SQL = @SQL + N' AND pro.pmanufac = @manifac'    
            end        

		if len(@distri_name) > 0
            begin        
                set @SQL = @SQL + N' AND dis.dname = @distri_name'    
            end 

		if @startamount IS NOT NULL and @endamount IS NOT NULL
			begin
				set @SQL = @SQL + N' and pro.pamount between @startamount and @endamount'
			end

		if @startrating IS NOT NULL and @endrating IS NOT NULL     
			begin
				set @SQL = @SQL + N' and pro.prate between @startrating and @endrating'   
			end

		if @order IS NOT NULL        
            begin   
				if @order = 1
					begin     
						set @SQL = @SQL + N' ORDER BY pro.pamount asc'    
					end
				else
					begin
						set @SQL = @SQL + N' ORDER BY pro.pamount desc'    
					end
            end 
		
		if @price IS NOT NULL        
            begin        
                set @SQL = N' select dis.dname, avg(bl.price) as avgprice 
					from BELONG as bl join DISTRIBUTOR as dis on bl.did = dis.did join PRODUCT as pro on pro.pid = bl.pid 
				    GROUP BY dis.dname having avg(bl.price) > @price'    
            end 

		exec sp_executesql @SQL,        
				N' 
				@orgin NVARCHAR(50),
				@manifac NVARCHAR(50),
				@distri_name NVARCHAR(255),
				@startamount int,
				@endamount int,
				@startrating DECIMAL(2,1),
				@endrating DECIMAL(2,1),
				@price MONEY,
				@order char(1)'
				,@orgin = @orgin
				,@manifac = @manifac
				,@distri_name = @distri_name
				,@startamount = @startamount
				,@endamount = @endamount
				,@startrating = @startrating
				,@endrating = @endrating
				,@price = @price 
				,@order = @order
					
	end

drop procedure filterProductPro
exec filterProductPro N'China',null,null,null,null,null,null,null,null

----Viết function----
--Tính tổng số lượng sản phẩm của những sản phẩm có cùng nhà sản xuất và sắp xếp theo thứ tự giảm dần
create function getTotalAmount(@manufac_name NVARCHAR(50))
returns @total table (name NVARCHAR(50) DEFAULT N'Không tìm thấy', totalProduct int DEFAULT 0)
as
begin
	if(len(@manufac_name) > 0)
		begin
			if exists(select pmanufac from PRODUCT where @manufac_name = pmanufac)
				begin
					declare @totalProducts int, @product_amounts int
					set @totalProducts = 0
					declare traverseCursor cursor for
					select pamount from PRODUCT where @manufac_name = pmanufac

					open traverseCursor

					fetch next from traverseCursor into @product_amounts

					while @@FETCH_STATUS = 0
					begin
						set @totalProducts = @totalProducts + @product_amounts
						fetch next from traverseCursor into @product_amounts
					end
					insert into @total values (@manufac_name, @totalProducts)
				end
			else
				begin
					insert into @total values (DEFAULT, DEFAULT)
				end
		end
	else
		begin
			insert into @total
			select tempTable.pmanufac, tempTable.totalproducts
			from (
				select pmanufac, sum(pamount) as totalproducts 
				from PRODUCT
				group by pmanufac
			) as tempTable
		end
		return;
end

drop function getTotalAmount
--Dùng Select để gọi Hàm
select * from getTotalAmount('Xiaomi')
select * from getTotalAmount('')
select * from getTotalAmount('Adidas')

---Hàm để hiển thị rating trung bình đối với các sản phẩm của cùng hãng sản xuất trên website
create function getAvgRating(@manufac_name NVARCHAR(50))
returns @avgRate table (name NVARCHAR(50) DEFAULT N'Không tìm thấy', avgRate DECIMAL(2,1) DEFAULT 0.0) 
as
begin
	if(len(@manufac_name) > 0)
		begin
			if exists(select pmanufac from PRODUCT where @manufac_name = pmanufac)
				begin
					declare @avgRates DECIMAL(2,1), @rateProduct DECIMAL(2,1)
					set @avgRates = 0.0
					declare traverseCursor cursor for
					select prate from PRODUCT where @manufac_name = pmanufac

					open traverseCursor

					fetch next from traverseCursor into @rateProduct
					declare @count int 
					set @count = 0
					while @@FETCH_STATUS = 0
					begin
						set @avgRates = @avgRates + @rateProduct
						set @count = @count + 1
						fetch next from traverseCursor into @rateProduct
					end
					set @avgRates = @avgRates / @count
					insert into @avgRate values (@manufac_name, @avgRates)
				end
			else
				begin
					insert into @avgRate values (DEFAULT, DEFAULT)
				end
		end
	else
		begin
			insert into @avgRate
			select tempTable.pmanufac, tempTable.averageRating
			from (
				select pmanufac, avg(prate) as averageRating 
				from PRODUCT
				group by pmanufac
			) as tempTable
		end
	return;
end

drop function getAvgRating
--Dùng select để gọi Hàm
select * from getAvgRating('Xiaomi')
select * from getAvgRating('')
select * from getAvgRating('Adidas')

--Phần cá nhân của Nguyễn Ngọc Thu Phương
set dateformat DMY
go
---INSERT-----
CREATE  PROCEDURE addComment
(
@cmt_id VARCHAR(5),
@product_id VARCHAR(5),
@cmt NTEXT,
@cmt_date DATE,
@cmt_rate TINYINT		,
@cmt_time TIME(0)		,
@rating_user	VARCHAR(255)  	
)
AS
BEGIN
	if exists(select * from COMMENT where cuser = @rating_user and pid = @product_id)
		raiserror('One user can rate at most once on one product!',16,1)
	else
	begin
		if @cmt like '%[@#$%^&*]%'
		raiserror('Comment cannot contain special characters: @#$%^&* ',16,1)
		else
		begin
		insert into  COMMENT
		values(@cmt_id,@product_id,@cmt,@cmt_date,@cmt_rate,@cmt_time,null,@rating_user)
		end
	end
	
END;

go
exec addComment '6','SP004','"Bad quality!"', '26-07-2019', 2, '04:10:00', 'user4'
------trigger before insert-------
CREATE TRIGGER trig_for_insert
on COMMENT
after INSERT, update
as 
begin
	declare @product_id VARCHAR(5)
	select @product_id = pid from inserted 
	declare @rate_count int
	set @rate_count = (select count (pid) from COMMENT where pid = @product_id )
	declare @sum_rate float
	set @sum_rate = (select sum(crate) from COMMENT where pid = @product_id )
	declare @new_rate decimal(2,1)
	set @new_rate = (select cast(@sum_rate / @rate_count as decimal(2,1)))
	update PRODUCT set prate = @new_rate where pid =@product_id
END;
go
------trigger before on delete-------
CREATE TRIGGER trig_for_delete
on COMMENT
after delete
as 
begin
	declare @comment_id VARCHAR(5)
	select @comment_id = cid from deleted
	declare @product_id VARCHAR(5)
	select @product_id = pid from deleted
	-------------
	if not exists(select * from COMMENT where  pid = @product_id)
		update PRODUCT set prate = null where pid =@product_id
	else
		begin
			declare @rate_count int
			set @rate_count = (select count (pid) from COMMENT where pid = @product_id )
			declare @sum_rate float
			set @sum_rate = (select sum(crate) from COMMENT where pid = @product_id )
			declare @new_rate decimal(2,1)
			set @new_rate = (select cast(@sum_rate / @rate_count as decimal(2,1)))
			update PRODUCT set prate = @new_rate where pid =@product_id
		end
END;
go
delete from COMMENT where cid = 2
--------procedure -----------------------
--------ok from this moment, all cmt(s) must include pic(s). I'm totally tired :)--------------
CREATE procedure showAllCmtWithPic
--#this procedure return a table of comments#-------
(
@product_id VARCHAR(5)
)
AS
BEGIN
select COMMENT.cuser as UserName, COMMENT.cdate as DateOfRating, COMMENT.comm as Comment, IMG_COMMENT.img as CommentImage
from (IMG_COMMENT right join COMMENT on IMG_COMMENT.cid = COMMENT.cid)
where @product_id = COMMENT.pid
order by COMMENT.cdate desc
END;
go
exec showAllCmtWithPic'SP004'
------------
create procedure ratingOfAnProduct
(@pro_id VARCHAR(5))
--#this procedure return number of rating group by sex of an product #-------
as
begin
select Count(crate) as NumOfRating ,USERS.sex as Sex
from (COMMENT left join USERS on COMMENT.cuser = USERS.username)
where COMMENT.pid  = @pro_id
group by USERS.sex
having min(crate) > 0
order by NumOfRating desc
end;
go

exec ratingOfAnProduct 'SP004'
------function caculate number of pics on cmts of a product----------
CREATE FUNCTION calNumOfPic
(
@product_id VARCHAR(5)
)
returns int
AS
BEGIN
	if not exists(select  cid from COMMENT where pid = @product_id) return 0
	declare @cmt_id VARCHAR(5)
---select @cmt_id = cid from COMMENT where pid = @product_id
	declare @sum int = 0
	declare @cmt_cursor as cursor
	set @cmt_cursor = cursor for select  cid from COMMENT where pid = @product_id
	open @cmt_cursor
	fetch next from @cmt_cursor into @cmt_id
	while @@FETCH_STATUS = 0
	begin 
		if not exists(select  img from IMG_COMMENT where cid = @cmt_id) 
			fetch next from @cmt_cursor into @cmt_id
		else
			begin
				set @sum = @sum + (select  count(cid) from IMG_COMMENT where cid = @cmt_id)
				fetch next from @cmt_cursor into @cmt_id
			end
	end
return @sum
END;
go 
select dbo.calNumOfPic('SP004') 
------function caculate num of rating of a product--------- 
CREATE FUNCTION calNumOfRating
(
@product_id VARCHAR(5)
)
returns @table table
(
rating tinyint not null,
num int not null
)
AS
BEGIN
insert into @table values (1,0),(2,0),(3,0),(4,0),(5,0)
if not exists(select cid from COMMENT where pid = @product_id) return  
else
	begin
		declare @count tinyint = 1
		while @count < 6
			begin
				update @table set num = (select count(crate) from  COMMENT where pid = @product_id and  crate = @count) where rating = @count
				set @count  =  @count + 1
			end
		return
	end
return
END;
go
select* from calNumOfRating('SP001')
go
select dbo.calNumOfPic('SP004') 
go
--Phần cá nhân của Võ Thanh Phong
create procedure insertUsers
	@username	VARCHAR(255)	,
	@lname		NVARCHAR(255)	,
	@minit		NVARCHAR(255)	,
	@fname		NVARCHAR(255)	,
	@sex		CHAR(1)		,
	@bdate		NVARCHAR(50),			
	@addr		NVARCHAR(255),
	@email		VARCHAR(255),
	@tel			CHAR(10),
	@typeUser	CHAR(2)		,
	@passw		VARCHAR(50)	,
	@avatar		VARCHAR(255)
as
begin
	set nocount on
	if @typeUser <> 'KH' and @typeUser <> 'KD'
		begin
			print(@typeUser)
			raiserror (N'Nhập đúng loại người dùng' , 1, 1)
		end
	else if exists(select * from USERS where @username  = username)
	begin
		raiserror (N'Tên người dùng đã được sử dụng' , 1, 1)
	end
	else if len(@tel) > 10
		begin
			raiserror (N'Nhập đúng định dạng của số điện thoại', 1, 1)
		end
	else if @email not like '%@%'
	begin
		raiserror (N'Vui lòng nhập lại email cho đúng dùm cái', 1, 1)
	end
	else
		set dateformat DMY
		insert into USERS
		values
		(
			@username,
			@lname,
			@minit,
			@fname,
			@sex,
			@bdate,
			@addr,
			@email,
			@tel,
			@typeUser,
			@passw,
			@avatar
		)
end

exec insertUsers 'user30', N'Pham', N'Nguyen Le', N'Phong', 'M', '28-08-2000', N'Tien Giang', 'user12@gmail.com', '0777525661','KH' ,'12345',  'user12.png'
drop procedure insertUsers
delete from USERS where username = 'user12'

create trigger insertTrigger_user
on USERS
after insert, update
as
begin
	declare @type char(2)
	declare @name VARCHAR(255)
	select @type = type_users, @name = username from inserted 
	
	if @type = 'KH'
		begin
		if not exists(select * from CUSTOMER where username = @name)
			begin
				insert into CUSTOMER
				values (@name)
			end
		end
	else
		begin
		if not exists(select * from USERCENSOR where username = @name)
			begin
				insert into USERCENSOR
				values (@name, NULL)
			end
		end
end
go
drop trigger insertTrigger
go
create trigger deleteTrigger_user
on USERS
instead of delete
as
	begin
		declare @type char(2)
		declare @name VARCHAR(255)
		select @type = type_users, @name = username from deleted 
	
		if @type = 'KH'
			begin
				delete from CUSTOMER where @name = username
			end
		else
			begin
				delete from USERCENSOR where @name = username
			end
		delete from USERS where @name  = username
	end
go
delete from USERS where username = 'user13'
drop trigger deleteTrigger
go
create procedure checkbygenderProc	 
@sex CHAR(1)
as
begin
	set nocount on
	declare @resultTable table (username VARCHAR(255), typeUser	CHAR(2), lname	NVARCHAR(255), minit NVARCHAR(255), fname NVARCHAR(255), sex	CHAR(1),
								bdate	DATE, addr	NVARCHAR(255),email	VARCHAR(255), tel CHAR(10))
	
	insert into @resultTable
	select usr.username, type_users, lname, minit, fname, sex, bdate, addr, email, tel 
	from USERS as usr join CUSTOMER as cus on usr.username = cus.username
	where usr.sex = @sex
	order by usr.lname desc
	
	declare @number int

	select @number = count(*)
	from @resultTable

	if @number = 0
		begin
			print(N'Không tìm thấy danh sách khách hàng thỏa mãn')
		end  	
	else
		begin
			select * from @resultTable
		end
end

drop procedure checkbygenderProc
exec checkbygenderProc 'M'

create procedure checkavgAgeProc
@startAge int,
@endAge int,
@option int
as
begin
set nocount on
	declare @number int
	if @option = 0
	begin
		declare @resultTable table (username VARCHAR(255), typeUser	CHAR(2), lname	NVARCHAR(255), minit NVARCHAR(255), fname NVARCHAR(255), sex	CHAR(1),
								bdate	DATE, addr	NVARCHAR(255),email	VARCHAR(255), tel CHAR(10))

		insert into @resultTable
		select usr.username, type_users, lname, minit, fname, sex, bdate, addr, email, tel 
		from USERS as usr join CUSTOMER as cus on usr.username = cus.username
		where year(getDate()) - year(usr.bdate) between @startAge and @endAge
		order by usr.lname desc
		select @number = count(*)
		from @resultTable 
		if @number > 0
		begin
			select * from @resultTable
		end
	end
	else
	begin
		declare @resultTable_1 table (sex CHAR(1), avgAge DECIMAL(3,1))
		insert into @resultTable_1
		select sex , avg(year(getDate()) - year(usr.bdate)) as avgAge
		from USERS as usr join CUSTOMER as cus on usr.username = cus.username
		group by usr.sex
		having avg(year(getDate()) - year(usr.bdate)) between @startAge and @endAge
		select @number = count(*)
		from @resultTable_1 
		if @number > 0
		begin
			select * from @resultTable_1
		end
	end	
	if @number = 0
		begin
			print(N'Không tìm thấy danh sách khách hàng thỏa mãn')
		end  	
end

drop procedure checkavgAgeProc	

exec checkavgAgeProc 30, 50, 1 --Thong ke độ tuổi trung bình trong giới hạn cho trc theo giới tính
exec checkavgAgeProc 20, 50, 0 -- hiển thị độ tuổi trung bình theo giới tính

create function getAvgAge
(@sex char(1))
returns int
as
begin
	declare @age int, @birthDate date
	declare @avgAge int
	set @age = 0
	set @avgAge = 0
	declare bdateCursor cursor for
	select bdate from USERS where sex = @sex

	open bdateCursor

	fetch next from bdateCursor into @birthDate
	declare @count int
	set @count = 0 
	while @@FETCH_STATUS = 0
	begin
	set @age = year(getDate()) - year(@birthDate)
	set @avgAge = @avgAge + @age
	set @count = @count + 1
	fetch next from bdateCursor into @birthDate
	end
	set @avgAge = @avgAge / @count

	return @avgAge
end

drop function getAvgAge

select dbo.getAvgAge('M') --Tính tuổi trung bình theo GT

create function checkPass
(@password VARCHAR(50))
RETURNS nvarchar(50)
as 
	begin
	declare @result nvarchar(50)
	if len(@password) between 0 and 6
		begin
		set @result = N'Mật khẩu yếu'
		end
	else if len(@password) between 7 and 10
		begin
		set @result = N'Mật khẩu vừa'
		end
	else
		begin
		set @result = N'Mật khẩu mạnh'
		end

	return @result
end
  
 drop function checkPass
 select dbo.checkPass('123456')

