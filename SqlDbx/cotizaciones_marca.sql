SELECT
	vista.Anio,
	vista.Modelo,
	vista.descmarcavehiculo,
   	vista.descsubmarcavehiculo,
    vista.desccarroceriavehiculo,
    vista.DescTipoVehiculo,
    vista.NombreEstado,
    vista.NombreMunicipio,
    sum(vista.PLZ) AS Polizas,
    count(vista.NumCompletoCotizacion) AS Cotizaciones,
    sum(vista.PrimaTarifa) AS Tarifa
 
FROM (
 
	SELECT   
    Anio  =  LEFT(cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int )  ,4)
	--, ctz.TiempoCotizacion  
	, NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when emi.NumPoliza > 0 then 1 else 0 end   
    , NumPoliza    = isnull(emi.NumPoliza, 0) 
	, isnull(emi.ModeloVehiculo,plz.ModeloVehiculo) AS Modelo
	, cv.descmarcavehiculo
    , cv.descsubmarcavehiculo
    , cv.desccarroceriavehiculo
    , cv.DescTipoVehiculo
    , cat.NombreEstado
    , cat.NombreMunicipio
    , plz.PrimaTarifa
 

from  DWH.Tb_bi_AutrEmiCotiz as ctz  
inner join TB_BI_DimOficina AS t4  
ON t4.IdOficina = ctz.IdOficinaEmision    
left join DWH.Tb_bi_GrlEmiCotizado AS plz  
on  plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and plz.NumDocumento = ctz.NumDocumento  
  --and plz.Eliminado = 0 -- #1  
left JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
on emi.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and emi.NumDocumento = ctz.NumDocumento  
  --and isnull(plz2.IdTipoConservacion,0) = 0 
left join  DWH.Tb_bi_GrlEmiAgenteCotizacion AS axc    
on axc.IdLineaNegocio = 4  
and ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion  
and ctz.NumDocumento = axc.NumDocumento   

left join  DWH.TB_BI_GrlFactOTSolicitud AS sol  
on  sol.IdLineaNegocio = ctz.IdLineaNegocio  
and sol.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and sol.NumDocumento = ctz.NumDocumento  
and sol.Eliminado = 0  
and sol.IdEstatus = 3859   
inner join VW_BI_DimVehiculo as cv 
on cv.IdVehiculoInterno = isnull(plz.IdVehiculo , emi.IdVehiculo)  
inner join TB_BI_DimPaquete AS t3  
on   t3.IdPaquete = isnull(plz.IdPaquete , emi.IdPaquete)
 

left join  DWH.Tb_bi_AutrEmiCotizacionZonaCirc cp  
on  cp.NumCompletoCotizacion = ctz.NumCompletoCotizacion   
and cp.NumDocumento = ctz.NumDocumento    
 
LEFT JOIN DMSin.Tb_BI_CatMunicipios AS cat
ON cat.IdEstado=cp.IdEstado
AND cat.IdMunicipio=cp.IdMunicipio
 
 
where  ctz.IdLineaNegocio = 4  
and ctz.TiempoCotizacion >= '20220101'  
--and ctz.Eliminado = 0  
and isnull(plz.IdTipoPoliza , emi.IdTipoPoliza) = 4013  
and isnull(ctz.NumDocumento,0) = 0  
and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
--and cv.IdTipoVehiculo IN (4579, 3829)  
and cast(isnull(isnull(plz.NumPolizaAnterior,emi.NumPolizaAnterior),0) as bigint) = 0  
and DescPaquete not like '%BASIC%'  
and DescPaquete not like '%RC%'  
--and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) != 69982  
and isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) not in (69982, 55783 ,58997 ,61795 ,65627 ,66081 ,67197 ,90712 ,90713 ,90750 ,90751 ,90752, 58577 )  
and isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) not in (Select NipPerfilAgente From TB_BI_DimAgente Where NombreAgente like '%HDI Seguros%' )   
AND t4.IdDireccionComercial IN (31690, 26861, 26862)
and ctz.IdOficinaEmision not in ( 11 ,18 ,21 ,25 ,26 ,31 ,42 )  
and isnull(emi.IdTipoConservacion,0) = 0
 
)AS vista
 
WHERE vista.Anio BETWEEN 2022 AND 2023
 
GROUP BY vista.Anio,
	vista.Modelo,
	vista.descmarcavehiculo,
   	vista.descsubmarcavehiculo,
    vista.desccarroceriavehiculo,
    vista.DescTipoVehiculo,
    vista.NombreEstado,
    vista.NombreMunicipio