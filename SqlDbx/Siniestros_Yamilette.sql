SELECT CAST (LEFT(sincob.FechaMovimiento,4) AS INTEGER) AS Anio,
			count(DISTINCT(sincob.NumReclamo)) AS Siniestros


FROM DMSin.tb_bi_autsinDatoseconomicoscob AS sincob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCoberturaAlborada=sincob.IdCoberturaAlborada
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4
--AND cob.DescGrupoCobertura IN ('DAÑOS MATERIALES','ROBO TOTAL')
AND cob.DescGrupoCobertura IN ('RESPONSABILIDAD CIVIL')

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=sincob.NumCompletoCotizacion
AND emi.NumDocumento=sincob.NumDocumento

WHERE sincob.FechaMovimiento BETWEEN 20190101 AND 20231231
AND emi.IdOficina IN (343,344,345,346,347,348,349,350,351)
AND sincob.IdLineaNegocio=4

GROUP BY CAST (LEFT(sincob.FechaMovimiento,4) AS INTEGER)

ORDER BY CAST (LEFT(sincob.FechaMovimiento,4) AS INTEGER)