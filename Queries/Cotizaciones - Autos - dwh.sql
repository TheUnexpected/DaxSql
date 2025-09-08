SELECT * FROM Dshd.VW_DWH_GMMPrimaNeta 
where CONVERT(INT, FechaFinVigencia) BETWEEN 20241001 AND 20241231
SELECT * FROM TB_BI_DimAgente

SELECT top 70* FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica

SELECT
    CASE
        WHEN nombreOficinaComercial like '%León%' THEN 'León'
        WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
        WHEN 
            DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
            and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
        WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
        WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
        WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
        WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
        WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
        WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
    END as 'Oficinas Comerciales',
    CASE
        WHEN FechaCotizacion between 20240801 and 20240831 THEN 202408
        WHEN FechaCotizacion between 20240901 and 20240930 THEN 202409
        WHEN FechaCotizacion between 20241001 and 20241031 THEN 202410
    END as 'Periodo',
    COUNT(NumCompletoCotizacion) 'No. Cotizaciones'
FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica cot
    LEFT JOIN TB_BI_DimOFicina AS ofi
		ON ofi.IdOficina = cot.IdOficina
WHERE 
    FechaCotizacion BETWEEN 20240801 and 20241031
GROUP BY 
    CASE
        WHEN nombreOficinaComercial like '%León%' THEN 'León'
        WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
        WHEN 
            DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
            and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
        WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
        WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
        WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
        WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
        WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
        WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
    END,
    CASE
        WHEN FechaCotizacion between 20240801 and 20240831 THEN 202408
        WHEN FechaCotizacion between 20240901 and 20240930 THEN 202409
        WHEN FechaCotizacion between 20241001 and 20241031 THEN 202410
    END