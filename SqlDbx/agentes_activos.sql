SELECT count(DISTINCT age.NombreAgente)

FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina
		
inner JOIN (		
		
		SELECT emi.NipPerfilAgente,
				sum(emicob.PrimaNeta) AS Prima_Neta
		
		FROM TB_BI_AutrFactEmisionCob AS emicob
		
		
		INNER JOIN TB_BI_DimCobertura AS cob
		ON cob.IdCobertura=emicob.IdCobertura
		AND cob.DescTipoCobertura='Cobertura Propia'
		AND cob.IdLineaNegocio=4
		
		LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
		ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
		AND emi.NumDocumento=emicob.NumDocumento
		
		
		WHERE emicob.FechaTransaccion BETWEEN 20240101 AND 20240531
		
		GROUP BY emi.NipPerfilAgente
		
		HAVING 	sum(emicob.PrimaNeta)>=1000
		
		
		UNION ALL
		
		SELECT emi.NipPerfilAgente,
				sum(emicob.PrimaNeta) AS Prima_Neta
		
		
		FROM TB_BI_DanFactEmisionCob AS emicob
		
		
		INNER JOIN TB_BI_DimCobertura AS cob
		ON cob.IdCobertura=emicob.IdCobertura
		AND cob.DescTipoCobertura='Cobertura Propia'
		AND cob.IdLineaNegocio=1
		
		LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
		ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
		AND emi.NumDocumento=emicob.NumDocumento
		
		
		WHERE emicob.FechaTransaccion BETWEEN 20240101 AND 20240531
		
		GROUP BY emi.NipPerfilAgente
		
		HAVING 	sum(emicob.PrimaNeta)>=1000

) AS pmas

ON pmas.NipPerfilAgente=age.NipPerfilAgente

WHERE age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
AND age.IdTipoAgente = 19
AND age.FechaAlta<='2024-05-31'

AND ofi.IdDireccionComercial IN (26862,31690,26861)