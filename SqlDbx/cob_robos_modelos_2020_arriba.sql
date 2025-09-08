SELECT emi2.IdOficina,
		emi2.ModeloVehiculo,
		clas.GrupoClasificacion,
		emi2.Periodo,
		tv.DescCarroceriaVehiculo,
		est.NombreEstado,
		
		sum(emi2.UnidadesExpuestasCobertura) AS U_Expuestas,
		sum(emi2.NumSiniestroCobertura) AS Siniestros_cobertura,
		sum(emi2.PrimaNetaPropiaEmitidaDevengada) AS Devengada, 
		sum(emi2.Ocurrido) AS ocurrido
		


FROM (

	SELECT emi.Idoficina,
			emi.ModeloVehiculo,
			var_cob.Periodo,
			var_cob.UnidadesExpuestasCobertura,
			var_cob.NumSiniestroCobertura,
			var_cob.PrimaNetaPropiaEmitidaDevengada,
			var_cob.Ocurrido,
			emi.IdClasificacionProducto,
			emi.IdSubclasificacionProducto,
			emi.IdVehiculo,
			emi.IdEstadoCliente
		
	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	INNER JOIN  TB_BI_AutrVariablesPorCobertura AS var_cob
	ON var_cob.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND var_cob.NumDocumento=emi.NumDocumento
	AND var_cob.IdCobertura IN (345,236,349) -- Coberturas Robo total
	
	WHERE emi.IdTonelaje IN (3882,3883,3884)
	AND emi.ModeloVehiculo IN (2020,2021,2022,2023)
	--AND var_cob.Periodo=202201
	
	) AS emi2
	

LEFT JOIN VW_Bi_DimCLasificacionProductos  AS clas
ON clas.IdClasificacionProducto=emi2.IdClasificacionProducto
AND clas.IdSubclasificacionProducto=emi2.IdSubclasificacionProducto

LEFT JOIN VW_BI_DimVehiculo AS tv
ON tv.IdVehiculoInterno=emi2.IdVehiculo

LEFT JOIN (
	SELECT DISTINCT catm.IdEstado, catm.NombreEstado
	FROM DMSin.Tb_BI_CatMunicipios AS catm
	) AS est
ON est.Idestado=emi2.idestadocliente


GROUP BY emi2.IdOficina,
		emi2.ModeloVehiculo,
		clas.GrupoClasificacion,
		emi2.Periodo,
		tv.DescCarroceriaVehiculo,
		est.Nombreestado