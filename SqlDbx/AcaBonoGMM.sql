SELECT aca.NipAgente, 
		--aca.NipPerfilAgente, 	
		aca.Periodo, 
		aca.IdGpoBono,
		
		--max(aca.IdDespacho),
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada, 
		sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengada) AS Devengada,
		sum(aca.Siniestros) AS Ocurrido

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

WHERE aca.Periodo BETWEEN 202301 AND 202311
AND aca.IdGpoBono IN (727, 728)
--AND aca.NipAgente=64226
--AND aca.IdGpoBono=199


GROUP BY  aca.NipAgente, 
		--aca.NipPerfilAgente,
		aca.Periodo, 
		aca.IdGpoBono