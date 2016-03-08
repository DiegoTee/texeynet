-- Borro los detalles movimientos que tienen referencia a otros detalles.
delete tb_DetallesMovimientos where ISNULL(idReferencia, 000) <> 000
-- Después borro los detalles movimientos referenciados por los borrados anteriormente.
delete tb_DetallesMovimientos where ISNULL(idReferencia, 000) = 000
-- Finalmente borro los movimientos
delete tb_Movimientos

-- Para borrar los productos y rubros.
delete tb_ItemsDePedidos
delete tb_RelOperacionesMovimientosProductos
delete tb_Productos
delete tb_RelCuentaRubro
delete tb_Rubros

-- Para resetear la IDENTITY KEY de Movimientos y Detalles Movimientos
DBCC CHECKIDENT (tb_Movimientos, RESEED,0)
DBCC CHECKIDENT (tb_DetallesMovimientos, RESEED,0)
DBCC CHECKIDENT (tb_Productos, RESEED,0)
DBCC CHECKIDENT (tb_Rubros, RESEED,0)