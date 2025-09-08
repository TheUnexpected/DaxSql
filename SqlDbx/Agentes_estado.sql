SELECT  
		est.DescEstado as estado,
		count(DISTINCT age.NombreAgente) AS agentes

FROM TB_BI_DimAgente AS age

--INNER JOIN TB_BI_dimTipoAgente AS tage
--ON tage.IdTipoAgente=age.IdTipoAgente
--AND tage.IdTipoAgente=19

LEFT JOIN VW_BI_DimEstados AS est
ON age.IdEstado=est.IdEstado



WHERE age.DescEstatusAgente='VIGOR'
AND age.NombreAgente NOT LIKE '%HDI%'
AND age.IdTipoAgente=19
AND age.FechaAlta<='2023-01-31'
AND est.DescEstado NOT IN ('OTROS')


GROUP BY est.DescEstado