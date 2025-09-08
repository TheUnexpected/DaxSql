SELECT  koki.Periodo,
        koki.IdOficina,
        koki.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza,
        --page.Prorgama,
        paq.TipoPropuesto AS Tipo_Paquete,
        doc.DescTipoMovimiento,
        --tv.DescTipoVehiculo,
        --usov.DescUsoVehiculo,
        --vehi.DescCarroceriaVehiculo,
        --conserv.DescTipoConservacion,
        'Autos' AS Ramo,
        clasi.DescSubclasificacionProducto,
        clasi.GrupoClasificacion,       
        CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
                WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
                WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
                WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
                ELSE 'Otros' END AS Tipo_cancelacion, 
                
                   
        sum(koki.PrimaEmitida) AS Emitida,
        sum(koki.ParqueVehicular) AS PV,
        sum(koki.PrimaDevengada) AS Devengada,
        sum(koki.Ocurrido) AS Ocurrido,
        sum(koki.Pagada) AS Pagada,
        sum(koki.Unidades) AS Unidades,
        sum(koki.Tarifa) AS Tarifa,
        sum(koki.PrimaNeta) AS Neta                 

 

     

FROM (

 

     SELECT  tec.Periodo,
             emi.IdOficina,
             emi.NipPerfilAgente,
             emi.IdTipoPoliza,
             emi.IdPaquete,
             emi.IdTipoDocumento,
             --emi.IdTipoVehiculo,
             --emi.IdUsoVehiculo,
             --emi.IdVehiculo,
             emi.IdTipoConservacion,
             emi.IdClasificacionProducto, 
             emi.IdSubclasificacionProducto,
             sum(Tec.PrimaNetaPropiaSinCoaseguro)AS PrimaEmitida,
             sum(tec.RiesgoVigente)AS ParqueVehicular,
             sum(tec.PrimaNetaPropiaEmitidaDevengada)AS PrimaDevengada,
             sum(Tec.Ocurrido)AS Ocurrido,
             sum(tec.PrimaNetaPropiaPagada) AS Pagada,
             sum(tec.UnidadesEmitidasReales) AS Unidades,
             sum(tec.PrimaTarifa) AS Tarifa,
             sum(tec.PrimaNeta) AS PrimaNeta
             
             
    FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS Emi

    INNER JOIN hdi_dwh.dbo.Tb_Bi_AutrBase2Tecnica AS Tec
    ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
    AND tec.NumDocumento=emi.NumDocumento
    AND Tec.Periodo BETWEEN 202108 AND 202308

    GROUP BY tec.Periodo,
             emi.IdOficina,
             emi.NipPerfilAgente,
             emi.IdTipoPoliza,
             emi.IdPaquete,
             emi.IdTipoDocumento,
             --emi.IdTipoVehiculo,
             --emi.IdUsoVehiculo,
             --emi.IdVehiculo,
             emi.IdTipoConservacion,
             emi.IdClasificacionProducto, 
             emi.IdSubclasificacionProducto

    ) AS koki

 

--Left JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
--ON koki.NipPerfilAgente=page.NipPerfilAgente

LEFT JOIN Hdi_Dwh.dbo. TB_BI_DimTipoPoliza AS tpol
ON koki.idtipopoliza=tpol.idtipopoliza

left JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=koki.IdOficina


LEFT JOIN TB_BI_DimPaquete AS paq
ON paq.IdPaquete=koki.IdPaquete

LEFT JOIN TB_BI_DimTipoDocumento AS doc
ON doc.IdTipoDocumento=koki.IdTipoDocumento

--LEFT JOIN TB_BI_DimTipoVehiculo AS tv
--ON tv.IdTipoVehiculo=koki.IdTipoVehiculo

--LEFT JOIN TB_BI_DimUsoVehiculo AS usov
--ON usov.IdUsoVehiculo=koki.IdUsoVehiculo

--left JOIN VW_BI_DimVehiculo AS vehi 
--ON vehi.IdVehiculoInterno=koki.IdVehiculo

--LEFT JOIN TB_Bi_DimTipoConservacion AS conserv
--ON conserv.IdTipoConservacion=koki.IdTipoConservacion

LEFT JOIN TB_BI_DimClasificacionProductos AS Clasi
ON koki.IdClasificacionProducto=clasi.IdClasificacionProducto
AND koki.IdSubclasificacionProducto=clasi.IdSubclasificacionProducto

GROUP BY  koki.Periodo,
        koki.IdOficina,
        koki.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza,
        --page.Prorgama,
        paq.TipoPropuesto,
        doc.DescTipoMovimiento,
        --tv.DescTipoVehiculo,
        --usov.DescUsoVehiculo,
        --vehi.DescCarroceriaVehiculo,
       -- conserv.DescTipoConservacion, 
        clasi.DescSubclasificacionProducto,
        clasi.GrupoClasificacion,     
           
        CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
                WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
                WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
                WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
                ELSE 'Otros' END 

 


UNION ALL 

 

SELECT  aux.Periodo,
        aux.IdOficina,
        aux.NipPerfilAgente,
        'Daños' AS DescGrupoTipoPoliza,
        --page.Prorgama,
        paq.TipoPropuesto AS Tipo_Paquete,
        doc.DescTipoMovimiento,
        --'Daños' AS DescTipoVehiculo,
        --'Daños' AS DescUsoVehiculo,
        --'Daños' AS DescCarroceriaVehiculo,
        --'Daños' AS DescTipoConservacion,
        'Daños' AS Ramo, 
        clasi.DescSubclasificacionProducto,
        clasi.GrupoClasificacion,    
 

        CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
                WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
                WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
                WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
                ELSE 'Otros' END AS Tipo_cancelacion,

 

        sum(aux.PrimaEmitida) AS Emitida,
        sum(aux.ParqueVehicular) AS PV,
        sum(aux.PrimaDevengada) AS Devengada,
        sum(aux.Ocurrido) AS Ocurrido,
        sum(aux.Pagada) AS Pagada,
        sum(aux.Unidades) AS Unidades,
        sum(aux.Tarifa) AS Tarifa,
        sum(aux.PrimaNeta) AS Neta   


FROM (

 

 

        SELECT  Tec.Periodo,
                Emi.IdOficina,
                Emi.NipPerfilAgente,
                emi.IdPaquete,
                emi.IdTipoDocumento,
                emi.IdClasificacionProducto,
                emi.IdSubclasificacionProducto,

 

                 sum(Tec.PrimaNetaPropiaSinCoaseguro)AS PrimaEmitida,
                 sum(tec.RiesgoVigente)AS ParqueVehicular,
                 sum(tec.PrimaNetaPropiaEmitidaDevengada)AS PrimaDevengada,
                 sum(Tec.Ocurrido)AS Ocurrido,
                 sum(tec.PrimaNetaPropiaPagada) AS Pagada,
                 sum(tec.UnidadesEmitidasReales) AS Unidades,
                 sum(tec.PrimaTarifa) AS Tarifa,
                 sum(tec.PrimaNeta) AS PrimaNeta

 

        FROM HDI_DWH.dbo.TB_BI_danFactEmisionDoc AS Emi

 

        INNER JOIN hdi_dwh.dbo.Tb_Bi_danBase2Tecnica AS Tec
        ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
        AND tec.NumDocumento=emi.NumDocumento
        AND Tec.Periodo BETWEEN 202108 AND 202308

 

        group BY Tec.Periodo,
                   Emi.IdOficina,
                Emi.NipPerfilAgente,
                emi.IdPaquete,
                emi.IdTipoDocumento,
                emi.IdClasificacionProducto,
                emi.IdSubclasificacionProducto

 

) AS aux


--Left JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
--ON aux.NipPerfilAgente=page.NipPerfilAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=aux.IdOficina

LEFT JOIN TB_BI_DimPaquete AS paq
ON paq.IdPaquete=aux.IdPaquete

LEFT JOIN TB_BI_DimTipoDocumento AS doc
ON doc.IdTipoDocumento=aux.IdTipoDocumento

LEFT JOIN TB_BI_DimClasificacionProductos AS Clasi
ON aux.IdClasificacionProducto=clasi.IdClasificacionProducto
AND aux.IdSubclasificacionProducto=clasi.IdSubclasificacionProducto

GROUP BY aux.Periodo,
        aux.IdOficina,
        aux.NipPerfilAgente,
        --page.Prorgama,
        paq.TipoPropuesto,
        doc.DescTipoMovimiento, 
        clasi.DescSubclasificacionProducto,
        clasi.GrupoClasificacion,    
 

        CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
                WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
                WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
                WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
                ELSE 'Otros' END