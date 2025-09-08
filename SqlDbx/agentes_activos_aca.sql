SELECT aux.NombreOficinaComercial,
		count(DISTINCT(aux.NombreAgente)) AS agentes
		
FROM (

	SELECT ofi.NombreOficinaComercial, age.NombreAgente,
			--count(DISTINCT(age.NombreAgente)) AS agentes,
			sum(aca.PrimaNetaEmitida) AS Emitida
			
		  
	
	FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca
	
	INNER JOIN (
	
			SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
			
			FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
			
			
			GROUP BY aca2.NipAgente
			
			) AS aux
			
	ON aux.NipAgente=aca.NipAgente
	AND aux.IdDespacho=aca.IdDespacho
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=aca.NipPerfilAgente
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
			
	
	WHERE aca.Periodo BETWEEN 202301 AND 202312
	AND aca.IdGpoBono IN (198,199,201,204,933, 727, 728)
	AND age.IdTipoAgente NOT IN (641,20)
	AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
	AND age.IdOficina !=0
	
	GROUP BY  ofi.NombreOficinaComercial, age.NombreAgente
	
	
	HAVING 	sum(aca.PrimaNetaEmitida)>0
	
) AS aux

GROUP BY aux.NombreOficinaComercial