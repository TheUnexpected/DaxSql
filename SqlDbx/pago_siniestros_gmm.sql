SELECT year(pago_gmm.FechaTransaccion) AS Anio,
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		pago_gmm.NumPoliza,
		pago_gmm.NumSiniestro,
		contr.Contrat,
		
		sum(pago_gmm.ImportePago) AS Pago

FROM TB_DWH_GMMSiniestros_Pagos AS pago_gmm

LEFT JOIN (
			SELECT  gmm_emi.Contrat, gmm_emi.PolSocioComercial, gmm_emi.RamoSubramol, gmm_emi.NAgente		   				
						
			FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
			
			inner JOIN (
			
				SELECT gmm_emiII.PolSocioComercial, max(gmm_emiII.FolioRbo) AS Folio 				
							
				FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emiII
				 
				GROUP BY gmm_emiII.PolSocioComercial 
				
			) AS filtro
			
			ON filtro.Folio=gmm_emi.FolioRbo
			AND filtro.PolsocioComercial=gmm_emi.PolSocioComercial
			
				  
			UNION ALL
		
			
			SELECT emi_c.Contrat, emi_c.PolSocioComercial, emi_c.RamoSubramol, emi_c.NAgente
						   				   				
			FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS emi_c
			
			inner JOIN (
						
				SELECT gmm_emiII.PolSocioComercial, max(gmm_emiII.FolioRbo) AS Folio 				
									
				FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria  AS gmm_emiII
						 
				GROUP BY gmm_emiII.PolSocioComercial 
						
						) AS filtro
						
			ON filtro.Folio=emi_c.FolioRbo
			AND filtro.PolsocioComercial=emi_c.PolSocioComercial
			
					
) AS contr

ON contr.PolSocioComercial=pago_gmm.NumPoliza

LEFT JOIN TB_BI_DimAgente AS age
ON age.NipPerfilAgente=contr.Nagente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE year(pago_gmm.FechaTransaccion)=2024
			

GROUP BY year(pago_gmm.FechaTransaccion),
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		pago_gmm.NumPoliza,
		pago_gmm.NumSiniestro,
		contr.Contrat
		
ORDER BY ofi.DescDireccionComercial, ofi.DescSubdireccionComercial, pago desc