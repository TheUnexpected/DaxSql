SELECT emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER ) AS Periodo,
		'Daños' AS Ramo,
			
			sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta  


FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento		
			
INNER JOIN hdi_dwh.dbo.Tb_Bi_dimoficina AS Ofi
ON emi.IdOficina=Ofi.IdOficina
AND Ofi.IdDireccionComercial IN (26862,31690, 26861)
			
			
INNER JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente
AND age.IdTipoAgente=19
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

WHERE emicob.FechaTransaccion BETWEEN 20230101 AND 20231231

GROUP BY emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER )