SELECT LEFT(emicob.FechaTransaccion,6) AS Periodo,
		--emi.IdOficina,
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		age.DescCanalComercial,
	   
		
		round(sum(emicob.PrimaNeta),0) AS Emitida



FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=age.IdOficina


WHERE emicob.FechaTransaccion BETWEEN 20240101 AND 20241112 --aquí mueven el día


GROUP BY LEFT(emicob.FechaTransaccion,6),
		--emi.IdOficina,
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		age.DescCanalComercial
		
ORDER BY round(sum(emicob.PrimaNeta),0) desc
			