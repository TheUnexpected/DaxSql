SELECT TEC.Periodo,
        Emi.IdOficina,
        Emi.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza,
        page.Prorgama,
        paq.TipoPropuesto AS Tipo_Paquete,
        doc.DescTipoMovimiento,
        tv.DescTipoVehiculo,
        usov.DescUsoVehiculo,
        vehi.DescCarroceriaVehiculo,
        conserv.DescTipoConservacion,
        
        CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
        		WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
        		WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
        		WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
        		ELSE 'Otros' END AS Tipo_cancelacion,   		

     sum(Tec.PrimaNetaPropiaSinCoaseguro)AS Prima,
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
AND Tec.Periodo>=202101

Left JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
ON emi.NipPerfilAgente=page.NipPerfilAgente

LEFT JOIN Hdi_Dwh.dbo. TB_BI_DimTipoPoliza AS tpol
ON Emi.idtipopoliza=tpol.idtipopoliza

inner JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina
AND ofi.IdDireccionComercial=26859

LEFT JOIN TB_BI_DimPaquete AS paq
ON paq.IdPaquete=emi.IdPaquete

LEFT JOIN TB_BI_DimTipoDocumento AS doc
ON doc.IdTipoDocumento=emi.IdTipoDocumento

LEFT JOIN TB_BI_DimTipoVehiculo AS tv
ON tv.IdTipoVehiculo=emi.IdTipoVehiculo

LEFT JOIN TB_BI_DimUsoVehiculo AS usov
ON usov.IdUsoVehiculo=emi.IdUsoVehiculo

left JOIN VW_BI_DimVehiculo AS vehi 
ON vehi.IdVehiculoInterno=emi.IdVehiculo

LEFT JOIN TB_Bi_DimTipoConservacion AS conserv
ON conserv.IdTipoConservacion=emi.IdTipoConservacion


WHERE Emi.IdClasificacionProducto=1


GROUP BY TEC.Periodo,
        Emi.IdOficina,
        Emi.NipPerfilAgente,
        Tpol.DescGrupoTipoPoliza,
        page.Prorgama,
        paq.TipoPropuesto,
        doc.DescTipoMovimiento,
        tv.DescTipoVehiculo,
        usov.DescUsoVehiculo,
        vehi.DescCarroceriaVehiculo,
        conserv.DescTipoConservacion,
        
           CASE WHEN doc.IdTipoDocumento IN (21,34,42,52,64,91,123,152,153,154,223,351,474,482,503,524,531,553,613) THEN 'Contrato'
        		WHEN doc.IdTipoDocumento IN (104,112,334,372) THEN 'Cancelacion a solicitud'
        		WHEN doc.IdTipoDocumento IN (144,162,194,202) THEN 'Cancelacion automatica'
        		WHEN doc.IdTipoDocumento IN (384,592) THEN 'Cancelacion por siniestro'
        		ELSE 'Otros' END	