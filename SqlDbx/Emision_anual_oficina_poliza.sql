SELECT CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
		aseg.NombreEstado,
		poli.DescGrupoTipoPoliza,
 
		
		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado

LEFT JOIN TB_BI_DimTipoPoliza AS poli
ON poli.IdTipoPoliza=emi.IdTipoPoliza

WHERE emicob.FechaTransaccion BETWEEN 20190101 AND 20231231

GROUP BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		aseg.NombreEstado,
		poli.DescGrupoTipoPoliza