-------------------------------- AUTOS ---------------------------------------------------------
SELECT
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial,
    COUNT(base.agente) 'Agentes Productivos'

FROM (
    Select 
        CASE 
            WHEN tec.periodo = 202401 THEN 'Enero 2024'
            WHEN tec.Periodo = 202501 THEN 'Enero 2025'
        END Periodo,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
        sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'

    FROM TB_BI_AutrFactEmisionDoc aut
        INNER JOIN TB_BI_AutrBase2Tecnica tec
        ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
        AND tec.NumDocumento=aut.NumDocumento
    LEFT JOIN TB_BI_DimAgente age
    ON age.NipPerfilAgente = aut.NipPerfilAgente
    LEFT JOIN TB_BI_DimOficina ofi
    ON ofi.IdOficina = age.IdOficina
    WHERE
        tec.Periodo in (202401, 202501)       -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
        AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales

    GROUP BY
        CASE 
            WHEN tec.periodo = 202401 THEN 'Enero 2024'
            WHEN tec.Periodo = 202501 THEN 'Enero 2025'
        END,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente)
    HAVING
        sum(tec.PrimaNetaPropiaSinCoaseguro) >= 450000 --Agente productivo prima 450000=>
) base
GROUP BY 
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial

----------------------------------------- DAÑOS ----------------------------------------------------------------
SELECT
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial,
    COUNT(base.agente) 'Agentes Productivos'

FROM (
    Select 
        CASE 
            WHEN tec.periodo = 202401 THEN 'Enero 2024'
            WHEN tec.Periodo = 202501 THEN 'Enero 2025'
        END Periodo,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
        sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'
    FROM TB_BI_DanFactEmisionDoc dan
    INNER JOIN TB_DWH_DanBaseTecnica tec
    ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
    AND tec.NumDocumento=dan.NumDocumento
    LEFT JOIN TB_BI_DimAgente age
    ON age.NipPerfilAgente = dan.NipPerfilAgente
    LEFT JOIN TB_BI_DimOficina ofi
    ON ofi.IdOficina = age.IdOficina
    WHERE
        tec.Periodo in (202401, 202501)       -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
        AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales

    GROUP BY
        CASE 
            WHEN tec.periodo = 202401 THEN 'Enero 2024'
            WHEN tec.Periodo = 202501 THEN 'Enero 2025'
        END,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente)
    HAVING
        sum(tec.PrimaNetaPropiaSinCoaseguro) >= 450000 --Agente productivo prima 450000=>
) base
GROUP BY 
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial

--------------------------------- GMM --------------------------------------------------------------------

SELECT 
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial,
    COUNT(base.agente) 'Agentes Productivos' 
FROM(  
    SELECT 
        CASE 
            WHEN gmm.periodo = 202401 THEN 'Enero 2024'
            WHEN gmm.Periodo = 202501 THEN 'Enero 2025'
        END Periodo,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',    
        sum(gmm.Prima_Total) AS 'Prima Emitida'
    FROM Dshd.VW_DWH_GMMPrimaNeta gmm
    LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
    LEFT JOIN TB_BI_DimOficina ofi
    ON ofi.IdOficina = age.IdOficina
    WHERE
    gmm.Periodo in (202401, 202501)    -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
    AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales
    GROUP BY
        CASE 
            WHEN gmm.periodo = 202401 THEN 'Enero 2024'
            WHEN gmm.Periodo = 202501 THEN 'Enero 2025'
        END,
        ofi.DescDireccionComercial,
        ofi.NombreOficinaComercial,
        CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)
    HAVING
        sum(gmm.Prima_Total) >= 450000
) base
GROUP BY 
    base.Periodo,
    base.DescDireccionComercial,
    base.NombreOficinaComercial

SELECT distinct DescDireccionComercial, IdDireccionComercial  FROM TB_BI_DimOficina