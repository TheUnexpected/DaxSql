DECLARE @R12MES24 NVARCHAR(20) = 'R12 Febrero 2024'
DECLARE @R12MES25 NVARCHAR(20) = 'R12 Febrero 2025'

SELECT
    query.periodo,
    ofi.DescDireccionComercial,
    ofi.DescSubdireccionComercial,
    ofi.NombreOficinaComercial,
    COUNT(query.Agente) 'Agentes Productivos'
FROM(
    SELECT 
        base.Periodo,        
        base.Agente,
        SUM(base.Emitida) 'Emision'
    FROM (
            Select --Tablas de AUTOS
                CASE 
                    WHEN emicob.FechaTransaccion BETWEEN 20230201 AND 20240131 THEN @R12MES24
                    WHEN emicob.FechaTransaccion BETWEEN 20240201 AND 20250131 THEN @R12MES25
                END 'Periodo',
                age.rfc 'Agente',
                round(sum(emicob.PrimaNeta),0) AS 'Emitida'
            FROM TB_BI_AutrFactEmisionCob AS emicob
            INNER JOIN TB_BI_DimCobertura AS cob
            ON cob.IdCobertura=emicob.IdCobertura
            AND cob.DescTipoCobertura='Cobertura Propia'
            AND cob.IdLineaNegocio=4
            LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
            ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
            AND emi.NumDocumento=emicob.NumDocumento      
            LEFT JOIN TB_BI_DimAgente age
            ON emi.NipPerfilAgente = age.NipPerfilAgente
            LEFT JOIN TB_BI_DimOficina ofi
            ON ofi.IdOficina = age.IdOficina
            WHERE
                emicob.FechaTransaccion BETWEEN 20230201 AND 20250131  -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
                --AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales
            GROUP BY
                CASE 
                    WHEN emicob.FechaTransaccion BETWEEN 20230201 AND 20240131 THEN @R12MES24
                    WHEN emicob.FechaTransaccion BETWEEN 20240201 AND 20250131 THEN @R12MES25
                END,
                age.rfc
        UNION ALL
        Select -- Tablas de DAÑOS
                CASE 
                    WHEN tec.Periodo BETWEEN 202302 AND 202401 THEN @R12MES24
                    WHEN tec.Periodo BETWEEN 202402 AND 202501 THEN @R12MES25
                END Periodo,
                age.rfc 'Agente',
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
                tec.Periodo between 202302 and 202501       -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
                --AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales
            GROUP BY
                CASE 
                    WHEN tec.Periodo BETWEEN 202302 AND 202401 THEN @R12MES24
                    WHEN tec.Periodo BETWEEN 202402 AND 202501 THEN @R12MES25
                END,
                age.rfc
        UNION ALL
        SELECT   -- Tablas de GMM 
                CASE 
                    WHEN gmm.Periodo BETWEEN 202302 AND 202401 THEN @R12MES24
                    WHEN gmm.Periodo BETWEEN 202402 AND 202501 THEN @R12MES25
                END Periodo,
                age.rfc 'Agente',    
                sum(gmm.Prima_Total) AS 'Emitida'
            FROM Dshd.VW_DWH_GMMPrimaNeta gmm
            LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
            LEFT JOIN TB_BI_DimOficina ofi
            ON ofi.IdOficina = age.IdOficina
            WHERE
            gmm.Periodo BETWEEN 202302 and 202501    -- Periodo que consulta (enero 2024 = 202401 y enero 2025 = 202501)
            --AND ofi.IdDireccionComercial in (26862,26861,31690)  --Id de las 3 direcciones territoriales
            GROUP BY
                CASE 
                    WHEN gmm.Periodo BETWEEN 202302 AND 202401 THEN @R12MES24
                    WHEN gmm.Periodo BETWEEN 202402 AND 202501 THEN @R12MES25
                END,
                age.rfc
    ) base
    GROUP BY 
        base.Periodo,
        base.Agente
    HAVING 
        SUM(base.Emitida) >= 450000
) query

LEFT JOIN (SELECT rfc, MIN(idoficina) idoficina FROM tb_bi_dimagente GROUP BY rfc) age on age.rfc = query.Agente 
LEFT JOIN TB_BI_DimOficina ofi on ofi.idoficina = age.idoficina

WHERE
    ofi.IdDireccionComercial in (26862,26861,31690)

GROUP BY 
    query.periodo,
    ofi.DescDireccionComercial,
    ofi.DescSubdireccionComercial,
    ofi.NombreOficinaComercial

SELECT * FROM TB_BI_DimDespacho 

SELECT 
    ades.IdDespacho,
    ades.NombreDespacho,
    ades.NipAgente    
FROM TB_BI_DimAgenteDespacho ades
 LEFT JOIN TB_BI_DimDespacho des on ades.IdDespacho = des.IdDespacho
where des.IdEstatusDespacho = 216