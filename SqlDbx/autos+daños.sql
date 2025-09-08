SELECT base.Año,
		base.NombreAgente,
		base.DescEstatusAgente,
		
		sum(Prima_Neta) AS Emitida

FROM (

	SELECT left(emicob.FechaTransaccion,4) AS 'Año',
			age.NombreAgente,
			age.DescEstatusAgente,
			
			
			sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta
	
	FROM TB_BI_DanFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=1
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
	ON mon.IdMoneda=emi.IdMoneda
	
	LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
	ON tc.IdMoneda=emi.IdMoneda
	AND tc.Periodo = left(emi.FechaTransaccion,6)
	
	LEFT JOIN tb_bi_dimasegurado AS ase
	ON ase.CveAsegurado=emi.CveAsegurado
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=emi.IdOficina
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20250630 --aquí mueven el día
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	
	GROUP BY left(emicob.FechaTransaccion,4),
			age.NombreAgente,
			age.DescEstatusAgente
			
	UNION ALL
	
	
	SELECT left(emicob.FechaTransaccion,4) AS 'Año',
			age.NombreAgente,
			age.DescEstatusAgente,
			
		     sum(emicob.PrimaNeta) AS Prima_Neta
		   
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento	
	
	LEFT JOIN tb_bi_dimasegurado AS ase
	ON ase.CveAsegurado=emi.CveAsegurado
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=emi.IdOficina
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20250630--aquí mueven el día
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	
	GROUP BY left(emicob.FechaTransaccion,4),
			age.NombreAgente,
			age.DescEstatusAgente
			
	
) AS base  

GROUP BY base.Año,
		base.NombreAgente,
		base.DescEstatusAgente			