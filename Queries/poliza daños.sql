SELECT  
		age.NombreAgente,
		count(juntas.cotizaciones) AS Ctz,
		sum(juntas.plz) AS plz
FROM  (	
	SELECT base.cotizaciones,
			base.fecha,
			base.NipAgente,
			CASE WHEN emi.Poliza>0 THEN 1
			ELSE 0 END AS plz

	FROM (
		SELECT cot.NumCompletoCotizacionMaestra AS cotizaciones,
				max(cot.NipAgente) NipAgente,
				CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) AS fecha
		FROM dwh.TB_Dwh_DanCotizacionesCob cot
		WHERE Eliminado=0
		AND NumDocumento=0
		AND NumPolizaAnterior IN (0,NULL)
		GROUP BY cot.NumCompletoCotizacionMaestra
				
		HAVING CAST(CAST(min(cot.FechaCotizacion) AS varchar) AS DATE) BETWEEN '2024-01-01' AND '2024-12-31'
	) AS base

	INNER JOIN (

		SELECT cot.NumCompletoCotizacionMaestra AS cotizaciones,
				max(cot.NipAgente) NipAgente,
				max(cot.NumPoliza) AS poliza
		FROM dwh.TB_Dwh_DanCotizacionesCob cot
		WHERE Eliminado=0
		AND NumDocumento=0
		AND NumPolizaAnterior IN (0,NULL)
		GROUP BY cot.NumCompletoCotizacionMaestra

	) AS emi
	ON emi.cotizaciones=base.cotizaciones
) AS juntas

LEFT JOIN TB_BI_DimAgente age on age.NipAgente = juntas.NipAgente
    

GROUP BY  
		age.NombreAgente