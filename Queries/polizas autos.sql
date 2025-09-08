
----- Individual ----------
SELECT
    'INDIVIDUAL' as 'movimiento',
    CONVERT(INT, SUBSTRING(CAST(FechaCotizacion as varchar), 1, 6)) as 'Fecha Cotizacion',
    CONVERT(INT, SUBSTRING(CAST(FechaEmision as varchar), 1, 6)) as 'Fecha Emision',
    NumCompletoCotizacion,
    PLZ,
    NipPerfilAgente,
    IdTarifa,
    IdPaquete
FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica
    WHERE FechaCotizacion > 20250000

--- Flotillas ------
SELECT 
	FORMAT(query.TiempoAltaOt,'dd/MM/yyyy') TiempoAltaOt,
	query.IdOficinaEmision,
	CASE
		WHEN TipoDocumento in ('Claveteo y Cotización','Claveteo y Cotización MODA','Recotización') THEN 'Nuevo'
		WHEN TipoDocumento in ('Registro Renovación') THEN 'Renovado'
	END 'Renovacion',
        EstatusSuscripcion,
	COUNT(idOT) 'Cotizacion',
	COUNT(subquery.OT_Cotizacion) 'Emision'
	
FROM   Dshd.Vw_DWH_AutrMasivosSuscripcion_Impacto query
LEFT JOIN (
	SELECT
		DISTINCT OT_Cotizacion
	FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto
) subquery
ON query.IdOT = subquery.OT_Cotizacion
	WHERE
		Direccion in ('Bajio - Occidente','Mexico - Sur','Norte')
GROUP BY
	FORMAT(query.TiempoAltaOt,'dd/MM/yyyy'),
	query.IdOficinaEmision,
	CASE
		WHEN TipoDocumento in ('Claveteo y Cotización','Claveteo y Cotización MODA','Recotización') THEN 'Nuevo'
		WHEN TipoDocumento in ('Registro Renovación') THEN 'Renovado'
	END,
        EstatusSuscripcion