SELECT final.*

FROM (
			SELECT 
			emi.IdOficina,
			emi.NumeroSerie,
			emi.NipPerfilAgente,
			CAST(emi.FechaFinVigencia AS DATE) AS Fecha_Fin_Vigencia,
			CAST(emi.FechaInicioVigencia AS DATE) AS Fecha_Inicio_Vigencia,
			catv.DescMarcaVehiculo,
			catv.DescCarroceriaVehiculo,
			emi.ModeloVehiculo,
			uso.DescUsoCNSF AS Uso,
			aseg.NombreEstado,
			concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS Periodo_A_Renovar,
			
			isnull(lead (emi.IdOficina) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  	CAST(emi.FechaInicioVigencia AS DATE)),0) AS Oficina_siguiente,
			lead (emi.NipPerfilAgente) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  	CAST(emi.FechaInicioVigencia AS DATE)) AS Agente_siguiente,
			lead (CAST(emi.FechaInicioVigencia AS DATE)) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  	CAST(emi.FechaInicioVigencia AS DATE)) AS Fecha_In_Vig_Sig,

			sum(tec.UnidadesEmitidasReales) AS Unidades


	FROM   HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
			

		INNER JOIN (
	
				SELECT distinct emi.NumeroSerie
   
				FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

				--WHERE  concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) >= 202104
				WHERE emi.IdClasificacionProducto=1
				AND CAST(emi.FechaFinVigencia AS DATE) BETWEEN '2022-01-01' AND CURRENT_TIMESTAMP
				AND emi.NumDocumento=0
				AND emi.IdTipoConservacion IN (0,2)
				AND emi.IdOficina IN (343,344,346,347,96,99,439)
			   
			
						) AS series
					
		ON series.NumeroSerie=emi.NumeroSerie
		
		INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
		ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		AND tec.NumDocumento=emi.NumDocumento
	
		
		LEFT JOIN VW_BI_DimVehiculo AS catv
		ON catv.IdVehiculoInterno=emi.IdVehiculo
		
		LEFT JOIN tB_BI_DimAsegurado AS aseg
		ON aseg.CveAsegurado=emi.CveAsegurado
		
		LEFT JOIN TB_BI_DimUsoVehiculo AS uso
		ON uso.IdUsoVehiculo=emi.IdUsoVehiculo
		
		
		WHERE  CAST(emi.FechaFinVigencia AS DATE) >= '2022-01-01'
		--WHERE  	concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) >= 202104
		
		GROUP BY emi.IdOficina,
			emi.NumeroSerie,
			emi.NipPerfilAgente,
			CAST(emi.FechaFinVigencia AS DATE),
			CAST(emi.FechaInicioVigencia AS DATE),
			catv.DescMarcaVehiculo,
			catv.DescCarroceriaVehiculo,
			emi.ModeloVehiculo,
			aseg.NombreEstado,
			uso.DescUsoCNSF,
			concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) 
			
			
			HAVING sum(tec.UnidadesEmitidasReales)!=0
		
		
	) AS final

WHERE final.Fecha_Fin_Vigencia<=CURRENT_TIMESTAMP
AND final.IdOficina IN (343,344,346,347,96,99,439)
--AND final.Uso='Particular'
ORDER BY final.IdOficina, final.NumeroSerie