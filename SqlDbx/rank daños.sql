SELECT age.IdOficina, age.NombreAgente,
			
			round(sum(tec.PrimaNetaPropiaSinCoaseguro),0) AS emitida,
			rank() OVER (PARTITION BY age.IdOficina ORDER BY sum(tec.PrimaNetaPropiaSinCoaseguro) desc) AS rank
	
	FROM TB_BI_DanFactEmisionDoc AS emi
			
	INNER JOIN TB_DWH_DanBaseTecnica AS tec	
	ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND tec.NumDocumento=emi.NumDocumento
	AND tec.Periodo BETWEEN 202309 AND 202408
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	WHERE age.IdTipoAgente=19
	AND age.NombreAgente NOT LIKE '%HDI%'
	
	GROUP BY age.NombreAgente, age.IdOficina

	