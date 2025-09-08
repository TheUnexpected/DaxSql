SELECT ofi.DescSubdireccionComercial, ofi.NombreOficina

FROM TB_BI_DimOficina AS ofi --outer

WHERE ofi.NombreOficina IN
	(SELECT 
	
	FROM TB_BI_AutrFactEmisionDoc AS doc --inner
	
	WHERE doc.IdOficina = ofi.IdOficina
	AND doc.NumPoliza=12345);