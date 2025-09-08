SELECT emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER ) AS Periodo,
		'Autos' AS Ramo,
			
		sum(emicob.PrimaNeta) AS Prima_Neta  


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento		
			
INNER JOIN hdi_dwh.dbo.Tb_Bi_dimoficina AS Ofi
ON emi.IdOficina=Ofi.IdOficina
AND Ofi.IdDireccionComercial IN (26862,31690, 26861)
			
			
INNER JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente
AND age.IdTipoAgente=19
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')


WHERE emicob.FechaTransaccion BETWEEN 20230101 AND 20231231

GROUP BY emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER )