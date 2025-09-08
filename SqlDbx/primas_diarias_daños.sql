SELECT --left(emicob.FechaTransaccion,4) AS 'Año',
		--emicob.FechaTransaccion,
		--LEFT(emicob.FechaTransaccion,6) AS Periodo,
		emi.IdOficina,
		emi.NumPoliza,
	   	--ase.NombreAsegurado,
		--emi.NipPerfilAgente,
		--age.NombreAgente,
		--emi.IdTipoDocumento,
		--emi.NipAgente,
		--emi.IdMoneda,
		--emi.NumDocumento,
		--ofi.DescDireccionComercial,
		--ofi.DescSubdireccionComercial,
		--age.DescCanalComercial,
		--CASE WHEN emi.NumPolizaAnterior>0 THEN 'Renovado'
		--ELSE 'Nueva' END AS Conservacion,
		
		sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta
		--round(sum(emicob.PrimaNeta),0) AS Prima_Neta--

FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
ON mon.IdMoneda=emi.IdMoneda

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

LEFT JOIN tb_bi_dimasegurado AS ase
ON ase.CveAsegurado=emi.CveAsegurado

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente


WHERE emicob.FechaTransaccion BETWEEN 20250701 AND 20250731 --aquí mueven el día
--AND emi.IdOficina=401
--AND emi.NumPoliza=724
--AND ofi.NombreOficinaComercial = 'Mexicali'

GROUP BY --left(emicob.FechaTransaccion,6),
		--emicob.FechaTransaccion,
		emi.IdOficina,
		emi.NumPoliza
		--ase.NombreAsegurado
		--LEFT(emicob.FechaTransaccion,4) AS Anio,
		--emi.NipPerfilAgente
		--age.NombreAgente
		--emi.IdTipoDocumento
		--emi.NipAgente,
		--emi.IdMoneda,
		--emi.NumDocumento
		--ofi.DescDireccionComercial,
		--ofi.DescSubdireccionComercial,
		--age.DescCanalComercial,
		--CASE WHEN emi.NumPolizaAnterior>0 THEN 'Renovado'
		--ELSE 'Nueva' END AS Conservacion,		
		
--ORDER BY periodo 

--sum(emicob.PrimaNeta*tc.TipoCambio) desc
			