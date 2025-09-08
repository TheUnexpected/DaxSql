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
		
		sum(var_cob.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(var_cob.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		sum(var_cob.UnidadesEmitidasReales) AS Unidades,
		sum(var_cob.Ocurrido) AS Ocurrido,
		sum(var_cob.UnidadesExpuestasCobertura) AS UniExpCob,
		sum(var_cob.NumSiniestroCobertura) AS SiniestrosCob
		
		
FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN  TB_BI_AutrVariablesPorCobertura AS var_cob
ON var_cob.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND var_cob.NumDocumento=emi.NumDocumento
AND var_cob.IdCobertura IN (345,236,349) -- Coberturas Robo total
	

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