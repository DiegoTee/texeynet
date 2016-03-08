-- INICIO PARTE 1

declare @nroPedido int
declare @idPedidoExterno int
declare @FechaAux datetime
declare @idEventoAux int
declare @horaFin varchar(10)
declare @tarea varchar(50)
declare @tareaAnterior varchar(50)
declare @ubicacionDesdeAnterior varchar(50)
declare @ubicacionHastaAnterior varchar(50)
declare @equipo varchar(50)
declare @cliente varchar(50)
declare @nroContrato varchar(20)
declare @mes varchar(10)
declare @dia varchar(10)
declare @unidad varchar(10)
declare @categoria varchar(50)
declare @chofer varchar(100)
declare @dniChofer varchar(20)
declare @tiempoTarea float
declare @ubicacionDesde varchar(50)
declare @ubicacionHasta varchar(50)
declare @nroRemito int
declare @nroReserva varchar(20)
declare @unidadMedida varchar(20)
declare @cantidad int
declare @tipoCarga varchar(50)
declare @comentarios varchar(MAX)

create table #pedidosFinalizados
(idPedido int, nroPedido int, horaFinalizado varchar(10), unidad varchar(10), categoria varchar(50), chofer varchar(100), dniChofer varchar(20), equipo varchar(50), nroRemito int, nroReserva varchar(20), unidadMedida varchar(20), cantidad int, tipoCarga varchar(50), comentarios varchar(300))
create table #eventoAnterior (idEvento int)
create table #resultado
(
	CONTRATISTA varchar(50),
	NºCONTRATO varchar(20),
	FECHA varchar(10),
	MES varchar(10),
	DIA varchar(10),
	PATENTE  varchar(10),
	CATEGORÍA varchar(50),
	CHOFER varchar(100),
	DNI_CHOFER varchar(20),
	DESDE varchar(10),
	HASTA varchar(10),
	TIEMPO_TRANSCURRIDO float,
	TAREAS varchar(50),
	UBICACIÓN_DESDE varchar(50),
	UBICACIÓN_HASTA varchar(50),
	EQUIPO varchar(50),
	NºREMITO int,
	NºRESERVA varchar(20),
	UNIDAD_MEDIDA varchar(20),
	CANTIDAD int,
	TIPO_CARGA varchar(50),
	COMENTARIOS varchar(300),
	nroPedido int,
	tipoDeEventoParaDebug varchar(30)
)
SELECT @nroContrato = Valor FROM tb_Sistema WHERE Condicion = 'NroContrato'
SELECT @cliente = Cliente FROM tb_Clientes WHERE idCliente = 14
SET @mes = SUBSTRING('16/06/2015', 4, 2)
SET @dia = SUBSTRING('16/06/2015', 1, 2)

-- Cargo en la tabla los pedidos finalizados para el cliente en la fecha dada.
insert into #pedidosFinalizados(idPedido, nroPedido, horaFinalizado, unidad, categoria, chofer, dniChofer, equipo, nroRemito, nroReserva, unidadMedida, cantidad, tipoCarga, comentarios)
select
	idPedidoExterno,
	NroPedido,
	SUBSTRING(CONVERT(varchar, FechaCompletado, 120), 12, 5) as horaFin,
	cam.Dominio,
	cat.Categoria,
	cho.Nombre,
	cho.DNI,
	eq.Equipo,
	pe.Remito,
	pe.NumeroReserva,
	pe.UnidadMedida,
	pe.Cantidad,
	tc.TipoDeCarga,
	pe.Comentario
from
	tb_PedidosExternos pe
	INNER JOIN tb_Camiones cam ON pe.idCamion = cam.idCamion
	LEFT JOIN pd_Categoria cat ON cam.idCategoria = cat.idCategoria
	LEFT JOIN tb_Choferes cho ON pe.idChofer = cho.idChofer
	INNER JOIN tb_Equipos eq ON pe.idEquipo = eq.idEquipo
	INNER JOIN tb_TiposDeCarga tc ON cam.idTipoDeCarga = tc.idTipoDeCarga
where
	CONVERT(varchar(10), pe.FechaCompletado, 103) = '16/06/2015'
	AND pe.idCliente = 14

while(exists(select 1 from #pedidosFinalizados))
begin
	select top 1
		@idPedidoExterno = idPedido,
		@nroPedido = nroPedido,
		@horaFin = horaFinalizado,
		@unidad = unidad,
		@categoria = categoria,
		@chofer = chofer,
		@dniChofer = dniChofer,
		@equipo = equipo,
		@nroRemito = nroRemito,
		@nroReserva = nroReserva,
		@unidadMedida = unidadMedida,
		@cantidad = cantidad,
		@tipoCarga = tipoCarga,
		@comentarios = comentarios
	from
		#pedidosFinalizados

	-- Obtengo el último evento que se realizó antes de cerrar el pedido.
	select
		@idEventoAux = idEvento,
		@FechaAux = Fecha,
		@tarea = t.Tarea,
		@ubicacionDesde = ISNULL(pRefO.PuntoDeReferencia, @ubicacionDesde),
		@ubicacionHasta = ISNULL(pRefD.PuntoDeReferencia, @ubicacionHasta)
	from
		pd_Evento e
		INNER JOIN pd_Tarea t ON e.idTarea = t.idTarea
		LEFT JOIN tb_PuntosDeReferencias pRefO ON e.idOrigen = pRefO.idPuntoDeReferencia
		LEFT JOIN tb_PuntosDeReferencias pRefD ON e.idDestino = pRefD.idPuntoDeReferencia
	where
		Fecha in(select
					 MAX(Fecha)
				 from
				     pd_Evento
				 where
					 idPedido = @idPedidoExterno)
	
	-- Si el evento se inició antes de la FECHA de cierre, cargo un evento con inicio a las 00:00
	if(CONVERT(varchar(10), @FechaAux, 103) < '16/06/2015')
	BEGIN
		SET @tiempoTarea = dbo.calcularTiempo('00:00', @horaFin)

		insert into #resultado (contratista, NºCONTRATO, FECHA, MES, DIA, PATENTE, CATEGORÍA, CHOFER, DNI_CHOFER, DESDE, HASTA, TIEMPO_TRANSCURRIDO, TAREAS, UBICACIÓN_DESDE, UBICACIÓN_HASTA, EQUIPO, NºREMITO, NºRESERVA, UNIDAD_MEDIDA, CANTIDAD, TIPO_CARGA, COMENTARIOS, nroPedido, tipoDeEventoParaDebug)
		values(@cliente, @nroContrato, '16/06/2015', @mes, @dia, @unidad, @categoria, @chofer, @dniChofer, '00:00', @horaFin, @tiempoTarea, @tarea, @ubicacionDesde, @ubicacionHasta, @equipo, @nroRemito, @nroReserva, @unidadMedida, @cantidad, @tipoCarga, @comentarios, @nroPedido, 'Solo evento fin.')
	END
	
	delete #pedidosFinalizados where idPedido = @idPedidoExterno
end

-- FIN PARTE 1

-- INICIO PARTE 2

declare @idEvento int
declare @idEventoAnterior int
declare @fecha varchar(10)
declare @desde varchar(10)
declare @hasta varchar(10)
declare @idPedido int
declare @idPedidoActual int
declare @seguir bit

create table #eventos
(
	idPedido int,
	idEvento int,
	nroPedido int,
	fecha varchar(10),
	desde varchar(10),
	hasta varchar(10),
	tarea varchar(50),
	unidad varchar(10),
	categoria varchar(50),
	chofer varchar(100),
	dniChofer varchar(20),
	origen varchar(50),
	destino varchar(50),
	equipo varchar(50),
	nroRemito int,
	nroReserva varchar(20),
	unidadMedida varchar(20),
	cantidad int,
	tipoCarga varchar(50),
	comentarios varchar(300)
)

-- Cargo los datos en una tabla auxiliar para después iterar sobre ella.

insert into #eventos (idPedido, idEvento, nroPedido, fecha, desde, tarea, unidad, categoria, chofer, dniChofer, origen, destino, equipo, nroRemito, nroReserva, unidadMedida, cantidad, tipoCarga, comentarios)
select
	pe.idPedidoExterno,
	e.idEvento,
	pe.NroPedido,
	CONVERT(varchar(10), e.Fecha, 103) as Fecha,
	SUBSTRING(CONVERT(varchar, e.Fecha, 120), 12, 5) AS Desde,
	t.Tarea,
	cam.Dominio,
	cat.Categoria,
	cho.Nombre,
	cho.DNI,
	pRefO.PuntoDeReferencia as Origen,
	pRefD.PuntoDeReferencia as Destino,
	eq.Equipo,
	pe.Remito,
	pe.NumeroReserva,
	pe.UnidadMedida,
	pe.Cantidad,
	tc.TipoDeCarga,
	pe.Comentario
from
	pd_Evento e
	INNER JOIN tb_PedidosExternos pe on e.idPedido = pe.idPedidoExterno
	INNER JOIN pd_Tarea t ON e.idTarea = t.idTarea
	INNER JOIN tb_Camiones cam ON pe.idCamion = cam.idCamion
	LEFT JOIN pd_Categoria cat ON cam.idCategoria = cat.idCategoria
	LEFT JOIN tb_Choferes cho ON pe.idChofer = cho.idChofer
	LEFT JOIN tb_PuntosDeReferencias pRefO ON e.idOrigen = pRefO.idPuntoDeReferencia
	LEFT JOIN tb_PuntosDeReferencias pRefD ON e.idDestino = pRefD.idPuntoDeReferencia
	INNER JOIN tb_Equipos eq ON pe.idEquipo = eq.idEquipo
	INNER JOIN tb_TiposDeCarga tc ON cam.idTipoDeCarga = tc.idTipoDeCarga
where
	convert(varchar(10), e.Fecha, 103) = '16/06/2015'
	AND pe.idCliente = 14
order by
	pe.FechaAsignacion, e.Fecha
	
-- Recorro la tabla auxiliar

set @idPedidoActual = null

while(exists(select 1 from #eventos))
begin
	set @hasta = null
	
	-- Tercera Parte
	set @tarea = null
	set @tareaAnterior = null
	-- Selecciono el primer evento de la fecha, para buscar su antecesor dentro del mismo pedido.
	select top 1
		@nroPedido = e.nroPedido,
		@idEvento = idEvento,
		@fecha = fecha,
		@desde = desde,
		@idPedido = idPedido,
		@tarea = tarea,
		@unidad = unidad,
		@categoria = categoria,
		@chofer = chofer,
		@dniChofer = dniChofer,
		@ubicacionDesde = ISNULL(e.origen, @ubicacionDesde),
		@ubicacionHasta = ISNULL(e.destino, @ubicacionHasta),
		@equipo = equipo,
		@nroRemito = e.nroRemito,
		@nroReserva = e.nroReserva,
		@unidadMedida = e.unidadMedida,
		@cantidad =  e.cantidad,
		@tipoCarga = tipoCarga,
		@comentarios = comentarios
	from
		#eventos e
		inner join tb_PedidosExternos pe on e.idPedido = pe.idPedidoExterno

	if(@idPedidoActual IS null OR @idPedidoActual <> @idPedido)
	begin
		-- Busco el antecesor. Si no tiene, es porque el pedido inicio en la fecha consultada.
		select top 1
			@idEventoAnterior = e.idEvento,
			@tareaAnterior = t.Tarea,
			@ubicacionDesdeAnterior = ISNULL(pRefO.PuntoDeReferencia, @ubicacionDesdeAnterior),
			@ubicacionHastaAnterior = ISNULL(pRefD.PuntoDeReferencia, @ubicacionHastaAnterior)
		from
			pd_Evento e
			INNER JOIN pd_Tarea t on e.idTarea = t.idTarea
			LEFT JOIN tb_PuntosDeReferencias pRefO ON e.idOrigen = pRefO.idPuntoDeReferencia
			LEFT JOIN tb_PuntosDeReferencias pRefD ON e.idDestino = pRefD.idPuntoDeReferencia
		where
			e.idPedido = @idPedido
			AND CONVERT(varchar(10), e.Fecha, 103) < @fecha
		order by
			e.Fecha DESC

		set @idPedidoActual = @idPedido

		--delete #eventos2 where idPedido = @idPedido
		
		if(NOT (@tareaAnterior IS null))
		begin
			SET @tiempoTarea = dbo.calcularTiempo('00:00', @desde)
			insert into #resultado (contratista, NºCONTRATO, FECHA, MES, DIA, PATENTE, CATEGORÍA, CHOFER, DNI_CHOFER, DESDE, HASTA, TIEMPO_TRANSCURRIDO, TAREAS, UBICACIÓN_DESDE, UBICACIÓN_HASTA, EQUIPO, NºREMITO, NºRESERVA, UNIDAD_MEDIDA, CANTIDAD, TIPO_CARGA, COMENTARIOS, nroPedido, tipoDeEventoParaDebug)
			values (@cliente, @nroContrato, @fecha, @mes, @dia, @unidad, @categoria, @chofer, @dniChofer, '00:00', @desde, @tiempoTarea, @tareaAnterior, @ubicacionDesde, @ubicacionHasta, @equipo, @nroRemito, @nroReserva, @unidadMedida, @cantidad, @tipoCarga, @comentarios, @nroPedido, 'Empezados ayer pero siguen.')
		end
	end

	-- Fin tercera parte
	
	--select top 1
	--	@idEvento = idEvento,
	--	@nroPedido = nroPedido,
	--	@fecha = fecha,
	--	@desde = desde,
	--	@tarea = tarea
	--from
	--	#eventos

	-- Borro el evento de la tabla #registro para no tomarlo en la búsqueda del "siguiente evento"

	delete #eventos where idEvento = @idEvento

	select top 1
		@hasta = desde
	from
		#eventos e
	where
		desde > @desde
		AND nroPedido = @nroPedido

	if(@hasta is null)
	begin
		select @hasta = SUBSTRING(CONVERT(varchar, FechaCompletado, 120), 12, 5)
		from tb_PedidosExternos
		where NroPedido = @nroPedido AND CONVERT(varchar(10), FechaCompletado, 103) = '16/06/2015'
		-- Si sigue siendo null, es porque no finalizó todavía. Le cargo un desde genérico con 00:00
		if(@hasta is null)
			set @hasta = '23:59'
	end

	-- Busco el evento anterior, si es que se inició el día anterior.

	SET @tiempoTarea = dbo.calcularTiempo(@desde, @hasta)
 
	insert into #resultado
		(contratista, NºCONTRATO, fecha, MES, DIA, PATENTE, CATEGORÍA, CHOFER, DNI_CHOFER, DESDE, HASTA, TIEMPO_TRANSCURRIDO, TAREAS, UBICACIÓN_DESDE, UBICACIÓN_HASTA, EQUIPO, NºREMITO, NºRESERVA, UNIDAD_MEDIDA, CANTIDAD, TIPO_CARGA, COMENTARIOS, nroPedido, tipoDeEventoParaDebug)
	values
		(@cliente, @nroContrato, @fecha, @mes, @dia, @unidad, @categoria, @chofer, @dniChofer, @desde, @hasta, @tiempoTarea, @tarea, @ubicacionDesde, @ubicacionHasta, @equipo, @nroRemito, @nroReserva, @unidadMedida, @cantidad, @tipoCarga, @comentarios, @nroPedido, 'Eventos de hoy')

end

-- FIN PARTE 2

select * from #resultado

drop table #eventos
drop table #resultado
drop table #pedidosFinalizados
drop table #eventoAnterior