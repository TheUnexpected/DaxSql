SELECT CAST(LEFT(ap.Periodo,4) AS INTEGER) AS Anio,
		--ofi.NombreOficinaComercial, 
		--age.IdOficina,
		--turi.IdOficina,

		sum(ap.PrimaNetaVigencia) AS neta
		
FROM TB_BI_VgcaFactEmisionDoc AS ap



LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=CAST(ap.CliNip AS INTEGER) 

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina


WHERE ap.Periodo BETWEEN 201701 AND 202012

GROUP BY CAST(LEFT(ap.Periodo,4) AS INTEGER)
		--ofi.NombreOficinaComercial
		--age.IdOficina,
		--turi.IdOficina