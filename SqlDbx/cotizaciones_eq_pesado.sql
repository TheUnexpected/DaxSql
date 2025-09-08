SELECT CASE WHEN base.Fechacotizacion BETWEEN 20240101 AND 20240630 THEN 'Primer'
		WHEN base.fechacotizacion BETWEEN 20240701 AND 20241231 THEN 'Segundo'
		ELSE 'Otro' END AS Periodo,
		base.nipperfilagente,
		
		count(base.numcompletocotizacion) AS cotizaciones,
		sum(base.plz)


FROM(
  
  SELECT   
    FechaCotizacion   =  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int )   
    , FechaEmision   = case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end   
    --, FechaEmision  = cast ( convert ( char ( 8 ), isnull(plz2.FechaEmision, ctz.TiempoCotizacion), 112 ) as int )                         
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when plz2.NumPoliza > 0 then 1 else 0 end   
    , NumPoliza    = isnull(plz2.NumPoliza, 0)  
    , PolizaAnterior  = cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)  
    
    , NipPerfilAgente  = isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)  
   
    
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
    and ctz.TiempoCotizacion between '20240101' AND '20241231'
    and ctz.Eliminado = 0  
  
    and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013  
    and isnull(ctz.NumDocumento,0) = 0  
    and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
    and t2.IdTipoVehiculo IN (22809,5676)  
    and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0  
    --and DescPaquete not like '%BASIC%'  
	--and DescPaquete not like '%RC%'  
	and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) IN (10108,10161,101739,101810,101821,102834,103066,104499,
                  105073,105154,105521,21208,21224,21252,5152,5164,
                  51737,52189,5227,52753,52983,53250,53353,53630,
                  54724,54776,54892,55101,55101,55468,56292,56310,
                  58232,58255,58538,58747,5975,63207,63367,65026,
                  65214,66008,66139,66334,67196,67362,67413,67419,
                  67465,67712,67944,68314,68544,69576,69995,70243,
                  70313,70391,91849,92047,92276,93512,93655,94401,
                  95429,95538,96021,96880,97078)  
	and isnull(plz2.IdTipoConservacion,0) = 0
	
) AS base

GROUP BY CASE when base.Fechacotizacion BETWEEN 20240101 AND 20240630 THEN 'Primer'
		WHEN base.fechacotizacion BETWEEN 20240701 AND 20241231 THEN 'Segundo'
		ELSE 'Otro' END,
		base.nipperfilagente