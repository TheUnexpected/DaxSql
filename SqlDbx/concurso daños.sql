SELECT  cast(left(emicob.FechaTransaccion,6) as integer) as Periodo,
		prod.GrupoClasificacion,
		ramo.DescripcionRamo,
		ramo.RamoTecnico,
		
		sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Pesos
      
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

LEFT JOIN TB_BI_DimClasificacionProductos AS prod
ON prod.IdClasificacionProducto=emi.IdClasificacionProducto
AND prod.IdSubclasificacionProducto=emi.IdSubclasificacionProducto


left JOIN TB_BI_DimGrlRamos  AS ramo
ON ramo.IdRamo=emicob.ClaveRamo
AND ramo.IdSubRamo=emicob.ClaveSubRamo
AND trim(ramo.LineaNegocio)='DAN'


WHERE emicob.FechaTransaccion BETWEEN 20190101 AND 20241130


GROUP BY cast(left(emicob.FechaTransaccion,6) as integer),
		prod.GrupoClasificacion,
		ramo.DescripcionRamo,
		ramo.RamoTecnico

--having sum(emicob.PrimaNeta*tc.TipoCambio)<>0