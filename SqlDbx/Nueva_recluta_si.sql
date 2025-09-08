SELECT year(age.FechaAlta) AS Generacion,
		CASE WHEN tec.periodo BETWEEN 201801 AND 201812 THEN 2018
			WHEN tec.periodo BETWEEN 201901 AND 201912 THEN 2019
			WHEN tec.periodo BETWEEN 202001 AND 202012 THEN 2020
			WHEN tec.periodo BETWEEN 202101 AND 202112 THEN 2021
			WHEN tec.periodo BETWEEN 202201 AND 202212 THEN 2022
			WHEN tec.periodo BETWEEN 202301 AND 202312 THEN 2023
			END AS Anio,
		 
		
		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		sum(tec.Ocurrido) AS Ocurrido, 
		sum(tec.UnidadesExpuestasMes) AS Expuestas,
		sum(tec.NumSiniestro) AS Siniestros


FROM ( SELECT * FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
		WHERE emi.nipPerfilagente IN ( SELECT ageII.nipperfilagente 
										FROM  tb_bi_dimagente AS ageII
										where ageII.IdTipoAgente=19 
										AND ageII.NuevaRecluta=1
										AND ageII.FechaAlta>='2018-01-01')) AS base

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=base.NumCompletoCotizacion
AND tec.NumDocumento=base.NumDocumento
AND tec.Periodo>=201801

inner JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NipPerfilAgente
AND age.IdTipoAgente=19 
AND age.NuevaRecluta=1
AND age.FechaAlta>='2018-01-01'

GROUP BY year(age.FechaAlta),
		CASE WHEN tec.periodo BETWEEN 201801 AND 201812 THEN 2018
			WHEN tec.periodo BETWEEN 201901 AND 201912 THEN 2019
			WHEN tec.periodo BETWEEN 202001 AND 202012 THEN 2020
			WHEN tec.periodo BETWEEN 202101 AND 202112 THEN 2021
			WHEN tec.periodo BETWEEN 202201 AND 202212 THEN 2022
			WHEN tec.periodo BETWEEN 202301 AND 202312 THEN 2023
			END