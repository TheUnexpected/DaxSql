SELECT  age.nombreagente,
		CASE WHEN base.EstatusSuscripcion= 'Terminado' THEN base.EstatusSuscripcion
		ELSE 'No_Terminada' end AS Estatus,
		
		count(base.IdOt) AS cotizaciones,
		sum(base.plz) AS Polizas
		
	
FROM(

	SELECT cot.*, emisiones.*,
			CASE WHEN emisiones.ot_cotizacion IS NULL THEN 0
			ELSE 1 END AS PLZ
	
	FROM Dshd.Vw_DWH_AutrMasivosSuscripcion_Impacto AS cot
	
	LEFT join 
	
		(	SELECT DISTINCT OT_Cotizacion
		
			FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto AS Emi
			
			WHERE Emi.FechaEmision >= '2024-01-01'
			
		) AS emisiones
		  
	
	ON emisiones.OT_cotizacion=cot.IdOT	
	
	WHERE cot.TiempoAltaOt BETWEEN '2024-01-01' AND '2024-12-31'
	AND cot.TipoDocumento IN ('Claveteo y Cotización','Claveteo y Cotización MODA', 'Recotización')
			
) AS base

LEFT JOIN tb_Bi_dimagente AS age
ON age.nipperfilagente=CAST(base.NipPerfilAgente AS INTEGER)

WHERE base.NipPerfilAgente != '1908 A'

GROUP BY age.nombreagente,
		CASE WHEN base.EstatusSuscripcion= 'Terminado' THEN base.EstatusSuscripcion
		ELSE 'No_Terminada' end