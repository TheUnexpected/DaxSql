SELECT base_tot.Anio,
		
		count(DISTINCT(base_tot.nombreagente)) AS Agentes

FROM (


SELECT year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Anio,
	   age.NombreAgente,
  	   
	   count(DISTINCT(vc.NumCompletoCotizacion)) AS Cotizaciones,
    	sum(vc.PLZ) AS Polizas
	

FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS vc

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vc.nipperfilagente

inner JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=vc.IdOficina
and ofi.DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias')

WHERE (vc.FechaCotizacion>= '20240101'  AND vc.FechaCotizacion<='20240430' OR vc.FechaCotizacion>= '20250101'  AND vc.FechaCotizacion<='20250430')
AND vc.IdPaquete NOT IN (57, 58, 430, 431,432,447,448,449) 
AND age.NombreAgente NOT IN ('TRIGARANTE AGENTE DE SEGUROS Y DE FIANZAS SA DE CV','ASESORES DE RIESGO POR CANALES ALTERNOS AGENTE DE SEGUROS  SA DE CV')
AND ofi.IdOficina NOT IN (1,806,881,563)
AND vc.NumCompletoCotizacion NOT IN (40380000877243, 40380000876981, 40380000876982, 41760001230996, 41760001216843, 47360000005617,47360000005615, 40100001267513,41760001216844, 1760001121277, 41760001212948, 41760001127305, 40050001508447, 41390001279693,48260000003276, 40570001318953, 41950000980727, 41950000980494, 41950000976784, 41790000030565,41950000976322)


GROUP BY year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)),
	   age.NombreAgente
	
UNION ALL

SELECT flot.anio,
		age.nombreagente,
		
		sum(flot.cotizaciones) AS cotizaciones,
		sum(flot.polizas) AS Polizas


FROM (

SELECT 
		isnull(cotII.Anio,plz.Anio) AS Anio,
	   CAST(isnull(cotII.NipPerfilagente,plz.NipPerfilAgente) AS INTEGER) AS NipPerfilAgente,
		isnull(cotII.Cotizaciones,0) AS Cotizaciones,
		isnull(plz.Polizas,0) AS Polizas
	   


FROM(	
	
	SELECT cotiz.Anio,
			cotiz.NipPerfilAgente,

			count(DISTINCT cotiz.IdOt) AS cotizaciones
	FROM (	
		
		SELECT 
		  	year(cot.TiempoAltaOt) AS Anio,
		    cot.IdOT,
		    cot.NipPerfilAgente

		    
		FROM Dshd.VW_DWH_AutrMasivosSuscripcion_Impacto AS cot
	
		
		WHERE 
			    -- Filtros por tipo de documento
			    TipoDocumento IN (
			        'Recotización',
			        'Claveteo y Cotización',
			        'Claveteo y Cotización MODA'
			    )
			    -- Filtro por estatus de suscripción
			   AND EstatusSuscripcion IN ('Terminado')
			   --AND CAST(TiempoAltaOt AS DATE)>= '2025/01/01'
			    AND (CAST(tiempoaltaot AS DATE) BETWEEN '2024/01/01' AND '2024/04/30' OR CAST(tiempoaltaot AS DATE) BETWEEN '2025/01/01' AND '2025/04/30')
			    AND cot.SubdireccionComercial IN (
	        'Mexico Promotorias',
	        'Mexico Despachos'
	        )
	
	) AS cotiz
	
	GROUP BY cotiz.Anio,
			cotiz.NipPerfilAgente
	   	

) AS cotII

full JOIN (

	SELECT  emi.Anio,
			emi.NipPerfilAgente,
			
			sum(emi.plz) AS Polizas
	
	FROM (	
		
		SELECT 
			
		   year(cot.TiempoAltaOt) AS Anio,
		    cot.IdOT,
		    cot.NipPerfilAgente,
		  
		    CASE WHEN emisiones.ot_cotizacion IS NULL THEN 0
				ELSE 1 END AS PLZ
		    
		FROM Dshd.VW_DWH_AutrMasivosSuscripcion_Impacto AS cot
		
		LEFT join 
			
		(	SELECT DISTINCT OT_Cotizacion
				
				FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto AS Emi
					
				WHERE Emi.FechaEmision >= '2024-01-01'
					
		) AS emisiones
				  
		ON emisiones.OT_cotizacion=cot.IdOT	
		
	
		
		WHERE 
			    -- Filtros por tipo de documento
			    TipoDocumento IN (
			        'Recotización',
			        'Claveteo y Cotización',
			        'Claveteo y Cotización MODA'
			    )
			    -- Filtro por estatus de suscripción
			   --AND EstatusSuscripcion IN ('Terminado')
			   --AND CAST(TiempoAltaOt AS DATE)>= '2025/01/01'
			      AND (CAST(tiempoaltaot AS DATE) BETWEEN '2024/01/01' AND '2024/04/30' OR CAST(tiempoaltaot AS DATE) BETWEEN '2025/01/01' AND '2025/04/30')
			    AND cot.SubdireccionComercial IN (
	        'Mexico Promotorias',
	        'Mexico Despachos'
	        )
	
	) AS emi
	
	GROUP BY emi.Anio,
			emi.NipPerfilAgente
	
) AS plz

ON cotII.Anio=plz.Anio
AND cotII.NipPerfilAgente=plz.Nipperfilagente

) AS flot

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=flot.NipPerfilAgente

GROUP BY flot.anio,
		age.nombreagente

HAVING sum(flot.cotizaciones) !=0


UNION ALL

SELECT Danos.Anio,
		age.nombreagente, 
		
		sum(Danos.ctz) AS cotizaciones,
		sum(Danos.plz) AS polizas

FROM (

SELECT LEFT(juntas.fecha,4) AS Anio,
	juntas.NipPerfilAgente,
		
		count(juntas.cotizaciones) AS Ctz,
		sum(juntas.plz) AS plz
	
FROM  (	
	
	SELECT base.cotizaciones,
			base.NipPerfilAgente,
			base.fecha,
			CASE WHEN emi.Poliza>0 THEN 1
			ELSE 0 END AS plz
	
		
	FROM (
		
		SELECT cot.NumCompletoCotizacionMaestra AS cotizaciones,
				cot.NipAgente AS NipPerfilAgente,
				CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) AS fecha
					 
		FROM dwh.TB_Dwh_DanCotizacionesCob cot
		
		LEFT JOIN tb_bi_dimoficina AS ofi
		ON ofi.IdOficina=cot.IdOficina
					
		WHERE Eliminado=0
		AND NumDocumento=0
		AND NumPolizaAnterior IN (0,NULL)
		AND ofi.DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias')
				
		GROUP BY cot.NumCompletoCotizacionMaestra, cot.NipAgente
				
		HAVING CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) BETWEEN '2024-01-01' AND '2024-04-30' OR 
		CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) BETWEEN '2025-01-01' AND '2025-04-30'
		
	) AS base
		
		
	INNER JOIN (
	
		
		SELECT cot.NumCompletoCotizacionMaestra AS cotizaciones,
				cot.NipAgente AS NipPerfilAgente,
				max(cot.NumPoliza) AS poliza
						 
		FROM dwh.TB_Dwh_DanCotizacionesCob cot
						
		WHERE Eliminado=0
		AND NumDocumento=0
		AND NumPolizaAnterior IN (0,NULL)
				
		GROUP BY cot.NumCompletoCotizacionMaestra, cot.NipAgente
				
	) AS emi
			
	ON emi.cotizaciones=base.cotizaciones
	AND emi.nipperfilagente=base.nipperfilagente
		
) AS juntas

GROUP BY LEFT(juntas.fecha,4),
		juntas.NipPerfilAgente

) AS Danos

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=danos.nipperfilagente

GROUP BY  Danos.Anio,
		age.nombreagente
		
) AS base_tot

GROUP BY base_tot.Anio