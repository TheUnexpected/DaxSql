SELECT CAST (LEFT(tec.Periodo,4) AS INTEGER) AS Anio,
			--round(sum(tec.RiesgoVigente),0) AS Riesgos
			count(distinct(tec.numcompletocotizacion)) AS Riesgos2

FROM( SELECT *
 		FROM HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec2
 		WHERE tec2.Periodo IN (201912,202012,202112,202212,202312)
		AND tec2.RiesgoVigente=1)
		
AS tec

LEFT join TB_BI_AutrFactEmisionCob AS emicob
ON emicob.NumCompletoCotizacion=tec.NumCompletoCotizacion
AND emicob.NumDocumento=tec.NumDocumento

INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4
--AND cob.DescGrupoCobertura IN ('DAÑOS MATERIALES','ROBO TOTAL')
AND cob.DescGrupoCobertura IN ('RESPONSABILIDAD CIVIL')

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento



where emi.IdOficina IN (343,344,345,346,347,348,349,350,351)

GROUP BY CAST (LEFT(tec.Periodo,4) AS INTEGER)

ORDER BY CAST (LEFT(tec.Periodo,4) AS INTEGER)