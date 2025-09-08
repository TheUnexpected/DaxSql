SELECT CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
		aseg.NombreEstado,
		clas.GrupoClasificacion AS DescGrupoTipoPoliza,
	
		sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta



FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento


LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado

LEFT JOIN TB_BI_DimClasificacionProductos AS clas
ON clas.IdClasificacionProducto=emi.IdClasificacionProducto
AND clas.IdSubclasificacionProducto=emi.IdSubclasificacionProducto


WHERE emicob.FechaTransaccion BETWEEN 20190101 AND 20231231

GROUP BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		aseg.NombreEstado,
		clas.GrupoClasificacion