SELECT emi.IdOficina, 	
		emi.NumPoliza,
		pag.DescFrecuenciaPago,

		sum(tec.PrimaNeta) AS Prima_neta, 
		sum(tec.PrimaTarifa) AS Tarifa, 
		sum(tec.PrimaNetaPropiaEmitida) AS Propia_Emitida,
		sum(tec.PrimaNetaPropiaTarifa) AS Propia_Tarifa

		

from HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi

INNER JOIN TB_BI_AutrBase2Tecnica AS tec
ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
AND emi.NumDocumento = tec.NumDocumento
AND tec.Periodo BETWEEN 202409 AND 202502

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS pag
ON pag.IdFrecuenciaPago=emi.IdFrecuenciaPago

WHERE emi.Periodo BETWEEN 202409 AND 202502
AND emi.IdTipoConservacion !=0
AND emi.IdFrecuenciaPago IN (5877, 5878, 33140)
AND emi.IdTipoPoliza=4013
AND ofi.IdDireccionComercial IN (26862, 31690, 26861)

GROUP BY emi.IdOficina, 	
		emi.NumPoliza,
		pag.DescFrecuenciaPago
		
HAVING 	sum(tec.PrimaNeta)>0