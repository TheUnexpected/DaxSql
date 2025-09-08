SELECT *

FROM DWH.Tb_BI_GrlFacRecibosHistorico AS hist

LEFT JOIN tb_bi_dimreciboestatus AS status
ON status.IdEstatus=hist.IdEstatus

WHERE IdRecibo IN (
		SELECT idrecibo
		FROM DWH.Tb_BI_GrlFacRecibosMae
		WHERE IdOficinaEmision=58
		AND IdLineaNegocio=1
		--AND NumPoliza=5026
		)
		
AND hist.FechaMovimiento BETWEEN '2024-11-01' AND '2024-11-30'



SELECT tec.Periodo,
		emi.NumCompletoCotizacion,
		emi.NumDocumento,
		
		round(sum(tec.PrimaNetaPropiaSinCoaseguro),0) AS Prima,
		sum(tec.UnidadesEmitidasReales) AS Unidades	

FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
--aND tec.Periodo>202201

WHERE emi.NumCompletoCotizacion=44690000823839

GROUP BY tec.Periodo,
		emi.NumCompletoCotizacion,
		emi.NumDocumento



SELECT rec.NumCompletoCotizacion,
				rec.NumDocumento,
				esta.DescEstatus AS EstatusRecibo,
				
				MaximoDocumento=max(rechis.FechaMovimiento)
		
		FROM DWH.Tb_BI_GrlFacRecibosMae AS rec

		
		LEFT JOIN DWH.Tb_BI_GrlFacRecibosHistorico AS rechis
		ON rechis.IdRecibo=rec.IdRecibo
		
		INNER JOIN tb_bi_dimreciboestatus AS esta
		ON esta.IdEstatus=rechis.IdEstatus
		AND esta.DescEstatus='PAGADO'

		WHERE rec.IdOficinaEmision=469
		AND rec.NumPoliza=5026
		--AND rec.IdRecibo=50367810


		GROUP BY rec.NumCompletoCotizacion,
				rec.NumDocumento,
				esta.DescEstatus