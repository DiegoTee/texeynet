DECLARE @DateDesde char(8)
DECLARE @DateHasta char(8)
DECLARE @Desde datetime
DECLARE @Hasta datetime
set @DateDesde = '01012015'
set @DateHasta = '12312015'
set @Desde = CONVERT(datetime,RIGHT(@DateDesde,4)+LEFT(@DateDesde,2)+SUBSTRING(@DateDesde,3,2))
set @Hasta = CONVERT(datetime,RIGHT(@DateHasta,4)+LEFT(@DateHasta,2)+SUBSTRING(@DateHasta,3,2))

select
	om.Operacion,
	p.Producto,
	dt.Detalle,
	dt.Cantidad,
	CONVERT(varchar(12), mov.Fecha, 103) as Fecha,
	us.Nombre + '  ' + us.Apellido as Usuario,
	cc.CentroDeCosto as Se_Entregó_A
	--usu.Usuario
from
	tb_DetallesMovimientos dt
	inner join tb_Movimientos mov ON dt.idMovimiento = mov.idMovimiento
	inner join tb_Productos p ON dt.idProducto = p.idProducto
	inner join tb_OperacionesMovimientos om ON dt.idOperacionMovimiento = om.idOperacionMovimiento
	inner join tb_Usuarios us ON mov.idUsuario = us.idUsuario
	inner join tb_CentrosDeCostos cc ON dt.idCentroDeCosto = cc.idCentroDeCosto
where
	dt.idProducto in (94,157,398,399,400)
	--dt.idProducto in (155,318,327,149,151,262,268,330,382)
	and mov.Fecha > @Desde and mov.Fecha < @Hasta
order by
	mov.Fecha desc