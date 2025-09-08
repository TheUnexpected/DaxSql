SELECT --age.DescCanalComercial AS Canal,
		--emi.IdOficina AS Oficina,
		tec.Periodo,
		
		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida



FROM  HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi

inner JOIN TB_BI_autrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
AND tec.Periodo BETWEEN 202401 AND 202412

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente

LEFT JOIN tb_bi_dimpaquete AS paq
ON paq.IdPaquete=emi.IdPaquete

WHERE emi.IdPaquete IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610,4034, 4035)

GROUP BY tec.Periodo
		--age.DescCanalComercial
		--emi.IdOficina 