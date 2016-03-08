declare @idItem int
declare @producto varchar(100)
declare @cantidad int
declare @numero int
declare @idProducto int
declare @idMovimiento int

-- Seteo el numero con el valor actual. Es cero si hace después de borrar todos los movimientos.
select @numero = MAX(Numero) from tb_Movimientos
-- Inserto un rubro "Repuesto" que es general.
-- insert into tb_Rubros (Rubro) values ('Repuestos')
while(exists(select 1 from ProductosPrueba$))
begin
	set @numero = @numero + 1
	
	select top 1
		@idItem = idProducto,
		@producto = producto,
		@cantidad = Cantidad
	from
		ProductosPrueba$
	
	delete
		ProductosPrueba$
	where
		idProducto = @idItem
	
	-- Cargo la tabla de productos.
	insert into tb_Productos (Producto, Descripcion, idRubro) values (@producto, '', 1)
	
	set @idProducto = SCOPE_IDENTITY()
	
	-- Cargo la existencia inicial.
	insert into tb_Movimientos (Fecha, idOperacionMovimiento, Numero, Observacion, idUsuario)
	values(SYSDATETIME(), 4, @numero, 'Carga Inicial de Stock.', 5)

	set @idMovimiento = SCOPE_IDENTITY()

	insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
	idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
	values (@cantidad, @idProducto, 2, 6, 4, @idMovimiento, 0, 1, 0, '', 0, 0)
	--
	insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
	idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
	values (@cantidad, @idProducto, 6, 5, 4, @idMovimiento, 1, 1, 0, '', 0, 0)
end