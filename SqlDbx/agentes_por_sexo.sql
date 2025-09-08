SELECT base.sexo,
		
		count(base.nombreagente) AS agentes

FROM (

	SELECT age.NombreAgente,
			ag.Sexo,
			sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta
	
	FROM TB_BI_DanFactEmisionCob AS emicob
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=1
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
	ON mon.IdMoneda=emi.IdMoneda
	
	LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
	ON tc.IdMoneda=emi.IdMoneda
	AND tc.Periodo = left(emi.FechaTransaccion,6)
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	LEFT JOIN dbo.TB_Bi_DimAgenteDatos AS ag
	ON ag.NipPerfilAgente=age.NipPerfilAgente
	
	
	WHERE emicob.FechaTransaccion BETWEEN 20250101 AND 20250530 
	AND age.IdTipoAgente=19
	AND emi.IdClasificacionProducto=12
	--AND emicob.ClaveRamo=5
	--AND emicob.ClaveSubRamo=7
	
	
	GROUP BY age.NombreAgente, 
			ag.Sexo
	
	HAVING sum(emicob.PrimaNeta*tc.TipoCambio)!=0

) AS base

GROUP BY base.sexo
