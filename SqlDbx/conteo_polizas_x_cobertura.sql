SELECT base.Anio, 
		base.DescCobertura,
		
		sum(base.Prima_Neta) AS Emitida,
		count(distinct(base.Poliza)) AS Polizas
		
FROM (

	SELECT LEFT(emicob.FechaTransaccion,4) AS Anio,
			cob.DescCobertura,
			concat(emi.IdOficina,'-',emi.NumPoliza) AS Poliza, 
			--emi.IdOficina,  
			--emi.NumPoliza,
			
			sum(emicob.PrimaNeta) AS Prima_Neta
	
	
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20240930 --aquí mueven el día
	AND emi.idtarifa=1
   
	
	GROUP BY LEFT(emicob.FechaTransaccion,4),
			cob.DescCobertura,
			--emi.IdOficina, 
			--emi.NumPoliza
			concat(emi.IdOficina,'-',emi.NumPoliza)
			
	HAVING  sum(emicob.PrimaNeta)!=0
			
	--ORDER BY round(sum(emicob.PrimaNeta),0) desc
			
) AS base 

GROUP BY base.Anio, 
		base.DescCobertura
