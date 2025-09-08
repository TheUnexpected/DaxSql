 SELECT eo.*, zona.*, ofi.*
 
FROM tb_bi_dimoficina AS ofi
 
LEFT JOIN tb_bi_dimzonacontable AS zona

ON zona.ZonaContable=ofi.ZonaContable
 
LEFT JOIN dbo.TB_BI_DimEstadoOficina AS eo

ON eo.ZonaContable=zona.ZonaContable
 