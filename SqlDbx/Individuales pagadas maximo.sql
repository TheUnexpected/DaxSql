SELECT concat(emi.NipAgente,' - ',emi.NombreAgente) AS Agente,
		emi.IdOficina,
		emi.NumPoliza,
		aux2.Recibo,
		aux2.EstatusRecibo,
		aux2.Max_Movimiento,
		
			-- emi.IdClasificacionProducto
			--, emi.IdSubClasificacionproducto,
		
		sum(emi.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(emi.PrimaNetaPropiaPagada) AS Pagada,
		sum(emi.UnidadesEmitidasReales) AS Unidades
 
 
FROM ( SELECT emi2.NumPoliza,
				emi2.IdOficina,
				emi2.NipAgente,
				age.NombreAgente,
				tec.PrimaNetaPropiaSinCoaseguro,
				tec.PrimaNetaPropiaPagada,
				tec.UnidadesEmitidasReales
				
				, emi2.IdClasificacionProducto
				, emi2.IdSubClasificacionproducto
		
		
		FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS Emi2
		
		INNER JOIN hdi_dwh.dbo.Tb_Bi_AutrBase2Tecnica AS Tec
		ON tec.NumCompletoCotizacion=emi2.NumCompletoCotizacion
		AND tec.NumDocumento=emi2.NumDocumento
		AND Tec.Periodo BETWEEN 202201 AND 202212
		
		inner JOIN tb_bi_dimagente AS age 
		ON age.NipPerfilAgente=emi2.NipPerfilAgente
		AND age.IdTipoAgente=19
		
		WHERE Emi2.IdTipoPoliza=4013
		AND Emi2.IdClasificacionProducto NOT IN (1,2)
		AND emi2.IdTipoConservacion=0
		
	   --	AND emi2.NipAgente=90481
) AS emi 

--LEFT JOIN tb_bi_dimoficina AS ofi
--ON ofi.IdOficina=emi.IdOficina


LEFT JOIN (SELECT mae2.NumPoliza,
		mae2.IdOficinaEmision,
		--rec.NipPerfilAgente,
		mae2.Recibo,
		esta.DescEstatus AS EstatusRecibo,
		aux.Max_Movimiento	
		
		
		FROM (SELECT mae.NumPoliza,
					mae.IdOficinaEmision,
					
					max(IdRecibo) AS Recibo
		
		
				FROM DWH.Tb_BI_GrlFacRecibosMae AS mae
				
				WHERE mae.IdlineaNegocio=4
				
				GROUP BY mae.NumPoliza,
					mae.IdOficinaEmision
					
			) AS mae2
				
		
				
		LEFT JOIN (SELECT hist.IdRecibo,
							hist.FechaMovimiento AS Max_Movimiento,
							hist.IdEstatus
					
					FROM DWH.Tb_BI_GrlFacRecibosHistorico AS hist
		
					INNER JOIN (
								SELECT rechis.IdRecibo,
										max(Fechamovimiento) AS Max_Movimiento
					
								FROM DWH.Tb_BI_GrlFacRecibosHistorico AS rechis				
								GROUP BY rechis.IdRecibo
								
								) AS mov_rec
					 ON hist.IdRecibo=mov_rec.IdRecibo
					 AND hist.FechaMovimiento=mov_rec.Max_movimiento
					 
					 ) AS aux
					 
		ON aux.Idrecibo=mae2.Recibo
					 
		left JOIN tb_bi_dimreciboestatus AS esta
		ON esta.IdEstatus=aux.IdEstatus
		--AND esta.DescEstatus='PAGADO'
) AS aux2

ON aux2.NumPoliza=emi.NumPoliza
AND aux2.IdOficinaEmision=emi.IdOficina
		

GROUP BY concat(emi.NipAgente,' - ',emi.NombreAgente),
		emi.IdOficina,
		emi.NumPoliza,
		aux2.Recibo,
		aux2.EstatusRecibo,
		aux2.Max_Movimiento
		
		   --	, emi.IdClasificacionProducto
		   --	, emi.IdSubClasificacionproducto

