insert into tb_Movimientos (Fecha, idOperacionMovimiento, Numero, Observacion, idUsuario)
values(SYSDATETIME(), 4, 1, 'Carga Inicial de Stock.', 133)

insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
values (10, 404, 2, 7, 4, 1, 0, 1, 0, 'Prueba existencia inicial', 0, 0)
--
insert into tb_DetallesMovimientos (Cantidad, idProducto, idEstadoOperacion, idDeposito, idOperacionMovimiento,
idMovimiento, Entrada, Aprobado, Desestimado, Detalle, idCentroDeCosto, Consumido)
values (10, 404, 6, 5, 4, 1, 1, 1, 0, 'Prueba existencia inicial', 0, 0)

declare @unaVariable int
declare @idProducto int
set @unaVariable = 0
while(exists(select 1 from ProductoPrueba$))
begin
	set @unaVariable = @unaVariable + 1
	select top 1 @idProducto = idProducto
	from ProductoPrueba$
	delete ProductoPrueba$ where idProducto = @idProducto
end

select @unaVariable

select * from ProductosPrueba$