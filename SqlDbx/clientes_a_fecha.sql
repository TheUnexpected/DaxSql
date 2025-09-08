SELECT --aseg.DescGrupoConservacion,


count(DISTINCT aseg.NipAgrupador) AS Clientes_Dic_2022
		
FROM (  


	SELECT DISTINCT aseg.NipAgrupador,
			con.DescGrupoConservacion,
			'Autos' AS ramo
	
	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	LEFT JOIN tb_bi_dimasegurado AS aseg
	ON aseg.CveAsegurado=emi.CveAsegurado
	
	LEFT JOIN TB_Bi_DimTipoConservacion AS con
	ON con.IdTipoConservacion=emi.IdTipoConservacion
	
	WHERE emi.FechaInicioVigencia<CURRENT_TIMESTAMP
	AND emi.FechaFinVigencia>=CURRENT_TIMESTAMP
	
	UNION
	
	SELECT DISTINCT aseg.NipAgrupador,
			CASE WHEN emi.NumPolizaAnterior!=0 THEN 'Conservada'
			ELSE 'Nueva' END AS DescGrupoConservacion,
			'Daños' AS ramo
	
	FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
	
	LEFT JOIN tb_bi_dimasegurado AS aseg
	ON aseg.CveAsegurado=emi.CveAsegurado
	
	WHERE emi.FechaInicioVigencia<CURRENT_TIMESTAMP
	AND emi.FechaFinVigencia>=CURRENT_TIMESTAMP
	
	) AS aseg


--GROUP BY aseg.DescGrupoConservacion