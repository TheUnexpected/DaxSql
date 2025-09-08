SELECT DISTINCT age.NombreAgente

FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
AND age.IdTipoAgente = 19
AND age.FechaAlta<='2024-05-31'

AND ofi.IdDireccionComercial IN (26862,31690,26861)