SELECT baseII.Trimestre, baseII.RamoSubramol, baseII.conservacion,

		count(DISTINCT baseII.PolBupa) AS pagadas

FROM (

	SELECT base.*, pago.pagada
	
	FROM ( SELECT 	DISTINCT CASE WHEN gmm.FemiRbo BETWEEN 20240101 AND 20240331 THEN 'Q1'
				WHEN gmm.FemiRbo BETWEEN 20240401 AND 20240630 THEN 'Q2'
				WHEN gmm.FemiRbo BETWEEN 20240701 AND 20240930 THEN 'Q3'
				WHEN gmm.FemiRbo BETWEEN 20240801 AND 20241231 THEN 'Q4'
				ELSE 'Otro' END AS Trimestre,
				gmm.RamoSubramol,
				CASE WHEN gmm.Renueva=0 THEN 'Nueva'
					--WHEN gmm.Renueva=1 THEN 'Renovacion' 
					ELSE 'Renovacion' END AS Conservacion,
			    gmm.PolSocioComercial AS PolBUPA
				
	
			FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm
			
			WHERE LEFT(gmm.FemiRbo,4)=2024
	
	) AS base
	
	LEFT JOIN (
	
			SELECT pag.POLIZA_BUPA, 
			
					sum(pag.Pma1) AS pagada
			
			FROM TB_DWH_GMMRecibosCobrados_CargaDiaria AS pag
			
			GROUP BY pag.POLIZA_BUPA
	
	
	) AS pago
	
	ON pago.Poliza_bupa=base.PolBupa
	
) AS baseII

WHERE baseII.pagada >= 1000

GROUP BY baseII.Trimestre, baseII.RamoSubramol, baseII.conservacion