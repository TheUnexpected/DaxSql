SELECT emi.IdOficina, 
		emi.numpoliza, 
		emi.NumCertificado, 
		emi.NumDocumento,
		emi.IdTipoDocumento, 
		doc.DescTipoMovimiento,
		doc.DescGrupoDocumento,
		doc.DescTipoDocumento,
		emi.FechaEmision,emi.FechaInicioVigencia, emi.FechaFinVigencia
FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

LEFT JOIN tb_bi_dimtipodocumento AS doc
ON doc.IdTipoDocumento=emi.IdTipoDocumento

WHERE emi.IdOficina=10
AND emi.NumPoliza IN (309150)
AND emi.NumCertificado IN (1)