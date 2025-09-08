SELECT emi.IdOficina,
		clas.GrupoClasificacion,
		var_cob.Periodo,
   
		sum(var_cob.UnidadesExpuestasCobertura) AS U_Expuestas,
		sum(var_cob.NumSiniestroCobertura) AS Siniestros_cobertura,
		sum(var_cob.PrimaNetaPropiaEmitidaDevengada) AS Devengada, 
		sum(var_cob.Ocurrido) AS ocurrido
		


FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN  TB_BI_AutrVariablesPorCobertura AS var_cob
ON var_cob.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND var_cob.NumDocumento=emi.NumDocumento
AND var_cob.IdCobertura IN (345,236,349) -- Coberturas Robo total
AND var_cob.Periodo=202001

LEFT JOIN VW_Bi_DimCLasificacionProductos  AS clas
ON clas.IdClasificacionProducto=emi.IdClasificacionProducto
AND clas.IdSubclasificacionProducto=emi.IdSubclasificacionProducto


WHERE emi.IdTonelaje IN (3882,3883,3884)

GROUP BY emi.IdOficina,
		clas.GrupoClasificacion,
		var_cob.Periodo