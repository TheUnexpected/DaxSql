SELECT isnull(cotII.Mes,plz.Mes) AS Mes,
	   isnull(cotII.Subdireccion,plz.Subdireccion) AS Subdireccion,
	   isnull(cotII.Oficinacomercial,plz.oficinacomercial) AS Oficina,
	   isnull(cotII.Tipo_Negocio,plz.Tipo_Negocio) AS Tipo_Negocio,	
		
		isnull(cotII.Cotizaciones,0) AS Cotizaciones,
		isnull(plz.Polizas,0) AS Polizas
	   


FROM(	
	
	SELECT cotiz.Mes,
			cotiz.Subdireccion,
	   		cotiz.OficinaComercial,
	   		
	   		--aquí falta ver si moda es solo moda
	   		CASE when cotiz.tipodocumento='Claveteo y Cotización MODA' then 'MODA'
	   		 	WHEN cotiz.numunidades <=50 THEN 'Micro'
	   			WHEN cotiz.numunidades <=200 THEN 'PYME'
	   			WHEN cotiz.numunidades <=500 THEN 'Empresarial'
	   		 	ELSE 'Macro' END AS Tipo_Negocio,

			count(DISTINCT cotiz.IdOt) AS cotizaciones
	FROM (	
		
		SELECT 
			SubdireccionComercial AS Subdireccion,
	   		OficinaComercial,
		    FORMAT(TiempoAltaOt, 'yyyy-MM') AS Mes,
		    cot.IdOT,
			cot.NumUnidades,	    
		    cot.TipoDocumento

		    
		FROM Dshd.VW_DWH_AutrMasivosSuscripcion_Impacto AS cot
	
		
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
			    AND CAST(tiempoaltaot AS DATE) BETWEEN '2024/01/01' AND '2025/06/30'
			    AND cot.SubdireccionComercial IN (
	        'Occidente',
	        'Mexico Promotorias',
	        'Noroeste',
	        'Noreste',
	        'Bajio',
	        'Sur',
	        'Mexico Despachos'
	        )
	
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
	   	

) AS cotII

full JOIN (

	SELECT emi.Mes,
			emi.Subdireccion,
	   		emi.OficinaComercial,
	   		
	   		--aquí falta ver si moda es solo moda
	   		CASE when emi.tipodocumento='Claveteo y Cotización MODA' then 'MODA'
	   		 	WHEN emi.numunidades <=50 THEN 'Micro'
	   			WHEN emi.numunidades <=200 THEN 'PYME'
	   			WHEN emi.numunidades <=500 THEN 'Empresarial'
	   		 	ELSE 'Macro' END AS Tipo_Negocio,
			
			sum(emi.plz) AS Polizas
	
	FROM (	
		
		SELECT 
			SubdireccionComercial AS Subdireccion,
	   		OficinaComercial,
		    FORMAT(TiempoAltaOt, 'yyyy-MM') AS Mes,
		    cot.IdOT,
			cot.NumUnidades,	    
		    cot.TipoDocumento,
		    CASE WHEN emisiones.ot_cotizacion IS NULL THEN 0
				ELSE 1 END AS PLZ
		    
		FROM Dshd.VW_DWH_AutrMasivosSuscripcion_Impacto AS cot
		
		LEFT join 
			
		(	SELECT DISTINCT OT_Cotizacion
				
				FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto AS Emi
					
				WHERE Emi.FechaEmision >= '2024-01-01'
					
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
			   --AND EstatusSuscripcion IN ('Terminado')
			   --AND CAST(TiempoAltaOt AS DATE)>= '2025/01/01'
			    AND CAST(tiempoaltaot AS DATE) BETWEEN '2024/01/01' AND '2025/06/30'
			    AND cot.SubdireccionComercial IN (
	        'Occidente',
	        'Mexico Promotorias',
	        'Noroeste',
	        'Noreste',
	        'Bajio',
	        'Sur',
	        'Mexico Despachos'
	        )
	
	) AS emi
	
	GROUP BY emi.Mes,
				emi.Subdireccion,
	   		emi.OficinaComercial,
	   		
	   		--aquí falta ver si moda es solo moda
	   		CASE when emi.tipodocumento='Claveteo y Cotización MODA' then 'MODA'
	   		 	WHEN emi.numunidades <=50 THEN 'Micro'
	   			WHEN emi.numunidades <=200 THEN 'PYME'
	   			WHEN emi.numunidades <=500 THEN 'Empresarial'
	   		 	ELSE 'Macro' END 
) AS plz

ON cotII.Mes=plz.mes
AND cotII.Subdireccion=plz.Subdireccion
AND cotII.OficinaComercial=plz.OficinaComercial
AND cotII.Tipo_Negocio=plz.Tipo_Negocio