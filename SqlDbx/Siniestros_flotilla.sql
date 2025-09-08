SELECT  cob.NumReclamo,
		cob.IdOficinaEmision,
		cob.NumPoliza,
		cob.NumCertificado,
		sinaut.TipoPerdida,
		catm.NombreEstado,
		catm.NombreMunicipio,
		sinaut.UbicacionVehNA,
		sinaut.TipAtencion,
		cau.DescCausaSiniestro,
		tipo.DescTipoSiniestro,
		rep.Conductor,
		rep.EventoReportado,
		evento.Descricpion,
		
		sum(cob.Ocurrido) AS Ocurrido,
		sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
		sum(cob.AjustesSalvamentos)+sum(cob.EstimadoSalvamentos) AS Salvamentos,
		sum(cob.GastosIndirectos) AS Gastos_indirectos,  
		sum(cob.GastosAjuste) AS Gastos_ajustados,
		sum(cob.Reserva) AS Reserva,
		sum(cob.Deducible) AS Deducible
		
FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob

INNER JOIN (


	SELECT DISTINCT emi.NumCompletoCotizacion, emi.NumDocumento
	
	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	INNER JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=emi.IdOficina
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	
	WHERE 	emi.FechaFinVigencia BETWEEN '20231001' AND '20241231'
	AND emi.IdTipoPoliza!=4013

) AS polizas

ON polizas.NumCompletoCotizacion=cob.NumCompletoCotizacion
AND polizas.NumDocumento=cob.NumDocumento

LEFT JOIN DMSin.Tb_BI_AutSinSiniestros sinaut
ON sinaut.NumReclamo=cob.NumReclamo

LEFT JOIN DMSin.Tb_BI_CatMunicipios AS catm
ON catm.IdEstado=sinaut.IdEstadoOcurrencia
AND catm.IdMunicipio=sinaut.IdMunicipioOcurrencia

LEFT JOIN  TB_BI_DimCausaSiniestro AS cau
ON cau.IdCausaSiniestro=sinaut.IdCausaSiniestro

LEFT JOIN DMSin.Tb_BI_CatSinTipoSiniestro tipo
ON tipo.IdTipoSiniestro=sinaut.IdTipoSiniestro

LEFT JOIN  DWH.Tb_BI_GrlSinReporte AS rep
ON rep.NumReclamo=cob.NumReclamo

LEFT JOIN TB_BI_DimSubEvento  AS evento
ON evento.IdSubEvento=rep.IdSubEventoReportado

WHERE cob.IdLineaNegocio=4

GROUP by cob.NumReclamo,
		cob.IdOficinaEmision,
		cob.NumPoliza,
		cob.NumCertificado,
		sinaut.TipoPerdida,
	 	catm.NombreEstado,
		catm.NombreMunicipio,
		sinaut.UbicacionVehNA,
		sinaut.TipAtencion,
		cau.DescCausaSiniestro,
		tipo.DescTipoSiniestro,
		rep.Conductor,
		rep.EventoReportado,
		evento.Descricpion