SELECT TOP (100) PERCENT
	dbo.tb_Productos.Producto,
	DSum.Detalle,
	DSum.Precio,
	dbo.tb_CentrosDeCostos.CentroDeCosto,
	dbo.tb_EstadosOperacion.Estado,
	dbo.tb_Depositos.Deposito, 
	DSum.Cantidad - ISNULL
	((SELECT     SUM(Cantidad) AS Expr1
	  FROM         dbo.tb_DetallesMovimientos
	  WHERE     (idReferencia = DSum.idDetalleMovimiento)), 0) AS Saldo,
	dbo.tb_Productos.idProducto,
	dbo.tb_Depositos.idDeposito,
	dbo.tb_EstadosOperacion.idEstadoOperacion,
	DSum.Aprobado, 
	DSum.idDetalleMovimiento,
	dbo.tb_CentrosDeCostos.idCentroDeCosto,
	dbo.tb_Movimientos.Fecha
FROM
	dbo.tb_DetallesMovimientos AS DSum
	INNER JOIN dbo.tb_Productos ON DSum.idProducto = dbo.tb_Productos.idProducto
	INNER JOIN dbo.tb_EstadosOperacion ON DSum.idEstadoOperacion = dbo.tb_EstadosOperacion.idEstadoOperacion
	INNER JOIN dbo.tb_Depositos ON DSum.idDeposito = dbo.tb_Depositos.idDeposito
	LEFT OUTER JOIN dbo.tb_Movimientos ON DSum.idMovimiento = dbo.tb_Movimientos.idMovimiento
	LEFT OUTER JOIN dbo.tb_CentrosDeCostos ON DSum.idCentroDeCosto = dbo.tb_CentrosDeCostos.idCentroDeCosto
WHERE
	(DSum.Entrada = 0)
	AND (DSum.Cantidad - ISNULL
	((SELECT     SUM(Cantidad) AS Expr1
	  FROM         dbo.tb_DetallesMovimientos AS tb_DetallesMovimientos_1
	  WHERE     (idReferencia = DSum.idDetalleMovimiento)), 0) > 0)
	  AND idDetalleMovimiento in (365258, 365259)
ORDER BY
	dbo.tb_Productos.Producto
	
	
	


select * from tb_DetallesMovimientos dm
where dm.Cantidad - ISNULL ((SELECT     SUM(Cantidad) AS Expr1
	  FROM         dbo.tb_DetallesMovimientos AS tb_DetallesMovimientos_1
	  WHERE     (idReferencia = dm.idDetalleMovimiento)), 0) > 0

	

select * from tb_DetallesMovimientos dm
where idMovimiento = 59963

select * from tb_DetallesMovimientos where idMovimiento = 59965

select * from tb_Movimientos where Numero = 5567

select * from tb_Movimientos where Numero = 5157

select * from tb_Movimientos where Numero = 1010

select *
from
	tb_DetallesMovimientos dm
	--inner join tb_EstadosOperacion eo on dm.idEstadoOperacion = eo.idEstadoOperacion
where idMovimiento = 59966

select * from tb_DetallesMovimientos where idDetalleMovimiento = 365256

select * from tb_EstadosOperacion

select * from tb_OperacionesMovimientos

select * from tb_Depositos

-- Movimiento de existencia inicial.
select * from tb_Movimientos where Numero = 1094
select * from tb_DetallesMovimientos where idMovimiento = 59967
-- Fin existencia inicial.

delete tb_Movimientos where idMovimiento <> 59967
delete tb_DetallesMovimientos where NOT(isnull(idReferencia,0))

select * from ProductoPrueba$
select * from inventarioTallerRDLS$

select * from tb_Movimientos
where Observacion like 'Creado automaticamente por el sistema para volver a 0 el stock'

select * from tb_DetallesMovimientos where idMovimiento in (23901, 23902)

select * from tb_PedidosExternos where FechaAsignacion < '20150112'

select
	idDetalleMovimiento,
	Cantidad,
	om.Operacion as Movimiento,
	p.Producto,
	Detalle
from
	tb_DetallesMovimientos dm
	inner join tb_OperacionesMovimientos om on dm.idOperacionMovimiento = om.idOperacionMovimiento
	inner join tb_Productos p on dm.idProducto = p.idProducto
where
	idDeposito = 6
	AND idEstadoOperacion = 2
	
	select * from tb_DetallesMovimientos where idMovimiento = 44409
	select * from tb_Movimientos where idMovimiento = 44409