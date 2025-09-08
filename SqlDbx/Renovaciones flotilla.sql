SELECT --tec.Periodo,
		emi.NipPerfilAgente,
		emi.IdOficina,
		emi.NumPoliza,
		emi.NumCertificado,
		pol.DescTipoPoliza,
		aseg.NombreAsegurado,
		aseg.NipAgrupador,
		--emi.FechaEmision,
		--emi.FechaInicioVigencia,
		emi.FechaFinVigencia,
		
		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		sum(tec.UnidadesEmitidasReales) AS Unidades,
		sum(tec.Ocurrido) AS Ocurrido,
		sum(tec.UnidadesExpuestasMes) AS UniExp
		
		


FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
--AND tec.Periodo>=202210

LEFT JOIN tb_bi_dimtipopoliza AS pol
ON pol.IdTipoPoliza=emi.IdTipoPoliza

LEFT JOIN tb_bi_dimasegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado

INNER JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

WHERE 	emi.FechaFinVigencia BETWEEN '20231001' AND '20241231'
AND emi.IdTipoPoliza!=4013

--WHERE emi.IdOficina=3
--AND emi.NumPoliza=390016


GROUP BY --tec.Periodo,
		emi.NipPerfilAgente,
		emi.IdOficina,
		emi.NumPoliza,
		emi.NumCertificado,
		pol.DescTipoPoliza,
		aseg.NombreAsegurado,
		aseg.NipAgrupador,
		--emi.FechaInicioVigencia,
		emi.FechaFinVigencia
		--emi.FechaEmision

ORDER BY 	emi.IdOficina,
		emi.NumPoliza