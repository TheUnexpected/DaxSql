SELECT aux2.*

FROM (


	SELECT aux.Idoficina,
			aux.NipPerfilAgente,
			aux.NumeroSerie,
			aux.NumPoliza,
			aux.DescMarcaVehiculo,
			aux.DescCarroceriaVehiculo,
			aux.ModeloVehiculo,
			aux.NombreEstado,
			aux.Periodo_A_Renovar,
			aux.Fecha_Fin_Vigencia,
			aux.Fecha_Inicio_Vigencia,
			aux.Unidades,
			
			
			isnull(lead (aux.IdOficina) OVER ( PARTITION BY aux.NumeroSerie ORDER BY aux.Fecha_Fin_Vigencia),0) AS Oficina_siguiente,
			lead (aux.NipPerfilAgente) OVER ( PARTITION BY aux.NumeroSerie ORDER BY aux.Fecha_Fin_Vigencia) AS Agente_siguiente,
			lead (aux.Fecha_Inicio_Vigencia) OVER ( PARTITION BY aux.NumeroSerie ORDER BY aux.Fecha_Fin_Vigencia) AS Fecha_In_Vig_Sig
		
	
	FROM (
	
	
		SELECT 
					emi.IdOficina,
					emi.NumeroSerie,
					emi.NipPerfilAgente,
					emi.NumPoliza,
					catv.DescMarcaVehiculo,
					catv.DescCarroceriaVehiculo,
					emi.ModeloVehiculo,
					--uso.DescUsoCNSF AS Uso,
					aseg.NombreEstado,
					
					
					max(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2))) AS Periodo_A_Renovar,
					max(CAST(emi.FechaFinVigencia AS DATE)) AS Fecha_Fin_Vigencia,
					max(CAST(emi.FechaInicioVigencia AS DATE)) AS Fecha_Inicio_Vigencia,
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
				
				--LEFT JOIN TB_BI_DimUsoVehiculo AS uso
				--ON uso.IdUsoVehiculo=emi.IdUsoVehiculo
				
				WHERE emi.IdOficina NOT IN (123)
					
				GROUP BY emi.IdOficina,
					emi.NumeroSerie,
					emi.NipPerfilAgente,
					emi.NumPoliza,
					catv.DescMarcaVehiculo,
					catv.DescCarroceriaVehiculo,
					emi.ModeloVehiculo,
					aseg.NombreEstado
					--uso.DescUsoCNSF,
				
				HAVING sum(tec.UnidadesEmitidasReales) !=0	
				AND max(CAST(emi.FechaFinVigencia AS DATE))>='2022-01-01'
				
	) AS aux

) AS aux2

WHERE aux2.Fecha_Fin_Vigencia<=CURRENT_TIMESTAMP
AND aux2.IdOficina IN (343,344,346,347,96,99,439)
--AND final.Uso='Particular'