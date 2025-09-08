SELECT koki.IdOficina,
        koki.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza AS producto,
        'Autos' AS Ramo ,   
                   
        sum(koki.PrimaEmitida) AS Emitida,
        sum(koki.PrimaDevengada) AS Devengada,
        sum(koki.Ocurrido) AS Ocurrido 

FROM (

     SELECT
             emi.IdOficina,
             emi.NipPerfilAgente,
             emi.IdTipoPoliza,
             sum(Tec.PrimaNetaPropiaSinCoaseguro)AS PrimaEmitida,
             sum(tec.PrimaNetaPropiaEmitidaDevengada)AS PrimaDevengada,
             sum(Tec.Ocurrido)AS Ocurrido
                   
    FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS Emi

    INNER JOIN hdi_dwh.dbo.Tb_Bi_AutrBase2Tecnica AS Tec
    ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
    AND tec.NumDocumento=emi.NumDocumento
    AND Tec.Periodo BETWEEN 202301 AND 202312

    GROUP BY emi.IdOficina,
             emi.NipPerfilAgente,
             emi.IdTipoPoliza

    ) AS koki

 
LEFT JOIN Hdi_Dwh.dbo. TB_BI_DimTipoPoliza AS tpol
ON koki.idtipopoliza=tpol.idtipopoliza

left JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=koki.IdOficina


GROUP BY koki.IdOficina,
        koki.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza

 
UNION ALL 

SELECT  
        aux.IdOficina,
        aux.NipPerfilAgente,
        clasi.GrupoClasificacion AS producto,  
        'Daños' AS Ramo, 

        sum(aux.PrimaEmitida) AS Emitida,
        sum(aux.PrimaDevengada) AS Devengada,
        sum(aux.Ocurrido) AS Ocurrido

FROM (
        SELECT
                Emi.IdOficina,
                Emi.NipPerfilAgente,
                emi.IdClasificacionProducto,
                emi.IdSubclasificacionProducto,

                 sum(Tec.PrimaNetaPropiaSinCoaseguro)AS PrimaEmitida,
                 sum(tec.PrimaNetaPropiaEmitidaDevengada)AS PrimaDevengada,
                 sum(Tec.Ocurrido)AS Ocurrido

        FROM HDI_DWH.dbo.TB_BI_danFactEmisionDoc AS Emi

        INNER JOIN hdi_dwh.dbo.Tb_Bi_danBase2Tecnica AS Tec
        ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
        AND tec.NumDocumento=emi.NumDocumento
        AND Tec.Periodo BETWEEN 202301 AND 202312

        group BY 
                   Emi.IdOficina,
                Emi.NipPerfilAgente,
                emi.IdClasificacionProducto,
                emi.IdSubclasificacionProducto

 

) AS aux

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=aux.IdOficina

LEFT JOIN TB_BI_DimClasificacionProductos AS Clasi
ON aux.IdClasificacionProducto=clasi.IdClasificacionProducto
AND aux.IdSubclasificacionProducto=clasi.IdSubclasificacionProducto

GROUP BY 
        aux.IdOficina,
        clasi.GrupoClasificacion,
        aux.NipPerfilAgente
        