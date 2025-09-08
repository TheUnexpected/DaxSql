SELECT
	vista.FechaCotizacion
	, vista.FechaEmision
	, vista.NumCompletoCotizacion
	, vista.NumPoliza
	, vista.PLZ
	, vista.IdOficina
	, vista.NipAgente
	, vista.NipPerfilAgente
	, vista.SinC
 

FROM (

	SELECT   
    FechaCotizacion   =  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int )   
 	--, ctz.TiempoCotizacion  
 	, FechaEmision   = case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end   
    --, FechaEmision  = cast ( convert ( char ( 8 ), isnull(plz2.FechaEmision, ctz.TiempoCotizacion), 112 ) as int )                         
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when plz2.NumPoliza > 0 then 1 else 0 end   
    , NumPoliza    = isnull(plz2.NumPoliza, 0)  
    , PolizaAnterior  = cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)  
    , agente.NipAgente 
    , NipPerfilAgente  = isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)  
 	, plz2.SinC
 
 
from  DWH.Tb_bi_AutrEmiCotiz as ctz  
  
inner join TB_BI_DimOficina AS t4  
ON t4.IdOficina = ctz.IdOficinaEmision    
 
left join DWH.Tb_bi_GrlEmiCotizado AS plz  
on  plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and plz.NumDocumento = ctz.NumDocumento  
  --and plz.Eliminado = 0 -- #1  
   
left JOIN
	(
		SELECT emi.FechaTransaccion,
				emi.NumCompletoCotizacion,
				emi.NumPoliza,
				emi.NumDocumento,
				emi.NumPolizaAnterior,
				--emi.UsuarioEmitio,
				--emi.IdAutorizador,
				emi.IdPaquete,
				--emi.FechaInicioVigencia,
				--emi.FechaFinVigencia,
				--emi.ModeloVehiculo,
				--emi.IdFrecuenciaPago,
				emi.IdVehiculo,
				emi.FechaEmision,
				--emi.IdCanalVenta,
				emi.IdTipoPoliza,
				emi.NipPerfilAgente,
				--emi.NumeroSerie,
				emi.IdTipoConservacion,
		
				round(sum(emicob.PrimaNeta),0) AS SinC

  
			FROM TB_BI_AutrFactEmisionCob AS emicob
			
			
			INNER JOIN TB_BI_DimCobertura AS cob
			ON cob.IdCobertura=emicob.IdCobertura
			AND cob.DescTipoCobertura='Cobertura Propia'
			AND cob.IdLineaNegocio=4
			
			LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
			ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
			AND emi.NumDocumento=emicob.NumDocumento 
			
			WHERE CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER) >=202211

		GROUP BY emi.FechaTransaccion,
				emi.NumCompletoCotizacion,
				emi.NumPoliza,
				emi.NumDocumento,
				emi.NumPolizaAnterior,
				--emi.UsuarioEmitio,
				--emi.IdAutorizador,
				emi.IdPaquete,
				--emi.FechaInicioVigencia,
				--emi.FechaFinVigencia,
				--emi.ModeloVehiculo,
				--emi.IdFrecuenciaPago,
				emi.IdVehiculo,
				emi.FechaEmision,
				--emi.IdCanalVenta,
				emi.IdTipoPoliza,
				emi.NipPerfilAgente,
				--emi.NumeroSerie,
				emi.IdTipoConservacion

	) AS plz2
on  
  plz2.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
  and plz2.NumDocumento = ctz.NumDocumento  
  --and isnull(plz2.IdTipoConservacion,0) = 0  
  
left join  DWH.Tb_bi_GrlEmiAgenteCotizacion AS axc    
on axc.IdLineaNegocio = 4  
and ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion  
and ctz.NumDocumento = axc.NumDocumento  

LEFT JOIN tb_bi_dimagente AS agente
ON agente.NipPerfilAgente=isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) 
 
left join  DWH.TB_BI_GrlFactOTSolicitud AS sol  
on  sol.IdLineaNegocio = ctz.IdLineaNegocio  
and sol.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and sol.NumDocumento = ctz.NumDocumento  
and sol.Eliminado = 0  
and sol.IdEstatus = 3859   
  
inner join VW_BI_DimVehiculo as t2  
on   t2.IdVehiculoInterno = isnull(plz.IdVehiculo , plz2.IdVehiculo)  
     
inner join TB_BI_DimPaquete AS t3  
on   t3.IdPaquete = isnull(plz.IdPaquete , plz2.IdPaquete)   
 
--left join  DWH.Tb_bi_AutrEmiCotizacionZonaCirc cp  
--on  cp.NumCompletoCotizacion = ctz.NumCompletoCotizacion   
--and cp.NumDocumento = ctz.NumDocumento    


where  ctz.IdLineaNegocio = 4  
and ctz.TiempoCotizacion >= '20230101'  
--and ctz.Eliminado = 0  
  
and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013  
and isnull(ctz.NumDocumento,0) = 0  
and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
and t2.IdTipoVehiculo IN (4579, 3829)  
and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0  
and DescPaquete not like '%BASIC%'  
and DescPaquete not like '%RC%'  
 --and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) != 69982  
and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (69982, 55783 ,58997 ,61795 ,65627 ,66081 ,67197 ,90712 ,90713 ,90750 ,90751 ,90752, 58577 )  
and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (Select NipPerfilAgente From TB_BI_DimAgente Where NombreAgente like '%HDI Seguros%' )  
 --and t4.DescDireccionComercial  in ( 'Baj?o - Occidente','M?xico - Sur','Norte' )  
AND t4.IdDireccionComercial IN (31690, 26861, 26862)
and ctz.IdOficinaEmision not in ( 11 ,18 ,21 ,25 ,26 ,31 ,42 )  
and isnull(plz2.IdTipoConservacion,0) = 0


 )AS vista

WHERE vista.FechaCotizacion>=20230101