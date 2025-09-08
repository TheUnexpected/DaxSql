SELECT CAST(LEFT(turi.Periodo,4) AS INTEGER) AS Anio,
		--ofi.NombreOficinaComercial, 
		--age.IdOficina,
		--turi.IdOficina,

		sum(turi.PrimaNeta) AS neta
		
FROM VW_BI_AuttFactEmision turi



LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=turi.NipPerfilAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina


WHERE turi.Periodo BETWEEN 201701 AND 202012

GROUP BY CAST(LEFT(turi.Periodo,4) AS INTEGER)
		--ofi.NombreOficinaComercial
		--age.IdOficina,
		--turi.IdOficina