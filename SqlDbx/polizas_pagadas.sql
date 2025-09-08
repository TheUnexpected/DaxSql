SELECT rec.NumPoliza,
		rec.IdOficinaEmision,
		rec.NipPerfilAgente,
		esta.DescEstatus AS EstatusRecibo,
				
		MaximoDocumento=max(rechis.FechaMovimiento)
		
		
		
FROM DWH.Tb_BI_GrlFacRecibosMae AS rec

		
LEFT JOIN DWH.Tb_BI_GrlFacRecibosHistorico AS rechis
ON rechis.IdRecibo=rec.IdRecibo
		
INNER JOIN tb_bi_dimreciboestatus AS esta
ON esta.IdEstatus=rechis.IdEstatus
AND esta.DescEstatus='PAGADO'

WHERE rec.IdOficinaEmision=433
AND rec.NipPerfilAgente=104926

		
GROUP BY rec.NumPoliza,
		rec.IdOficinaEmision,
		rec.NipPerfilAgente,
		esta.DescEstatus