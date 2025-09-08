SELECT --CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
	   	paq.DescPaquete,
	   
		
		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

inner JOIN TB_BI_DimPaquete AS paq
ON paq.IdPaquete=emi.IdPaquete
AND emi.IdPaquete IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610)

--AND paq.DescPaquete LIKE '%IDRIVING%'

WHERE emicob.FechaTransaccion BETWEEN 20230101 AND 20230930

GROUP BY --CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER),
		 paq.DescPaquete	
			
			
ORDER BY CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER)