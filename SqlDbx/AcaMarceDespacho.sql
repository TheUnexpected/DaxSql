SELECT aca.IdDespacho, aca.Periodo, aca.IdGpoBono, aca.NipAgente,
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada, 
		sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		sum(aca.PrimaNetaProduccionRolling) AS Prod_R12
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

WHERE aca.Periodo BETWEEN 202201 AND 202311
AND aca.IdGpoBono IN (198,199,201,204,933)

GROUP BY  aca.IdDespacho, aca.Periodo, aca.IdGpoBono, aca.NipAgente