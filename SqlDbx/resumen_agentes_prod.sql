SELECT age.NombreAgente, 
		CAST(LEFT(primas.Periodo,4) AS INTEGER) AS Anio_Emision,
		year(age.fechaAlta) AS Anio_Alta,
		
		
		sum(primas.Prima_Neta) AS Prima_Total

FROM (
	
	SELECT emi.IdOficina,
			emi.NipPerfilAgente,
			CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER ) AS Periodo,
			'Autos' AS Ramo,
				
			sum(emicob.PrimaNeta) AS Prima_Neta  
	
	
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento		
				
	INNER JOIN hdi_dwh.dbo.Tb_Bi_dimoficina AS Ofi
	ON emi.IdOficina=Ofi.IdOficina
	AND Ofi.IdDireccionComercial IN (26862,31690, 26861)
				
				
	INNER JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	AND age.IdTipoAgente=19
	AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
	
	
	WHERE emicob.FechaTransaccion >= 20220101 
	
	GROUP BY emi.IdOficina,
			emi.NipPerfilAgente,
			CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER )
	
	Union All
	
	SELECT emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER ) AS Periodo,
		'Daños' AS Ramo,
			
			sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta  


FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento		
			
INNER JOIN hdi_dwh.dbo.Tb_Bi_dimoficina AS Ofi
ON emi.IdOficina=Ofi.IdOficina
AND Ofi.IdDireccionComercial IN (26862,31690, 26861)
			
			
INNER JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente
AND age.IdTipoAgente=19
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

WHERE emicob.FechaTransaccion >= 20220101 

GROUP BY emi.IdOficina,
		emi.NipPerfilAgente,
		CAST(LEFT(emicob.FechaTransaccion,6) AS INTEGER )

) AS primas 

LEFT JOIN TB_BI_DimAgente AS age
ON age.NipPerfilAgente=primas.NipPerfilAgente

GROUP BY age.NombreAgente, 
		CAST(LEFT(primas.Periodo,4) AS INTEGER),
		year(age.fechaAlta) 