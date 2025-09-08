SELECT tec.Periodo,
		
		sum(tec.PrimaNetaPropiaPagada) AS emitida

FROM  HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi

inner JOIN TB_BI_autrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
AND tec.Periodo BETWEEN 202501 AND 202506


GROUP BY tec.periodo