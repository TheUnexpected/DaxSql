SELECT CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
	   
	   
		
		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

inner JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento


WHERE emicob.FechaTransaccion BETWEEN 20240901 AND 20240930
--AND emi.IdTipoPoliza=4013
--AND (ofi.DescSubdireccionComercial IN ('Mexico Despachos', 'Mexico Promotorias') OR ofi.NombreOficinaComercial IN ('León Agentes', 'León Despachos', 'León Promotorias')) 

GROUP BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER)
			
ORDER BY CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER)