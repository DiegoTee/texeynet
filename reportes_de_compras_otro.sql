DECLARE @DateDesde char(8)
DECLARE @DateHasta char(8)
DECLARE @Desde datetime
DECLARE @Hasta datetime
set @DateDesde = '11012015'
set @DateHasta = '12312015'
set @Desde = CONVERT(datetime,RIGHT(@DateDesde,4)+LEFT(@DateDesde,2)+SUBSTRING(@DateDesde,3,2))
set @Hasta = CONVERT(datetime,RIGHT(@DateHasta,4)+LEFT(@DateHasta,2)+SUBSTRING(@DateHasta,3,2))


select
	om.Operacion,
	mov.Numero,
	CONVERT(varchar(12), mov.Fecha, 103) as Fecha,
	p.Producto,
	dm.Detalle,
	dm.Cantidad,
	userEntrega.Usuario as Aprobado,
	cc.CentroDeCosto as Usuario,
	pro.Nombre,
	dm.Precio,
	dep.Deposito
from
	tb_DetallesMovimientos dm
	inner join tb_Movimientos mov on dm.idMovimiento = mov.idMovimiento
	inner join tb_OperacionesMovimientos om on dm.idOperacionMovimiento = om.idOperacionMovimiento
	inner join tb_Productos p on dm.idProducto = p.idProducto
	inner join tb_DetallesMovimientos dmRef on (dm.idReferencia + 1) = dmRef.idDetalleMovimiento
	inner join tb_Depositos dep on dmRef.idDeposito = dep.idDeposito
	inner join tb_Usuarios userEntrega on dmRef.idUsuarioAprobado = userEntrega.idUsuario
	inner join tb_CentrosDeCostos cc on dm.idCentroDeCosto = cc.idCentroDeCosto
	inner join tb_Proveedores pro on mov.idProveedor = pro.idProveedor
where
	mov.Fecha > @Desde and mov.Fecha < @Hasta
	and dm.idOperacionMovimiento = 5
	and dep.idDeposito in (1, 6)
	
	
	
--select * from tb_DetallesMovimientos where idOperacionMovimiento = 5
--select * from tb_Movimientos



186.130.129.64
Secondary DNS Server:	200.63.155.114