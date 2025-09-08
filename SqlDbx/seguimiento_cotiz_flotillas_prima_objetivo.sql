
	SELECT cotiz.Mes,
			cotiz.Subdireccion,
	   		cotiz.OficinaComercial,
	   		
	   		--aquí falta ver si moda es solo moda
	   		CASE when cotiz.tipodocumento='Claveteo y Cotización MODA' then 'MODA'
	   		 	WHEN cotiz.numunidades <=50 THEN 'Micro'
	   			WHEN cotiz.numunidades <=200 THEN 'PYME'
	   			WHEN cotiz.numunidades <=500 THEN 'Empresarial'
	   		 	ELSE 'Macro' END AS Tipo_Negocio,
	   		 	
	   		sum(cotiz.Obj) AS Prima_Objetivo,
			count(DISTINCT cotiz.IdOt) AS cotizaciones,
			sum(cotiz.plz) AS plz
	FROM (	
		
		SELECT 
			SubdireccionComercial AS Subdireccion,
	   		OficinaComercial,
		    FORMAT(TiempoAltaOt, 'yyyy-MM') AS Mes,
		    cot.IdOT,
			cot.NumUnidades,	    
		    cot.TipoDocumento,
		    CASE WHEN emisiones.ot_cotizacion IS NULL THEN 0
				ELSE 1 END AS PLZ,
				
		    CASE WHEN cot.primanetaobjetivo>1000 THEN 1
	   		 	ELSE 0 END AS Obj
	   		 	
	   		 	
	FROM Dshd.VW_DWH_AutrMasivosSuscripcion_Impacto AS cot
		
		LEFT join 
			
		(	SELECT DISTINCT OT_Cotizacion
				
				FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto AS Emi
					
				WHERE Emi.FechaEmision >= '2022-01-01'
					
		) AS emisiones
				  
		ON emisiones.OT_cotizacion=cot.IdOT	
	
		WHERE 
			    -- Filtros por tipo de documento
			    TipoDocumento IN (
			        'Recotización',
			        'Claveteo y Cotización',
			        'Claveteo y Cotización MODA'
			    )
			    -- Filtro por estatus de suscripción
			   AND EstatusSuscripcion IN ('Terminado')
			   --AND CAST(TiempoAltaOt AS DATE)>= '2025/01/01'
			    AND CAST(tiempoaltaot AS DATE) BETWEEN '2024/01/01' AND '2025/02/28'
			    AND cot.SubdireccionComercial IN (
	        'Occidente',
	        'Mexico Promotorias',
	        'Noroeste',
	        'Noreste',
	        'Bajio',
	        'Sur',
	        'Mexico Despachos'
	        )
	        AND cot.primanetaobjetivo<1000
	
	) AS cotiz
	
	GROUP BY cotiz.Mes,
			cotiz.Subdireccion,
	   		cotiz.OficinaComercial,
	   		
	   		--aquí falta ver si moda es solo moda
	   		CASE when cotiz.tipodocumento='Claveteo y Cotización MODA' then 'MODA'
	   		 	WHEN cotiz.numunidades <=50 THEN 'Micro'
	   			WHEN cotiz.numunidades <=200 THEN 'PYME'
	   			WHEN cotiz.numunidades <=500 THEN 'Empresarial'
	   		 	ELSE 'Macro' END
	   	

