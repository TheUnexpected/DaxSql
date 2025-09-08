SELECT ofi.NombreOficinaComercial,
		count(DISTINCT(age.NombreAgente)) AS agentes


FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

where age.IdTipoAgente NOT IN (641,20)
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
AND age.IdOficina !=0

GROUP BY ofi.NombreOficinaComercial