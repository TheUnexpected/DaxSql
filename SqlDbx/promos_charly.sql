SELECT aca.NipAgente, 
		aca.Periodo,
		
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		(sum(aca.SiniestrosRolling)/sum(aca.PrimaNetaDevengadaRolling))*100 AS siniestralidad
		

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

WHERE aca.Periodo = 202404
AND aca.IdGpoBono IN (199)
AND aca.NipAgente IN (105729,59913)



GROUP BY  aca.NipAgente,
		aca.Periodo
		
ORDER BY aca.NipAgente, aca.Periodo