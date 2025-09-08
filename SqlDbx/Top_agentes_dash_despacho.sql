SELECT CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
		age.NipAgente,
		aseg.NombreAsegurado,
		
	   sum(emicob.PrimaNeta) AS Emitido
		
FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente= emi.NipPerfilAgente

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON emi.CveAsegurado=aseg.CveAsegurado

WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20231231

GROUP BY CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER),
		age.NipAgente,
		aseg.NombreAsegurado
		
HAVING sum(emicob.PrimaNeta)!=0