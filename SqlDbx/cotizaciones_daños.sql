SELECT LEFT(juntas.fecha,7) AS periodo,
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
					
		WHERE Eliminado=0
		AND NumDocumento=0
		AND NumPolizaAnterior IN (0,NULL)
				
		GROUP BY cot.NumCompletoCotizacionMaestra, cot.NipAgente
				
		HAVING CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) >='2025-01-01'
		
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

GROUP BY LEFT(juntas.fecha,7),	 
		juntas.NipPerfilAgente