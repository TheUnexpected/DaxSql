SELECT LEFT(base2.FechaTransaccion,6) AS Periodo,
		base2.descgrupoconservacion,
		sum(base2.Unidades) AS Unidades,
		sum(base2.fune) AS Funerarios
		

FROM (
	
	SELECT base.*,
			con.descgrupoconservacion,
			CASE WHEN fune.NumcompletoCotizacion IS NULL THEN 0
			ELSE 1 END AS fune	
	  
	FROM (				
		SELECT 	emi.FechaTransaccion,
				emi.NumCompletoCotizacion,
				emi.IdTipoConservacion,
		
				sum(tec.UnidadesEmitidasReales) AS Unidades
		
		FROM TB_BI_AutrFactEmisionDoc AS emi
		
		INNER JOIN TB_BI_AutrBase2Tecnica AS tec	
		ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		AND tec.NumDocumento=emi.NumDocumento
		AND tec.Periodo>=202401 
		AND tec.Periodo<=202502
		
		WHERE emi.IdTarifa=1
		
		GROUP BY emi.FechaTransaccion,
				emi.NumCompletoCotizacion,
				emi.IdTipoConservacion
		
		HAVING sum(tec.UnidadesEmitidasReales)>=1
		
		) AS base
		
	
	LEFT JOIN (
		SELECT DISTINCT emicob.NumCompletoCotizacion
		FROM TB_BI_autrFactEmisionCob emicob
		
		WHERE emicob.FechaTransaccion >= '20240101'
		AND emicob.IdCobertura=365
		AND emicob.NumDocumento=0
		)
		AS fune
	ON fune.NumCompletoCotizacion=base.NumCompletoCotizacion

	left JOIN TB_Bi_DimTipoConservacion AS con
	ON con.IdTipoConservacion=base.idtipoconservacion

) AS base2



WHERE base2.fechaTransaccion>=20240101

GROUP BY LEFT(base2.FechaTransaccion,6),
		base2.descgrupoconservacion
	
	