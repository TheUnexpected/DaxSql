SELECT final.*

FROM (
			SELECT 
			emi.IdOficina,
			ofi.NombreOficina,
			ofi.DescDireccionComercial,
			ofi.DescSubdireccionComercial,
			ofi.NombreOficinaComercial,
			emi.NumCompletoCotizacion,
			emi.NumPoliza,
			emi.NumPolizaAnterior,
			emi.NumeroSerie,
			emi.FechaFinVigencia,
			paq.DescPaquete,
			catv.DescMarcaVehiculo,
			catv.DescCarroceriaVehiculo,
			emi.ModeloVehiculo,
			
			catcon.DescTipoConservacion AS Conservacion,
		   
			concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS Periodo_A_Renovar,
		
			sum(tec.UnidadesEmitidasReales) AS Unidades,
			
			lead (catcon.DescTipoConservacion) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2))) AS Conservacion_siguiente,
			lead (paq.DescPaquete) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2))) AS Paquete_siguiente	
	   
	
   
	
		FROM   HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
			
		INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
		ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
		AND emi.NumDocumento=tec.NumDocumento
		and tec.Periodo>=202104
			
		INNER JOIN (
			
					
					SELECT distinct
							emi.NumeroSerie
							
					
					FROM HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
					
					INNER JOIN  HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
					ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
					AND emi.NumDocumento=tec.NumDocumento
					AND emi.IdPaquete IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610)
					
					
						) AS series
					
		ON series.NumeroSerie=emi.NumeroSerie
			
			
		left JOIN HDI_DWH.dbo.TB_BI_DimOficina AS ofi
		ON ofi.IdOficina=emi.IdOficina
		   
			
		LEFT JOIN TB_Bi_DimTipoConservacion AS catcon
		ON catcon.IdTipoConservacion=emi.IdTipoConservacion
			
		lEFT JOIN TB_BI_DimPaquete AS paq
		ON paq.IdPaquete=emi.IdPaquete
			
		LEFT JOIN DmSin.Tb_BI_CatVehiculo AS catv
		ON catv.IdInternoVehiculo=emi.IdVehiculo
			
		WHERE  	concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) >= 202104
			
		GROUP BY emi.IdOficina,
				ofi.NombreOficina,
				ofi.DescDireccionComercial,
				ofi.DescSubdireccionComercial,
				ofi.NombreOficinaComercial,
				emi.NumCompletoCotizacion,
				emi.NumPoliza,
				emi.NumPolizaAnterior,
				emi.NumeroSerie,
				emi.FechaFinVigencia,
				paq.DescPaquete,
				catv.DescMarcaVehiculo,
				catv.DescCarroceriaVehiculo,
				emi.ModeloVehiculo,
				catcon.DescTipoConservacion
					
					
		HAVING sum(tec.UnidadesEmitidasReales) !=0	


	) AS final

WHERE final.DescPaquete LIKE '%IDRIVING%'
AND final.FechaFinVigencia<=CURRENT_TIMESTAMP

ORDER BY final.IdOficina, final.NumeroSerie, final.NumPoliza