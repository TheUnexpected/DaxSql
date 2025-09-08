SELECT	emi.IdOficina,
	    emi.NumPoliza,
		emi.NipPerfilAgente,
		age.NombreAgente,
		emi.FechaFinVigencia,
		
	     sum(emicob.PrimaNeta) AS Emitida_Autos
	   
FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento	

LEFT JOIN tb_bi_dimasegurado AS ase
ON ase.CveAsegurado=emi.CveAsegurado

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente

WHERE emicob.FechaTransaccion BETWEEN 20250101 AND 20250531--aquí mueven el día
AND emi.IdTipoPoliza!=4013




GROUP BY emi.IdOficina,
	    emi.NumPoliza,
		emi.NipPerfilAgente,
		age.NombreAgente,
		emi.FechaFinVigencia
		
--HAVING sum(emicob.PrimaNeta) !=0
