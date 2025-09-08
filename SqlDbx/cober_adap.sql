SELECT polizas.IdOficina,
		polizas.NumPoliza,
		polizas.NumCertificado,
		cob.NumDocumento,
		desc_cob.IdCobertura,
		desc_cob.DescCobertura,
		desc_cob.DescTipoCobertura,
		cob.SumaAsegurada


FROM TB_BI_AutrFactEmisionCob AS cob


INNER JOIN (

			SELECT emi.NumCompletoCotizacion,
					emi.NumDocumento,
					emi.IdOficina,
					emi.NumPoliza,
					emi.NumCertificado
			
			FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
			
			WHERE emi.IdOficina=736
			AND emi.NumPoliza=719
			--AND emi.FechaEmision BETWEEN '2022-01-01' AND '2023-04-30'
			--AND CAST(emi.FechaFinVigencia AS DATE) ='2023-03-28'
			
			) AS polizas
			
ON polizas.NumCompletoCotizacion=cob.NumCompletoCotizacion
AND polizas.NumDocumento=cob.NumDocumento
			
			
inner JOIN TB_BI_DimCobertura AS desc_cob
ON desc_cob.IdCobertura=cob.Idcobertura
AND desc_cob.IdCobertura IN (251,252,363,652,653,654,714)

WHERE cob.NumDocumento=0
			
ORDER BY polizas.NumPoliza, cob.Idcobertura