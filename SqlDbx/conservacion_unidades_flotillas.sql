SELECT base.NipAgrupador,
		base.Periodo_A_Renovar,
		CASE WHEN Oficina_siguiente IS NULL THEN 'No'
		ELSE 'Si' END AS Renovada,
		
		sum(base.Unidades) AS Unidades,
		round(sum(base.Emitida),0) AS Emitida


FROM (
	
	
	SELECT final.*
	
	FROM (
				SELECT 
				emi.IdOficina,
				ofi.NombreOficina,
				ofi.DescDireccionComercial,
				ofi.DescSubdireccionComercial,
				ofi.NombreOficinaComercial,
				--emi.NumCompletoCotizacion,
				emi.NumPoliza,
				emi.NumPolizaAnterior,
				emi.NumeroSerie,
				emi.FechaFinVigencia,
				aseg.NipAgrupador,
			   
				CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) AS Periodo_A_Renovar,
			
				sum(tec.UnidadesEmitidasReales) AS Unidades,
				sum(tec.PrimaNetaPropiaEmitida) AS Emitida,
				
				lead (emi.IdOficina) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2))) AS Oficina_siguiente
			  
		
	   
		
			FROM   HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
				
			INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
			ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
			AND emi.NumDocumento=tec.NumDocumento
			and tec.Periodo>=202301
				
			INNER JOIN (
				
						
						SELECT distinct
								emi.NumeroSerie
								
						
						FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
						
						INNER JOIN TB_BI_DimOficina AS ofi
				 		ON ofi.IdOficina=emi.IdOficina
				 		AND ofi.IdDireccionComercial IN (26862,31690, 26861)
				 		
				 		WHERE emi.IdTipoPoliza!=4013
				 		AND CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) BETWEEN 202408 AND 202408 --aquí se modifican las fechas para sacar el periodo del que quieres saber los números de serie a renovar
						
						
							) AS series
						
			ON series.NumeroSerie=emi.NumeroSerie
				
				
			left JOIN HDI_DWH.dbo.TB_BI_DimOficina AS ofi
			ON ofi.IdOficina=emi.IdOficina
			
			LEFT JOIN tb_bi_dimasegurado AS aseg
			ON aseg.CveAsegurado=emi.CveAsegurado
			   
				
			WHERE  	CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) >= 202408
				
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
					aseg.NipAgrupador
						
						
			HAVING sum(tec.UnidadesEmitidasReales) !=0	
	
	
		) AS final
	
	WHERE  CAST(concat(LEFT(final.FechaFinVigencia,4),substring(CONVERT(char(8), final.FechaFinVigencia, 112),5,2)) AS INTEGER)	BETWEEN 202408 AND 202408
	

	

) AS base


GROUP BY base.NipAgrupador,
		base.Periodo_A_Renovar,
		CASE WHEN Oficina_siguiente IS NULL THEN 'No'
		ELSE 'Si' END
		
ORDER BY base.Periodo_A_Renovar, base.NipAgrupador
		