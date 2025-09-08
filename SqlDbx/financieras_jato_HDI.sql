SELECT 
    tec.Periodo,
    emi.IdOficina,
	Doc.DescTipoDocumento,
    emi.ModeloVehiculo,
    vehi.DescCarroceriaVehiculo,
    vehi.DescMarcaVehiculo,
    page.Prorgama,
    emi.FechaInicioVigencia,
    emi.FechaInicioVigenciaContrato, 
	aseg.NombreEstado AS Estado_Cliente,

    
    sum(tec.UnidadesEmitidasReales) AS unidadesEmitidasReales 

FROM HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi 

INNER JOIN TB_Bi_AutrBase2Tecnica AS tec 
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.Periodo>=202001 

INNER JOIN TB_BI_DimTipoDocumento AS Doc 
ON emi.IdTipoDocumento=doc.IdTipoDocumento
AND Doc.IdTipoDocumento=21

LEFT JOIN VW_BI_DimVehiculo AS Vehi 
ON emi.IdVehiculo=vehi.IdVehiculoInterno 

LEFT JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
ON emi.NipPerfilAgente=page.NipPerfilAgente
 

inner JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina
AND ofi.IdDireccionComercial=26859

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado

GROUP BY  tec.Periodo,
    emi.IdOficina,
    doc.DescTipoDocumento,
    emi.ModeloVehiculo,
    vehi.DescCarroceriaVehiculo,
    vehi.DescMarcaVehiculo,
    page.Prorgama,
    emi.FechaInicioVigencia,
    emi.FechaInicioVigenciaContrato,
	aseg.NombreEstado

HAVING sum(tec.UnidadesEmitidasReales)!=0