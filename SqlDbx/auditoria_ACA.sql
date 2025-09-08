SELECT --aca.IdDespacho, 
		aca.Periodo, 
		aca.IdGpoBono, 
		aca.NipPerfilAgente,
		concat(age.NipPerfilAgente,' - ',age.NombreAgente) AS Agente,
		bono.DescGpoBono,
		
		CASE WHEN Periodo=202301 THEN 'Enero'
		WHEN Periodo=202304 THEN 'Abril'
		WHEN Periodo=202302 THEN 'Febrero'
		WHEN Periodo=202303 THEN 'Marzo'
		WHEN Periodo=202305 THEN 'Mayo'
		WHEN Periodo=202306 THEN 'Junio'
		WHEN Periodo=202307 THEN 'Julio'		
		WHEN Periodo=202308 THEN 'Agosto'		
		WHEN Periodo=202309 THEN 'Septiembre'		
		WHEN Periodo=202310 THEN 'Octubre'		
		WHEN Periodo=202311 THEN 'Noviembre'			
		WHEN Periodo=202312 THEN 'Diciembre' 
		END AS mes,
		
		--sum(aca.PrimaNetaEmitida) AS emitida,
		--sum(aca.PrimaNetaPagada) AS pagada, 
		--sum(aca.PrimaNetaProduccion) AS produccion,
		sum(aca.PrimaNetaDevengadaRolling) AS Devengada_R12,
		sum(aca.SiniestrosRolling) AS Ocurrido_R12
	   --	sum(aca.SiniestrosRolling)/sum(aca.PrimaNetaDevengadaRolling)  AS Siniestralidad
		--sum(aca.PrimaNetaProduccionRolling) AS Prod_R12,
		--sum(aca.PrimaNetaPagadaAcumulada) AS Pagada_acumulada
		--sum(aca.PrimaNetaDevengada) AS Dev

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

INNER JOIN (

		SELECT aca2.NipAgente, max(aca2.IdDespacho) AS IdDespacho
		
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca2
		
		
		GROUP BY aca2.NipAgente
		
		) AS aux
		
ON aux.NipAgente=aca.NipAgente
AND aux.IdDespacho=aca.IdDespacho
		

LEFT JOIN TB_BI_DimAgente AS age
ON age.NipPerfilAgente=aca.NipPerfilAgente

LEFT JOIN tb_bi_dimgpobono AS bono
ON bono.IdGpoBono=aca.IdGpoBono

--WHERE aca.Periodo BETWEEN 202301 AND 202312
WHERE aca.periodo=202312
--AND aca.IdGpoBono IN (198,199,201,204,933)
AND aca.NipPerfilAgente IN (105018,105354,105952,106125,101029,105952,101029,99312,101029,102292,102162,102161,104617,91821,69323,102204,103299,69927,97711,98306,95436)

GROUP BY  --aca.IdDespacho, 
		aca.Periodo, aca.IdGpoBono, aca.NipPerfilAgente, --aca.NipPerfilAgente,
		concat(age.NipPerfilAgente,' - ',age.NombreAgente),
		bono.DescGpoBono,
		CASE WHEN Periodo=202301 THEN 'Enero'
		WHEN Periodo=202304 THEN 'Abril'
		WHEN Periodo=202302 THEN 'Febrero'
		WHEN Periodo=202303 THEN 'Marzo'
		WHEN Periodo=202305 THEN 'Mayo'
		WHEN Periodo=202306 THEN 'Junio'
		WHEN Periodo=202307 THEN 'Julio'		
		WHEN Periodo=202308 THEN 'Agosto'		
		WHEN Periodo=202309 THEN 'Septiembre'		
		WHEN Periodo=202310 THEN 'Octubre'		
		WHEN Periodo=202311 THEN 'Noviembre'			
		WHEN Periodo=202312 THEN 'Diciembre' 
		END