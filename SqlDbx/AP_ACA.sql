SELECT  aca.IdOficina,
		sum(aca.PrimaNetaEmitida) AS Emitida

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho

WHERE aca.Periodo =202301
AND aca.IdGpoBono IN (198)
--AND aca.IdOficina IN (614,84)

GROUP BY aca.IdOficina