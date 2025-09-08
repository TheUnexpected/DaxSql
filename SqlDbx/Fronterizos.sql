SELECT emi.NipPerfilAgente,
		
	     sum(emicob.PrimaNeta) AS Emitida_Autos
	   
FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento	


INNER JOIN VW_BI_DimVehiculo AS vehi
ON vehi.IdVehiculoInterno=emi.IdVehiculo
AND vehi.DescMarcaVehiculo IN ('REGULARIZADO','FRONTERIZO')

WHERE emicob.FechaTransaccion BETWEEN 20240101 AND 20241231 
AND emi.IdTipoVehiculo IN (3830,4579,3829) --camiones hasta 3.5, pick ups, autos residentes


GROUP BY emi.NipPerfilAgente

ORDER BY sum(emicob.PrimaNeta) desc
			