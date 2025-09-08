SELECT 'Autos' AS Ramo,
		base.*,
	   convert(DATE,CAST(pmas.fechatransaccion AS VARCHAR),111) AS Fecha_Transaccion,
		pmas.Emitida_Autos AS Emitida

FROM (

	SELECT age.NombreAgente,
			age.FechaAlta,
			
			CAST(CAST(min(emicob.FechaTransaccion) AS VARCHAR) AS DATE) AS Minima_fecha_autos
			
		     --sum(emicob.PrimaNeta) AS Emitida_Autos
		   
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20250430 --aquí mueven el día
	AND emi.NumDocumento=0 
	AND emi.IdTipoDocumento IN (21,91,251,531)
	AND age.FechaAlta>='2022-01-01'
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	AND age.IdTipoAgente=19
	
	GROUP BY age.NombreAgente,
			age.FechaAlta
		
) AS base

LEFT JOIN 

(
	SELECT age.NombreAgente,		
			emicob.FechaTransaccion,
			
		     sum(emicob.PrimaNeta) AS Emitida_Autos
		   
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20250430 --aquí mueven el día
	AND age.FechaAlta>='2022-01-01'
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	AND age.IdTipoAgente=19
	
	GROUP BY age.NombreAgente,
			emicob.FechaTransaccion	
			
) AS pmas

ON pmas.NombreAgente=base.nombreagente

WHERE pmas.Emitida_Autos !=0