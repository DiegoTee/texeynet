create table #eventos2
(idPedido int, idEvento int, nroPedido int, fecha varchar(10), desde varchar(10), hasta varchar(10), tarea varchar(50))

insert into #eventos2(idPedido, idEvento, nroPedido, fecha, desde, tarea)
select
	pe.idPedidoExterno,
	e.idEvento,
	pe.NroPedido,
	CONVERT(varchar(10), e.Fecha, 103) as Fecha,
	SUBSTRING(CONVERT(varchar, e.Fecha, 120), 12, 5) AS Desde,
	t.Tarea
from
	pd_Evento e
	INNER JOIN tb_PedidosExternos pe on e.idPedido = pe.idPedidoExterno
	INNER JOIN pd_Tarea t ON e.idTarea = t.idTarea
where
	convert(varchar(10), e.Fecha, 103) = '16/06/2015'
	AND pe.idCliente = 14
order by
	pe.FechaAsignacion, e.Fecha
	
declare @nroPedido int
declare @idEvento int
declare @fecha varchar(10)
declare @tarea varchar(50)
declare @idPedido int

while(exists (select 1 from #eventos2))
begin
	set @tarea = null
	-- Selecciono el primer evento de la fecha, para buscar su antecesor dentro del mismo pedido.
	select top 1
		@nroPedido = e2.nroPedido,
		@idEvento = idEvento,
		@fecha = fecha,
		@idPedido = idPedido
	from
		#eventos2 e2
		inner join tb_PedidosExternos pe on e2.idPedido = pe.idPedidoExterno
		
	-- Busco el antecesor. Si no tiene, es porque el pedido inicio en la fecha consultada.
	select top 1
		@tarea = t.Tarea
	from
		pd_Evento e
		inner join pd_Tarea t on e.idTarea = t.idTarea
	where
		e.idPedido = @idPedido
		AND CONVERT(varchar(10), e.Fecha, 103) < @fecha
	order by
		e.Fecha DESC
	
	print @tarea
	
	delete #eventos2 where idPedido = @idPedido
end

select * from #eventos2

drop table #eventos2


select top 1
	*
from pd_Evento
where idPedido = 160859 and convert(varchar(10), Fecha, 103) < '16/06/2015'
order by Fecha desc