SELECT count (DISTINCT age.NombreAgente) AS agentes


FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE age.IdTipoAgente=19
AND ofi.DescDireccionComercial in ('Bajio - Occidente', 'Norte', 'Mexico - Sur')
AND age.DescEstatusAgente='VIGOR'
AND age.DescCanalComercial = 'AGENTES'