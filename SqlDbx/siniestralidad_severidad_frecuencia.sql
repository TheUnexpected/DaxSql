SELECT ofi.NombreOficina AS Oficina_Operativa,
		concat(age.NipPerfilAgente,' ',age.NombreAgente) AS Nombre_Agente,
		tpol.DescGrupoTipoPoliza AS Tipo_Poliza,
		
		sum(tec.Ocurrido) AS Ocurrido,
		sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		sum(tec.NumSiniestro) AS Siniestros,
		sum(tec.UnidadesExpuestasMes) AS Expuesto
		
FROM  HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

inner JOIN TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
AND tec.Periodo BETWEEN 202202 AND 202301

LEFT JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN TB_BI_DimAgente AS age
on age.NipPerfilAgente=emi.NipPerfilAgente

LEFT JOIN TB_BI_DimTipoPoliza AS tpol
ON tpol.IdTipoPoliza=emi.IdTipoPoliza

WHERE emi.NipPerfilAgente=54258
	
--WHERE emi.NipPerfilAgente IN (93156,52465,103054,90571,69169,63836,54104,64645,54258,93833,55103,63941,91902,54869,59894,51898,64735,52318,67963,97403,53992,65153)

GROUP BY ofi.NombreOficina,
		concat(age.NipPerfilAgente,' ',age.NombreAgente),
		tpol.DescGrupoTipoPoliza