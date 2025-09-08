SELECT  sol.*,
	otmas.*,
	cat.Descripcion,
	esta.Descripcion AS Estatus,
	origot.DescOrigenOT AS OrigenOT,
	rech.DescCausaRechazoOT


From DWH.TB_BI_GrlFactOTSolicitud AS sol

LEFT JOIN Cv360.Tbl_CatTipoDocumentoOT AS cat
ON cat.IdTipoDocumento  = sol.IdTipoDocumento
	
LEFT JOIN Cv360.Tbl_CatEstatusOT AS esta
ON esta.IdEstatus=sol.IdEstatus
	
LEFT JOIN TB_BI_DimOrigenOT AS origot
ON origot.IdOrigenOt=sol.IdOrigenOT
	
LEFT JOIN TB_BI_DimCausaRechazoOT AS rech
ON rech.IdCausaRechazoOT=sol.IdCausaRechazo

LEFT JOIN DWH.Tb_bi_GrlOTComplementoMasivo AS otmas
ON otmas.IdOT=sol.IdOT
	

WHERE  sol.IdLineaNegocio=6
--AND sol.IdEstatus=3859
--AND sol.TiempoAltaOt>='2023-01-01'
--AND sol.EsEmision=1
AND sol.IdOT IN (445013) 