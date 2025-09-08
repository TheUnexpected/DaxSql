SELECT age.nombreagente, age.fechaalta,
		
		CAST(min(base.min) AS DATE) AS Minima_fecha_gmm

FROM (

	SELECT tot.Nagente,
			min(tot.min) AS min
					
	FROM(			
			SELECT gmm_emi.NAgente,
					min(gmm_emi.femirbo) AS min
			   				
						
			FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
					
			GROUP BY gmm_emi.NAgente
			
		  
			UNION ALL
		
			
			SELECT emi_c.NAgente,
					min(emi_c.FemiRbo) AS min
			   				
			FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS emi_c
					
			GROUP BY 	emi_c.NAgente
					
	) AS tot
	
	GROUP BY tot.Nagente 		

) AS base

left JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NAgente

WHERE CAST(age.fechaalta AS DATE)>='2022-01-01'
AND base.min>= 20220101 

GROUP BY age.nombreagente, age.fechaalta

