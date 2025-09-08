SELECT 
    FechaCotizacion			=  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) 
	, ctz.TiempoCotizacion
	, FechaEmision			= case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end 
    --, FechaEmision		= cast ( convert ( char ( 8 ), isnull(plz2.FechaEmision, ctz.TiempoCotizacion), 112 ) as int )                       
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion
    , IdOficina				= ctz.IdOficinaEmision
    , PLZ					=  case when plz2.NumPoliza > 0 then 1 else 0 end 
    , NumPoliza				= isnull(plz2.NumPoliza, 0)
    , PolizaAnterior		= cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)
    --, Usuario				= isnull(plz2.UsuarioEmitio, plz.Usuario)
    --, Autorizador			= isnull(plz.Autorizo, plz2.IdAutorizador)
    , NipPerfilAgente		= isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)
    , IdPaquete				= isnull(plz.IdPaquete, plz2.IdPaquete)
    , IdTipoPoliza			= isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza)
    , IdCanalVenta			= isnull(plz.IdCanalVenta , plz2.IdCanalVenta)
    --, IdAplicacion			= isnull(IdOrigenOT, 0)
    --, IdVehiculoInterno		= isnull(plz.IdVehiculo , plz2.IdVehiculo)
    , DTFechaCotizacion		= ctz.TiempoCotizacion
	, DTFechaEmision		= plz2.FechaEmision
    , PrimaTarifa			= isnull(plz2.PrimaTarifa , plz.PrimaTarifa)
    , Descuento				= isnull( plz2.AjusteEspecial , plz.AjusteEspecial)
	, CesionComision		= isnull( plz.CesionComision , plz2.CesionComision)
	, DerechoPoliza			= isnull( plz.DerechoPoliza , plz2.DerechoPoliza)
	, RecargoPagoFraccionado = isnull( plz.RecargoPagoFraccionado , plz2.RecargoPagoFraccionado)

    --, CodigoPostalPoliza    = isnull(cp.CodigoPostal, cp.CodigoPostal)
    --, IdTarifa				= isnull(plz.IdTarifa, plz2.IdTarifa)
    --, IdVesionTarifa		= isnull(plz2.IdVesionTarifa, 1)
    --, Modelo				= isnull(plz.ModeloVehiculo , plz2.ModeloVehiculo)
    , FechaInicioVigencia   = isnull(plz.FechaInicioVigencia , plz2.FechaInicioVigencia)
    , FechaFinVigencia		= isnull(plz.FechaFinVigencia , plz2.FechaFinVigencia)
	--, IdAutorizador			= isnull(plz.Autorizo, plz2.IdAutorizador)--isnull(plz.UserAutoriza , plz2.IdAutorizador)
	--, IdFrecuenciaPago		= isnull(plz.IdFrecuenciaPago , plz2.IdFrecuenciaPago)
	--, plz2.NumeroSerie
	--, Cancelada 			= 0 --case when t5.NumCompletoCotizacion > 0 then 1 else 0 end 
	--, PrimaTarifaCotizada	= isnull(plz.PrimaTarifa , plz2.PrimaTarifa)		-- #1
    --, DescuentoCotizado		= isnull( plz.AjusteEspecial , plz2.AjusteEspecial) -- #1
  from
	DWH.Tb_bi_AutrEmiCotiz ctz
	left join
		DWH.Tb_bi_GrlEmiCotizado plz
	on
		plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and plz.NumDocumento = ctz.NumDocumento
		--and plz.Eliminado = 0 -- #1
	
	left join
		TB_BI_AutrFactEmisionDoc plz2
	on
		plz2.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and plz2.NumDocumento = ctz.NumDocumento
		--and isnull(plz2.IdTipoConservacion,0) = 0

	left join
		DWH.Tb_bi_GrlEmiAgenteCotizacion axc  
	on
		axc.IdLineaNegocio = 4
		and ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion
		and ctz.NumDocumento = axc.NumDocumento

	left join
		DWH.TB_BI_GrlFactOTSolicitud sol
	on
		sol.IdLineaNegocio = ctz.IdLineaNegocio
		and sol.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and sol.NumDocumento = ctz.NumDocumento
		--and sol.Eliminado = 0
		and sol.IdEstatus = 3859 

	--inner join 
	--	VW_BI_DimVehiculo t2
	--on 
	--	t2.IdVehiculoInterno = isnull(plz.IdVehiculo , plz2.IdVehiculo)
			
	inner join 
		TB_BI_DimPaquete t3
	on 
		t3.IdPaquete = isnull(plz.IdPaquete , plz2.IdPaquete) 
	--left join
 --       DWH.Tb_bi_AutrEmiCotizacionZonaCirc cp
 --     on
 --       cp.NumCompletoCotizacion = ctz.NumCompletoCotizacion 
 --       and cp.NumDocumento = ctz.NumDocumento 	
	--inner join 
	--	TB_BI_DimOficina t4
	--on 
	--	t4.IdOficina = ctz.IdOficinaEmision		

	--left join ( select            
	--			   NumCompletoCotizacion            
	--			 from            
	--			   dbo.TB_BI_AutrFactEmisionDoc ed2
	--			inner join dbo.TB_BI_DimTipoDocumento td   
	--				on td.IdTipoDocumento = ed2.IdTipoDocumento                     
	--				and td.IdGrupoDocumento = 2            
	--			 where  ed2.NumDocumento =  ( select            
	--										   max ( NumDocumento )            
	--										  from            
	--										   dbo.TB_BI_AutrFactEmisionDoc            
	--										  where            
	--										   NumCompletoCotizacion = ed2.NumCompletoCotizacion  
	--										   and FechaEmision <= dateadd(DAY,40,ed2.FechaInicioVigenciaContrato)
	--										)  ) t5
	--on t5.NumCompletoCotizacion = ctz.NumCompletoCotizacion  

  where
    ctz.IdLineaNegocio = 4
    and ctz.TiempoCotizacion >= '20210401'
    --and ctz.Eliminado = 0

    and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013
    and isnull(ctz.NumDocumento,0) = 0
    and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0
    and t3.IdPaquete in ( 2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610)
    and isnull(plz2.IdTipoConservacion,0) = 0
