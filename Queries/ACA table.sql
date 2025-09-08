SELECT aca.NipAgente, 
		--aca.NipPerfilAgente, 	
		aca.Periodo, 
		aca.IdGpoBono,
		
		--max(aca.IdDespacho),
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada, 
		sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		sum(aca.PrimaNetaProduccionRolling) AS Prod_R12
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

WHERE aca.Periodo BETWEEN 202506 AND 202506
AND aca.IdGpoBono IN (198,199,201,204,933,727,728,608,609)
--AND aca.NipAgente=64226
--AND aca.IdGpoBono=199


GROUP BY  aca.NipAgente, 
		--aca.NipPerfilAgente,
		aca.Periodo, 
		aca.IdGpoBono

------------------------------------------------------------------
SELECT aca.IdDespacho, aca.Periodo, aca.IdGpoBono, aca.NipAgente,
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada, 
		sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		sum(aca.PrimaNetaProduccionRolling) AS Prod_R12
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

WHERE aca.Periodo BETWEEN 202506 AND 202506
AND aca.IdGpoBono IN (198,199,201,204,933)

GROUP BY  aca.IdDespacho, aca.Periodo, aca.IdGpoBono, aca.NipAgente
---------------------------------------------------------------------
SELECT aca.NipAgente, 
		--aca.NipPerfilAgente, 	
		aca.Periodo, 
		aca.IdGpoBono,
		
		--max(aca.IdDespacho),
		sum(aca.PrimaNetaEmitida) AS emitida,
		sum(aca.PrimaNetaPagada) AS pagada, 
		sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12,
		sum(aca.PrimaNetaProduccionRolling) AS Prod_R12
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada

FROM dbo.VW_BI_GrlInfoModuloxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

WHERE aca.Periodo BETWEEN 202506 AND 202506
AND aca.IdGpoBono IN (198,199,201,204,933)



GROUP BY  aca.NipAgente, 
		--aca.NipPerfilAgente,
		aca.Periodo, 
		aca.IdGpoBono

SELECT * FROM 

SELECT 
	ofi.nombreoficinacomercial,
	rfc,
	age.DescEstatusAgente,
	age.DescEstatusPerfil,
	FechaAlta
FROM TB_BI_DimAgente age
	INNER JOIN TB_BI_DimOficina ofi
	on age.IdOficina = ofi.IdOficina
WHERE age.NipAgente = 114589