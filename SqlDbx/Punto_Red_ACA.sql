SELECT 	age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		ofi.IdOficina,
		aca.periodo,
		bono.DescGpoBono,
		
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada
		
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=aca.idoficina


LEFT JOIN TB_BI_DimAgente AS age 
ON age.NipPerfilAgente=aca.nipperfilagente

LEFT JOIN tb_bi_dimgpobono AS bono
ON bono.IdGpoBono=aca.idgpobono

WHERE (ofi.IdOficina=926  OR age.NipPerfilAgente IN (108567,109547,109593,94743,105378,95339,105379,109358))
AND aca.Periodo>=202401
AND aca.idgpobono IN (199,201,204,933)

GROUP BY age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		ofi.IdOficina,
		aca.periodo,
		bono.DescGpoBono
		