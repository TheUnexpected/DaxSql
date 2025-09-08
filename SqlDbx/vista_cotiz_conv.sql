
  
  SELECT   
    FechaCotizacion   =  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int )   
 , ctz.TiempoCotizacion  
 , FechaEmision   = case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end   
    --, FechaEmision  = cast ( convert ( char ( 8 ), isnull(plz2.FechaEmision, ctz.TiempoCotizacion), 112 ) as int )                         
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when plz2.NumPoliza > 0 then 1 else 0 end   
    , NumPoliza    = isnull(plz2.NumPoliza, 0)  
    , PolizaAnterior  = cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)  
    , Usuario    = isnull(plz2.UsuarioEmitio, plz.Usuario)  
    , Autorizador   = isnull(plz.Autorizo, plz2.IdAutorizador)  
    , NipPerfilAgente  = isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)  
    , IdPaquete    = isnull(plz.IdPaquete, plz2.IdPaquete)  
    , IdTipoPoliza   = isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza)  
    , IdCanalVenta   = isnull(plz.IdCanalVenta , plz2.IdCanalVenta)  
    , IdAplicacion   = isnull(IdOrigenOT, 0)  
    , IdVehiculoInterno  = isnull(plz.IdVehiculo , plz2.IdVehiculo)  
    , DTFechaCotizacion  = ctz.TiempoCotizacion  
 , DTFechaEmision  = plz2.FechaEmision  
    , PrimaTarifa   = isnull(plz2.PrimaTarifa , plz.PrimaTarifa)  
    , Descuento    = isnull( plz2.AjusteEspecial , plz.AjusteEspecial)  
 , CesionComision  = isnull( plz.CesionComision , plz2.CesionComision)  
 , DerechoPoliza   = isnull( plz.DerechoPoliza , plz2.DerechoPoliza)  
 , RecargoPagoFraccionado = isnull( plz.RecargoPagoFraccionado , plz2.RecargoPagoFraccionado)  
  
    , CodigoPostalPoliza    = isnull(cp.CodigoPostal, cp.CodigoPostal)  
    , IdTarifa    = isnull(plz.IdTarifa, plz2.IdTarifa)  
    , IdVesionTarifa  = isnull(plz2.IdVesionTarifa, 1)  
    , Modelo    = isnull(plz.ModeloVehiculo , plz2.ModeloVehiculo)  
    , FechaInicioVigencia   = isnull(plz.FechaInicioVigencia , plz2.FechaInicioVigencia)  
    , FechaFinVigencia  = isnull(plz.FechaFinVigencia , plz2.FechaFinVigencia)  
 , IdAutorizador   = isnull(plz.Autorizo, plz2.IdAutorizador)--isnull(plz.UserAutoriza , plz2.IdAutorizador)  
 , IdFrecuenciaPago  = isnull(plz.IdFrecuenciaPago , plz2.IdFrecuenciaPago)  
 , plz2.NumeroSerie  
 , Cancelada    = 0 --case when t5.NumCompletoCotizacion > 0 then 1 else 0 end   
 , PrimaTarifaCotizada = isnull(plz.PrimaTarifa , plz2.PrimaTarifa)  -- #1  
    , DescuentoCotizado  = isnull( plz.AjusteEspecial , plz2.AjusteEspecial) -- #1  
  from  
 DWH.Tb_bi_AutrEmiCotiz ctz  
  inner join   
  TB_BI_DimOficina t4  
 on   
  t4.IdOficina = ctz.IdOficinaEmision    
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
 -- and isnull(plz2.IdTipoConservacion,0) = 0  
  
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
  and sol.Eliminado = 0  
  and sol.IdEstatus = 3859   
  
 left join   
  VW_BI_DimVehiculo t2  
 on   
  t2.IdVehiculoInterno = isnull(plz.IdVehiculo , plz2.IdVehiculo)  
     
 left join   
  TB_BI_DimPaquete t3  
 on   
  t3.IdPaquete = isnull(plz.IdPaquete , plz2.IdPaquete)   
 left join  
        DWH.Tb_bi_AutrEmiCotizacionZonaCirc cp  
      on  
        cp.NumCompletoCotizacion = ctz.NumCompletoCotizacion   
        and cp.NumDocumento = ctz.NumDocumento    
  where  
    ctz.IdLineaNegocio = 4  
    and ctz.TiempoCotizacion between '20220601' AND '20220630'
    and ctz.Eliminado = 0  
  
    and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013  
    and isnull(ctz.NumDocumento,0) = 0  
    and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
    and t2.IdTipoVehiculo IN (4579, 3829)  
 and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0  
    and DescPaquete not like '%BASIC%'  
 and DescPaquete not like '%RC%'  
 and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) != 69982  
 and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (69982, 55783 ,58997 ,61795 ,65627 ,66081 ,67197 ,90712 ,90713 ,90750 ,90751 ,90752, 58577 )  
 and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (Select NipPerfilAgente From TB_BI_DimAgente Where NombreAgente like '%HDI Seguros%' )  
 AND t4.IdDireccionComercial IN (31690, 26861, 26862)
 --and t4.DescDireccionComercial  in ( 'Bajio - Occidente','Mexico - Sur','Norte' )  
 and ctz.IdOficinaEmision not in ( 11 ,18 ,21 ,25 ,26 ,31 ,42 )  
 and isnull(plz2.IdTipoConservacion,0) = 0
 
