SELECT final.*,
		CASE WHEN final.oficina_siguiente IS NULL THEN 'No'
		ELSE 'Sí' END AS Renovado

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
			tpol.DescGrupoTipoPoliza,
			case when tv.IdTipoVehiculo in (22809,5676) then 'Vehículo Pesado'
        	else 'Otro' end as Tipo_vehiculo,
		   
			CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) AS Periodo_A_Renovar,
		
			--sum(tec.UnidadesEmitidasReales) AS Unidades,
			
			lead (emi.IdOficina) OVER ( PARTITION BY emi.NumeroSerie ORDER BY  concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2))) AS Oficina_siguiente
		  
	
   
	
		FROM   HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
			
		INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
		ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
		AND emi.NumDocumento=tec.NumDocumento
		and tec.Periodo>=202301 --aqui se pone el periodo desde el que vas a buscar el historial, sugiero poner poco más de un año porque si no, no sale nada
			
		INNER JOIN (
			
					
					SELECT distinct
							emi.NumeroSerie
							
					
					FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
					
					INNER JOIN TB_BI_DimOficina AS ofi
			 		ON ofi.IdOficina=emi.IdOficina
			 		AND ofi.IdDireccionComercial IN (26862,31690, 26861)
			 		
			 		WHERE CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) BETWEEN 202405 AND 202405 --aquí se modifican las fechas para sacar el periodo del que quieres saber los números de serie a renovar
					
					
						) AS series
					
		ON series.NumeroSerie=emi.NumeroSerie
			
			
		left JOIN HDI_DWH.dbo.TB_BI_DimOficina AS ofi
		ON ofi.IdOficina=emi.IdOficina
		
		LEFT JOIN tb_bi_dimtipopoliza AS tpol
		ON tpol.IdTipoPoliza=emi.IdTipoPoliza
	
		LEFT JOIN TB_BI_DimTipoVehiculo AS tv
		ON tv.IdTipoVehiculo=emi.IdTipoVehiculo 
		
		INNER JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
		ON page.NipPerfilAgente=emi.NipPerfilAgente
		AND page.CanalVenta IS NOT NULL
			
		WHERE  	CAST(concat(LEFT(emi.FechaFinVigencia,4),substring(CONVERT(char(8), emi.FechaFinVigencia, 112),5,2)) AS INTEGER) >= 202405 --aquí hay que poner mayor al periodo de interés, por la forma que se ejecutan las ordenes de sql debe ser así 
			
		GROUP BY emi.IdOficina,
				ofi.NombreOficina,
				ofi.DescDireccionComercial,
				ofi.DescSubdireccionComercial,
				ofi.NombreOficinaComercial,
				emi.NumCompletoCotizacion,
				emi.NumPoliza,
				emi.NumPolizaAnterior,
				emi.NumeroSerie,
				tpol.DescGrupoTipoPoliza,
				emi.FechaFinVigencia,	case when tv.IdTipoVehiculo in (22809,5676) then 'Vehículo Pesado'
        		else 'Otro' end
					
					
		HAVING sum(tec.UnidadesEmitidasReales) >= 1


	) AS final

WHERE  CAST(concat(LEFT(final.FechaFinVigencia,4),substring(CONVERT(char(8), final.FechaFinVigencia, 112),5,2)) AS INTEGER)	BETWEEN 202405 AND 202405	-- aquí si filtras solo el periodo de interes

ORDER BY final.IdOficina, final.NumeroSerie, final.NumPoliza