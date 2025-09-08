SELECT --aca.NipAgente, 
		--aca.NipPerfilAgente, 	
		--aca.Periodo, 
		aca.IdOficina,
		aca.IdGpoBono,
		bono.DescGpoBono,
		--aca.IdDespacho,
		--max(aca.IdDespacho),
	   --	sum(aca.PrimaNetaEmitida) AS emitida,
		round(sum(aca.PrimaNetaPagadaRolling),0) AS pagada
		--sum(aca.PrimaNetaProduccion) AS produccion,
		--sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		--sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		--sum(aca.PrimaNetaProduccionRolling) AS Prod_R12
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada
 
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca
 
INNER JOIN (
 
		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2

		GROUP BY aca2.NipAgente
		) AS aux
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
 
LEFT JOIN tb_bi_dimgpobono AS bono
on bono.IdGpoBono=aca.IdGpoBono

 
WHERE aca.Periodo=202310
AND aca.IdGpoBono IN (199,201,204)
AND aca.IdOficina IN (688)

 
 
GROUP BY -- aca.NipAgente, 
		--aca.NipPerfilAgente,
		--aca.Periodo,
		aca.idOficina, 
		aca.IdGpoBono,
		bono.DescGpoBono
		--aca.IdDespacho