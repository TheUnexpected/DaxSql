SELECT isnull(t_emi.Periodo,isnull(t_riesgos.Periodo, isnull(t_dev.Periodo,t_sin.Periodo)) )AS Periodo,
		isnull(t_emi.NipPerfilAgente, isnull(t_riesgos.NipPerfilAgente, isnull( t_dev.NipPerfilAgente,t_sin.NipPerfilAgente))) AS NipPerfilAgente,
		isnull(t_emi.Emitida,0) AS Emitida,
		isnull(t_riesgos.Riesgos,0) AS Riesgos,
		isnull(t_dev.Dev,0) AS Devengada,
		isnull(t_dev.Expuestas_mes,0) AS Exp_mes,
		isnull(t_dev.Expuestas,0) AS Expuestas,
		isnull(t_sin.Ocurrido,0) AS Ocurrido,
		isnull(t_sin.Siniestros,0) AS Siniestros
		

FROM (
	SELECT turi.Periodo,
			turi.NipPerfilAgente,
			
			sum(turi.PrimaNeta) AS Emitida --cuadra con cubos
			
	FROM VW_BI_AuttFactEmision turi
	
	WHERE turi.Periodo BETWEEN 202301 AND 202412
	
	GROUP BY turi.Periodo,
			turi.NipPerfilAgente
			
	) AS t_emi
	
FULL JOIN (

	SELECT turi_v.Periodo,
			turi_v.NipPerfilAgente,
	
			sum(RiesgoVigente) AS Riesgos --cuadra con cubos
	
	FROM VW_BI_AuttFactCisVigentes AS turi_v
	
	WHERE turi_v.Periodo BETWEEN 202301 AND 202412
	
	GROUP BY turi_v.Periodo,
			turi_v.NipPerfilAgente
	
	) AS t_riesgos
	
ON t_emi.Periodo=t_riesgos.Periodo
AND t_emi.NipPerfilAgente=t_riesgos.NipPerfilAgente
		

FULL JOIN (

	SELECT turi_dev.Periodo,
			turi_dev.NipPerfilAgente,
	
			sum(turi_dev.PrimaNetaEmitidaDevengada) AS Dev, --cuadra con cubos
			sum(turi_dev.UnidadesExpuestasMes) AS Expuestas_Mes,--cuadra con cubos
			sum(turi_dev.UnidadesExpuestas) AS expuestas
			
	FROM VW_BI_AuttFactEmisionDevMes turi_dev
	
	WHERE Periodo BETWEEN 202301 AND 202412

	
	GROUP BY turi_dev.Periodo,
			turi_dev.NipPerfilAgente
			
	) AS t_dev
	
ON t_emi.Periodo=t_dev.Periodo
AND t_emi.NipPerfilAgente=t_dev.NipPerfilAgente

FULL JOIN (

	SELECT turi_sin.Periodo,
			turi_sin.NipPerfilAgente,
			--sum(turi_sin.Monto) AS monto, 
			sum(turi_sin.Ocurrido) AS Ocurrido, -- cuadra con cubos
			--sum(turi_sin.CostoSiniestroOcurrido) AS Costo_Ocurrido, 
			sum(turi_sin.Siniestro) AS Siniestros -- cuadra con cubos
			
	FROM VW_BI_AuttFactReserva turi_sin
	
	WHERE turi_sin.Periodo BETWEEN 202301 AND 202412
	
	GROUP BY turi_sin.Periodo,
			turi_sin.NipPerfilAgente
	) AS t_sin
	
ON t_emi.Periodo=t_sin.Periodo
AND t_emi.NipPerfilAgente=t_sin.NipPerfilAgente