SELECT ofi.NombreOficina AS Oficina_Operativa,
		concat(age.NipPerfilAgente,' ',age.NombreAgente) AS Nombre_Agente,
		CASE WHEN prod.ClasificacionProducto = 'Transporte' THEN 'Transporte'
		ELSE 'Daños' END AS producto,
		
		sum(tec.Ocurrido) AS Ocurrido,
		sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		sum(tec.NumSiniestro) AS Siniestros,
		sum(tec.UnidadesExpuestasMes) AS Expuesto
		
FROM  HDI_DWH.dbo.TB_BI_danFactEmisionDoc AS emi

inner JOIN TB_BI_danBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
AND tec.Periodo BETWEEN 202202 AND 202301

LEFT JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN TB_BI_DimAgente AS age
on age.NipPerfilAgente=emi.NipPerfilAgente

inner JOIN VW_Bi_DimCLasificacionProductos AS prod
ON prod.IdClasificacionProducto=emi.IdClasificacionProducto
AND prod.IdSubclasificacionProducto=emi.IdSubclasificacionProducto
and IdLineaNegocio=1
	
WHERE emi.NipPerfilAgente IN (93156,52465,103054,90571,69169,63836,54104,64645,54258,93833,55103,63941,91902,54869,59894,51898,64735,52318,67963,97403,53992,65153)

GROUP BY ofi.NombreOficina,
		concat(age.NipPerfilAgente,' ',age.NombreAgente),
		CASE WHEN prod.ClasificacionProducto = 'Transporte' THEN 'Transporte'
		ELSE 'Daños' END	