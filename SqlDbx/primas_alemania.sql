SELECT base.NipPerfilAgente,
		age.nombreagente,
		
		sum(base.Emitida) AS Emitida

FROM (
		SELECT 	'Autos' AS ramo,
				LEFT(emicob.FechaTransaccion,4) AS 'Año',
				emi.NipPerfilAgente,
				
			     sum(emicob.PrimaNeta) AS Emitida
			   
		FROM TB_BI_AutrFactEmisionCob AS emicob
		
		
		INNER JOIN TB_BI_DimCobertura AS cob
		ON cob.IdCobertura=emicob.IdCobertura
		AND cob.DescTipoCobertura='Cobertura Propia'
		AND cob.IdLineaNegocio=4
		
		LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
		ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
		AND emi.NumDocumento=emicob.NumDocumento	
		
		
		WHERE emicob.FechaTransaccion BETWEEN 20240601 AND 20250531--aquí mueven el día
		
		
		GROUP BY  LEFT(emicob.FechaTransaccion,4),
				emi.NipPerfilAgente
				
		HAVING sum(emicob.PrimaNeta) !=0
		
		UNION ALL
		
		SELECT 'Daños' AS ramo,
				left(emicob.FechaTransaccion,4) AS 'Año',
			  	emi.NipPerfilAgente,
				
			   sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta
				--round(sum(emicob.PrimaNeta),0) AS Prima_Neta--
		
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
		
		WHERE emicob.FechaTransaccion BETWEEN 20240601 AND 20250531 --aquí mueven el día
		
		GROUP BY left(emicob.FechaTransaccion,4),
				emi.NipPerfilAgente
			   
				
		HAVING sum(emicob.PrimaNeta*tc.TipoCambio)!=0
				
		UNION ALL
		
		SELECT 'Turistas' AS ramo,
				LEFT(turi.Periodo,4) AS 'Año',
				turi.NipPerfilAgente,
				
			    sum(turi.PrimaNeta)AS emitida
			  
		FROM VW_BI_AuttFactEmision turi
		
		WHERE turi.Periodo BETWEEN 202406 AND 202505
		
		GROUP BY LEFT(turi.Periodo,4),
				turi.NipPerfilAgente
				
		UNION ALL
		
		SELECT 'GMM' AS ramo,
				LEFT(gmm.Periodo,4) AS 'Año',
				gmm.NAgente AS NipPerfilAgente,
				
			    sum(gmm.Prima_Total)AS emitida
			  
		FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm
		
		WHERE gmm.Periodo BETWEEN 202406 AND 202505
		
		GROUP BY LEFT(gmm.Periodo,4),
				gmm.NAgente
				
) AS base

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.nipperfilagente

GROUP BY base.nipperfilagente,
			age.NombreAgente