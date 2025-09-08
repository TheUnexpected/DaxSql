SELECT tec.UnidadesEmitidasReales,
		emi.NumPoliza,
		vehi.DescSubMarcaVehiculo,
		doc.DescTipoDocumento,
		doc.DescGrupoDocumento,
		doc.DescTipoMovimiento,
		emi.FechaInicioVigencia,
		emi.FechaFinVigencia
		

FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi


INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.UnidadesEmitidasReales!=0
AND tec.UnidadesEmitidasReales IS NOT NULL

LEFT JOIN VW_BI_DimVehiculo AS vehi 
ON vehi.IdVehiculoInterno=emi.IdVehiculo

LEFT JOIN TB_BI_DimTipoDocumento AS doc
ON doc.IdTipoDocumento=emi.IdTipoDocumento


WHERE emi.CveAsegurado='00|BALE671107'

ORDER BY emi.FechaTransaccion
