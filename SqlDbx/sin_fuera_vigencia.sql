SELECT *

FROM (   

	SELECT recl.NumReclamo,
			--convert(DATETIME,CAST(cob.FechaMovimiento AS VARCHAR)) AS Fecha_Movimiento,
			convert(DATEtime,emi.FechaFinVigencia) AS Fecha_Fin_Vigencia,
			convert(DATETIME,emi.FechaInicioVigencia) AS Fecha_Inicio_Vigencia,
			age.NombreAgente,
			recl.TiempoOcurrencia,
			recl.NumCotizacion,
			recl.NumDocumento, 
			recl.IdOficinaEmision,
			recl.NumPoliza, 
			recl.NumCertificado, 
			recl.NumCompletoCotizacion, 
			pag.TiempoAplicacionPago,
			pag.ImporteNetoPago
	
	
	FROM dwh.Tb_BI_GrlSinReclamo AS recl
	
	
	LEFT JOIN DMSin.Tb_BI_AutSinPagos AS pag
	ON pag.NumReclamo=recl.NumReclamo
	AND pag.IdLineaNegocio=4
	
	LEFT JOIN TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=recl.NumCompletoCotizacion
	AND emi.NumDocumento=recl.NumDocumento
	AND emi.NumCertificado=recl.NumCertificado
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	
	
	WHERE recl.IdLineaNegocio=4
	AND recl.TiempoOcurrencia BETWEEN '2024-01-01' AND '2024-12-31'
	
) AS base

WHERE base.TiempoOcurrencia not between base.Fecha_Inicio_Vigencia AND base.fecha_fin_Vigencia