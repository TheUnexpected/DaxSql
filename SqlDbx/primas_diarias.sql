SELECT --emicob.NumCompletoCotizacion,
		--LEFT(emicob.FechaTransaccion,4) AS 'Año',
		--left(emicob.FechaTransaccion,6) AS mes,
		emi.IdOficina,
		--ofi.nombreoficinacomercial,
	   -- emi.NumPoliza,
	   --emi.NumPolizaAnterior,
		--ase.NombreAsegurado,
		--ase.EntidadGubernamental,
		--ofi.NombreOficinaComercial,
		--LEFT(emicob.FechaTransaccion,6) AS Periodo,
		--emi.NipPerfilAgente,
		--age.NombreAgente,
	   --	ofi.DescDireccionComercial,
		--ofi.DescSubdireccioncomercial,
		--age.DescCanalComercial,
		--CASE WHEN emi.IdTipoConservacion=0 THEN 'Nueva'
		--ELSE 'Renovado' END AS Conservacion,
		
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

WHERE emicob.FechaTransaccion BETWEEN 20250701 AND 20250731--aquí mueven el día
--AND emi.IdTipoPoliza!=4013
--AND ofi.DescSubdireccionComercial IN ('Mexico Promotorias', 'Mexico Despachos')
--AND ase.NombreAsegurado LIKE '%JET%VAN%'


GROUP BY -- emicob.NumCompletoCotizacion
		--LEFT(emicob.FechaTransaccion,4)
		--left(emicob.FechaTransaccion,6),
		emi.IdOficina
		--ofi.nombreoficinacomercial,
	    --emi.NumPoliza,
	    --emi.NumPolizaAnterior,
		--ase.NombreAsegurado,
		--ase.EntidadGubernamental,
		--ofi.NombreOficinaComercial,
		--LEFT(emicob.FechaTransaccion,6)
		--emi.NipPerfilAgente,
		--age.NombreAgente
		
HAVING sum(emicob.PrimaNeta) !=0
		
--ORDER BY periodo
			