SELECT 
    a.NombreAgente,
    d.FechaAlta,
    d.DescCanalComercial
FROM (
    SELECT DISTINCT NombreAgente
    FROM tb_bi_dimagente
    WHERE NombreAgente IN (
        'GRUPO CIDAR BUSINESS BROKERS AGENTE DE SEGUROS Y DE FIANZAS SA DE CV',
        'FELIPE BALLESTEROS MONTIEL',
        'AARCO AGENTE DE SEGUROS Y DE FIANZAS SA DE CV'
    )
) a
OUTER APPLY (
    SELECT TOP 1 FechaAlta, DescCanalComercial
    FROM tb_bi_dimagente d
    WHERE d.NombreAgente = a.NombreAgente
    ORDER BY FechaAlta DESC
) d;

---------------------------------
SELECT NombreAgente,FechaAlta,DescCanalComercial  FROM tb_bi_dimagente where nombreagente like 'YEON SU SHIN'