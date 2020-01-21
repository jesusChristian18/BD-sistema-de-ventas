create database royal
go

use royal
go


-------personal------
create table personal(
	cod_personal varchar (15) not null primary key,
	nombre varchar(20) null,
	apellido varchar(20) null,
	correo varchar(30) null,
	edad int null,
	cargo varchar (20) null)
	go

------cliente--------
create table cliente(
	dni varchar(15) not null primary key,
	apellido varchar(20) null,
	nombre varchar(20) null,
	correo  varchar(30) null,
	edad int null,
	genero varchar(30) null)
	go
	drop table cliente
-------producto-------
create table producto(
	cod_producto varchar (15) not null primary key,
	nombre varchar (20) null,
	marca varchar (15) null,
	talla varchar (4) null,
	precioUnitario float null)
	go

-------proveedor-------
create table proveedor(
	cod_proveedor varchar (15) not null primary key,
	ruc varchar (15) null,
	apellido varchar (15) null,
	nombre varchar (15) null,
	correo varchar (30) null,
	telefono varchar (15) null)
	go

	drop table proveedor
-------documento--------
create table documento(
	cod_documento varchar (15) not null primary key,
	cod_personal varchar (15) foreign key references personal(cod_personal),
	cod_cliente varchar (15) foreign key references cliente(dni),
	cod_proveedor varchar (15) foreign key references proveedor(cod_proveedor),
	fecha varchar (15) null)
	go

	drop table documento

-------detalle-----
create table detalle(
	cod_detalle varchar (15) not null primary key,
	cod_producto varchar (15) foreign key references producto(cod_producto),
	cod_documento varchar (15) foreign key references documento(cod_documento),
	cantidad int null,
	total float null,
	destino varchar (15) null)
	go

	drop table detalle
---------catalogo-------
create table catalogo(
	cod_catalogo varchar (15) not null primary key,
	cod_proveedor varchar (15) foreign key references proveedor(cod_proveedor),
	cod_producto varchar (15) foreign key references producto(cod_producto),
	descripcion varchar (15) null,
	precioCompra float null)
	go

	drop table catalogo
-------------ingreso de datos de los clientes---------------
insert into cliente values ('5859648','zevallos','christian','chris.jesus@gmail.com',21,'masculino'),
						('6586926','sucno','daniel','dan.iel_12@hotmail.com',21,'masculino'),
						('78592658','talancha','jean Paul','jeanpaul_15_09@hotmail.com',21,'masculino'),
						('45826589','trujillo','jean pier','jeanpier_trujillo@gmail.com',20,'masculino')
						go

select *from cliente
------------ingreso de datos del personal-------------------
insert into personal values ('1001','roberto','trujillo','roberto_16@gmail.com',34,'administrador'),
							('1002','lopez','lady','lady_lopez@gmail.com',20,'cajera'),
							('1003','guevara','aracelly','aracelly_16@gmail.com',21,'vendedor'),
							('1004','sanchez','jose','jose.lopez15@gmail.com',20,'vendedor')
							go

select *from personal

------------ingreso de datos del producto--------------------
insert into producto values ('100','pantalon','rip curl','28',55.00),
							('101','polo','billabong','S',25.00),
							('102','polo','billabong','M',25.00),
							('103','polo','billabong','L',25.00),
							('104','polo','billabong','XL',30.00),
							('105','casaca','quiksilver','S',50.00),
							('106','casaca','quiksilver','M',50.00),
							('107','casaca','quiksilver','L',50.00),
							('108','polera','rip curl','S',45.00),
							('109','polera','rip curl','M',45.00),
							('110','polera','quiksilver','L',48.00),
							('111','casaca','quiksilver','XL',55.00)
							go

------------ingreso de datos del documento--------------------
insert into documento (cod_documento,
						cod_personal,
						cod_cliente,
						fecha) values ('10001','1002','5859648','04/07/2019'),
										('10002','1003','6586926','04/07/2019'),
										('10003','1004','78592658','05/07/2019'),
										('10004','1004','6586926','06/07/2019'),
										('10005','1002','5859648','07/07/2019'),
										('10006','1002','45826589','08/07/2019'),
										('10007','1003','6586926','04/07/2019'),
										('10008','1004','78592658','05/07/2019'),
										('10009','1004','6586926','06/07/2019'),
										('100010','1002','5859648','07/07/2019'),
										('100011','1002','45826589','08/07/2019')
go

-------------------listar todos los documentos de personal a cliente-----------------
select cod_documento, 
		cod_personal, 
		cod_cliente, 
		fecha from documento

------------------ingresar los datos de los detalles de cada venta------------------------
insert into detalle values ('10','100','10001',2,110.00,'venta'),
							('11','101','10002',3,75.00,'venta'),
							('12','102','10003',1,25.00,'venta'),
							('13','103','10004',2,50.00,'venta'),
							('14','103','10005',2,90.00,'venta'),
							('15','103','10006',4,100.00,'venta'),
							('16','104','10007',3,90.00,'venta'),
							('17','105','10008',3,150.00,'venta'),
							('18','106','10009',2,100.00,'venta'),
							('19','107','100010',1,50.00,'venta'),
							('20','108','100011',2,90.00,'venta')
							go
----------------listamos todos los detalles de las ventas-----------------------
select *from detalle


--------------------------agrupamos las tablas para listar los detalles de la venta-----------------------
select documento.fecha,
		documento.cod_documento,
		producto.nombre,
		producto.talla,
		producto.marca,
		producto.precioUnitario,
		detalle.cantidad,
		detalle.total,
		detalle.destino from detalle inner join producto on detalle.cod_producto = producto.cod_producto
									 inner join documento on detalle.cod_documento = documento.cod_documento
									 where destino = 'venta'
									 go

-------------------------le aumentamos el IGV al total de la venta------------------
select documento.fecha,
		documento.cod_documento,
		producto.nombre,
		producto.talla,
		producto.marca,
		producto.precioUnitario,
		detalle.cantidad,
		detalle.total as subTotal,
		detalle.total*0.18 as igv,
		(detalle.total*0.18) + detalle.total as total,
		detalle.destino from detalle inner join producto on detalle.cod_producto = producto.cod_producto
									 inner join documento on detalle.cod_documento = documento.cod_documento
									 where destino = 'venta'
									 go

---------------------------------sacar la suma del producto que se ah vendido en la temporada--------------------
select sum((detalle.total*0.18) + detalle.total) as totalVenta from detalle inner join producto on detalle.cod_producto = producto.cod_producto
									 inner join documento on detalle.cod_documento = documento.cod_documento
									 where nombre = 'polo' and talla = 'L' 
									 go
---------------------------------ordenar las fechas en la tabla combinada----------------
select documento.fecha,
		documento.cod_documento,
		producto.nombre,
		producto.talla,
		producto.marca,
		producto.precioUnitario,
		detalle.cantidad,
		detalle.total as subTotal,
		detalle.total*0.18 as igv,
		(detalle.total*0.18) + detalle.total as total,
		detalle.destino from detalle inner join producto on detalle.cod_producto = producto.cod_producto
									 inner join documento on detalle.cod_documento = documento.cod_documento
									 where destino = 'venta' order by fecha asc
go
-------------------------rango de fechas de las ventas--------------------------									
select documento.fecha,
		documento.cod_documento,
		producto.nombre,
		producto.talla,
		producto.marca,
		producto.precioUnitario,
		detalle.cantidad,
		detalle.total as subTotal,
		detalle.total*0.18 as igv,
		(detalle.total*0.18) + detalle.total as total,
		detalle.destino from detalle inner join producto on detalle.cod_producto = producto.cod_producto
									 inner join documento on detalle.cod_documento = documento.cod_documento
									 where destino = 'venta' and fecha between '04/07/2019' and '06/07/2019'
									 go


---------------------ingreso de los datos de los proveedores----------------
insert into proveedor values ('RP1','45896321','lagos','marco','marco18@gmail.com','992556749'),
							 ('RP2','58596589','peralta','maria','maria.12@gmail.com','998995632'),
							 ('RP3','68596589','mendoza','martha','martha.mendoza20@gmail.com','992664853'),
							 ('RP4','48596589','gutierrez','adai','adai.gutierrez@gmail.com','995889426')
							 go
							 select *from proveedor
--------------------ingreso de los productos de la compra hacia el proveedor------------------
insert into producto( cod_producto, 
			nombre, 
			marca,
			precioUnitario)  values ('AP10','pantalon','rip curl',35.00),
											('AP11','polo','billabong',20.00),
											('AP12','casaca','quiksilver',40.00),
											('AP13','polera','rip curl',40.00),
											('AP14','polera','quiksilver',30.00),
											('AP15','casaca','quiksilver',35.00)
											go

			select cod_producto, 
			nombre, 
			marca,
			precioUnitario from producto WHERE cod_producto between 'AP10' and 'AP15'
			go

insert into catalogo values ('A10','RP1','AP11','polo',20.00),
							('B11','RP3','AP15','casaca',35.00),
							('C12','RP4','AP13','polera',40.00),
							('D13','RP2','AP10','pantalon',35.00)

select *from catalogo