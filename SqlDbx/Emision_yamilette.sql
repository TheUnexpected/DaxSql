SELECT CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
			round(sum(emicob.PrimaNeta),0) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4
--AND cob.DescGrupoCobertura IN ('DAÑOS MATERIALES','ROBO TOTAL')
AND cob.DescGrupoCobertura IN ('RESPONSABILIDAD CIVIL')

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento


WHERE emicob.FechaTransaccion BETWEEN 20190101 AND 20231231
AND emi.IdOficina IN (343,344,345,346,347,348,349,350,351)

GROUP BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER)

ORDER BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER)