declare @idProducto int
declare @producto varchar(100)
declare @cantidad int
declare @numero int

set @numero = 616
-- Inserto un rubro "Repuesto" que es general.
insert into tb_Rubros (Rubro) values ('Repuestos')
while(exists(select 1 from ProductosBasePañol$))
begin
	set @numero = @numero + 1
	
	select top 1
		@idProducto = idProducto,
		@producto = producto,
		@cantidad = Cantidad
	from
		ProductosBasePañol$
	
	delete
		ProductosBasePañol$
	where
		idProducto = @idProducto
	
	-- Cargo la tabla de productos.
	insert into tb_Productos (Producto, Descripcion, idRubro) values (@producto, '', 1)
	
	-- Cargo la existencia inicial.
	insert into tb_Movimientos (Fecha, idOperacionMovimiento, Numero, Observacion, idUsuario)
	values(SYSDATETIME(), 4, @numero, 'Carga Inicial de Stock.', 5)

	insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
	idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
	values (@cantidad, @numero, 2, 1, 4, @numero, 0, 1, 0, '', 0, 0)
	--
	insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
	idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
	values (@cantidad, @numero, 6, 5, 4, @numero, 1, 1, 0, '', 0, 0)
end

select * from tb_OperacionesMovimientos