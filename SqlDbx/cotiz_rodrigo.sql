SELECT
	vista.Anio,
   	vista.Semana,
	CASE WHEN vista.NombreEstado='CIUDAD DE MÉXICO' THEN vista.NombreEstado
		WHEN vista.nombremunicipio IN ('LEON', 'MONTERREY', 'GUADALAJARA','TIJUANA') THEN vista.nombremunicipio
		ELSE 'Resto Pais' END AS Ciudad,
	age.DescCanalComercial,

    --sum(vista.PLZ) AS Polizas,
    count(vista.NumCompletoCotizacion) AS Cotizaciones
   -- round(sum(vista.PrimaTarifa),0) AS Tarifa,
   --isnull(round(sum(vista.Prima_Neta),0),0) AS Emitida
 
FROM (
 
	SELECT   
    LEFT(cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ),4) AS Anio
    , datepart(wk,ctz.TiempoCotizacion) AS Semana
	, NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when emi.NumPoliza > 0 then 1 else 0 end   
    , catm.NombreEstado
    , catm.NombreMunicipio
    , NipPerfilAgente  = isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) 

	
	--, sum(emicob.PrimaNeta) AS Prima_Neta
	--, sum(plz.PrimaTarifa) AS PrimaTarifa

	from  DWH.Tb_bi_AutrEmiCotiz as ctz  
	
	left join TB_BI_DimOficina AS t4  
	ON t4.IdOficina = ctz.IdOficinaEmision  
	--AND t4.IdDireccionComercial IN (26862,31690,26861)
	  
	left join DWH.Tb_bi_GrlEmiCotizado AS plz  
	on  plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
	and plz.NumDocumento = ctz.NumDocumento  
	  --and plz.Eliminado = 0 -- #1  
	  
	left JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	on emi.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
	and emi.NumDocumento = ctz.NumDocumento  
	  --and isnull(plz2.IdTipoConservacion,0) = 0 
	  
	LEFT JOIN TB_BI_AutrFactEmisionCob AS emicob 
	ON emicob.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND emicob.NumDocumento=emi.NumDocumento
	

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
	
	left join VW_BI_DimVehiculo as cv 
	on cv.IdVehiculoInterno = isnull(plz.IdVehiculo , emi.IdVehiculo) 
	 
	left join TB_BI_DimPaquete AS t3  
	on   t3.IdPaquete = isnull(plz.IdPaquete , emi.IdPaquete)
	 
	left join  DWH.Tb_bi_AutrEmiCotizacionZonaCirc cp  
	on  cp.NumCompletoCotizacion = ctz.NumCompletoCotizacion   
	and cp.NumDocumento = ctz.NumDocumento 
	
	LEFT JOIN DMSin.Tb_BI_CatMunicipios AS catm
	ON catm.IdEstado=cp.IdEstado
	AND catm.IdMunicipio=cp.IdMunicipio   
	  
	where  ctz.IdLineaNegocio = 4  
	and ctz.TiempoCotizacion >= '20220101'  
	and ctz.Eliminado = 0  
	and isnull(plz.IdTipoPoliza , emi.IdTipoPoliza) = 4013  
	and isnull(ctz.NumDocumento,0) = 0  
	and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
	and cv.IdTipoVehiculo IN (4579, 3829)  
	and cast(isnull(isnull(plz.NumPolizaAnterior,emi.NumPolizaAnterior),0) as bigint) = 0  
	--and DescPaquete not like '%BASIC%'  
	--and DescPaquete not like '%RC%'  
	--and isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) not in (69982, 55783 ,58997 ,61795 ,65627 ,66081 ,67197 ,90712 ,90713 ,90750 ,90751 ,90752, 58577 )  
	--and isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) not in (Select NipPerfilAgente From TB_BI_DimAgente Where NombreAgente like '%HDI Seguros%' )   
	--AND t4.IdDireccionComercial = 26857
	--AND t4.IdOficina IN (74,290,382,434,720,722)
 
	and isnull(emi.IdTipoConservacion,0) = 0
	--AND (catm.NombreEstado = 'CIUDAD DE MÉXICO' OR catm.NombreMunicipio IN ('LEON', 'MONTERREY'))
	and isnull( axc.NipPerfilAgente, emi.NipPerfilAgente) not in (97486,105841)
	--GROUP BY LEFT(cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ),4),
	 --			ctz.NumCompletoCotizacion,
     --			ctz.IdOficinaEmision , 
     --			case when emi.NumPoliza > 0 then 1 else 0 END,
     --			catm.NombreEstado,
     --			catm.NombreMunicipio	

	 
)AS vista

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vista.NipPerfilAgente
 
WHERE vista.Anio>=2024
 
GROUP BY 	vista.Anio,
   			vista.Semana,
			CASE WHEN vista.NombreEstado='CIUDAD DE MÉXICO' THEN vista.NombreEstado
				WHEN vista.nombremunicipio IN ('LEON', 'MONTERREY', 'GUADALAJARA','TIJUANA') THEN vista.nombremunicipio
				ELSE 'Resto Pais' END,
	age.DescCanalComercial

ORDER BY vista.Anio,
		vista.Semana