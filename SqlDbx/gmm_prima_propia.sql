SELECT  --age.IdOficina, ofi.NombreOficinaComercial, ofi.Descsubdireccioncomercial,
		LEFT(base.Periodo,4) AS Anio, --RIGHT	(base.Periodo,2) AS Mes,
		sum(base.prima_P_total) AS prima_propia,
		sum(base.prima_np_total) AS prima_np
	 

FROM (


		SELECT isnull(emision.NAgente,cancel.Nagente) AS NAgente,
				isnull(emision.Periodo,cancel.Periodo) AS Periodo,
				isnull(emision.PolSocioComercial,cancel.PolSocioComercial) AS PolSocioComercial,
				isnull(emision.NPoliza,cancel.NPoliza) AS NPoliza,
				isnull(emision.RamoSubramol,cancel.RamoSubramol) AS RamoSubramol,
				isnull(emision.Ftervigpol,cancel.Ftervigpol) AS FechaFinVigencia,
	   			isnull(emision.Emitida,0)-isnull(cancel.Cancelada,0) AS Prima_P_Total,
	   			isnull(emision.Emitida_no_p,0)-isnull(cancel.Cancelada_no_p,0) AS Prima_NP_Total

		FROM (
				SELECT gmm_emi.NAgente,
						LEFT(gmm_emi.femirbo,6) AS Periodo,
		   				gmm_emi.PolSocioComercial,
		   				gmm_emi.NPoliza,
		   				gmm_emi.RamoSubramol,
		   				gmm_emi.Ftervigpol,
		   	
						
						sum(gmm_emi.PMA_CobProp) AS Emitida,
						sum(gmm_emi.PMA_CobNoProp) AS Emitida_no_p
				
				FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
				
			   --	WHERE 	LEFT(gmm_emi.femirbo,6) BETWEEN 202401 AND 202403
				
				GROUP BY gmm_emi.NAgente,
						LEFT(gmm_emi.femirbo,6),
		   				gmm_emi.PolSocioComercial,
		   				gmm_emi.NPoliza,
		   				gmm_emi.RamoSubramol,
		   				gmm_emi.Ftervigpol
		
		) AS emision
		
		FULL JOIN (
		
				SELECT gmm_can.NAgente,
						LEFT(gmm_can.Fecha,6) AS Periodo,
		   				gmm_can.PolSocioComercial,
		   				gmm_can.NPoliza,
		   				LEFT(gmm_can.RamoSubramol,charindex(',',gmm_can.RamoSubramol)-1) AS RamoSubramol,
		   				gmm_can.Ftervigpol,
						
						sum(gmm_can.PMA_CobProp) AS Cancelada,
						sum(gmm_can.PMA_CobNoProp) AS cancelada_no_p
				
				FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS gmm_can
				
			   --	WHERE 	LEFT(gmm_can.Fecha,6) BETWEEN 202401 AND 202403
				
				GROUP BY 	gmm_can.NAgente,
						LEFT(gmm_can.Fecha,6),
		   				gmm_can.PolSocioComercial,
		   				gmm_can.NPoliza,
		   				LEFT(gmm_can.RamoSubramol,charindex(',',gmm_can.RamoSubramol)-1),
		   				gmm_can.Ftervigpol
				
		) AS cancel
		
		ON emision.NAgente=cancel.NAgente
		AND emision.Periodo=cancel.Periodo
		AND emision.PolSocioComercial=cancel.PolSocioComercial
		AND emision.NPoliza=cancel.NPoliza
		AND emision.RamoSubramol=cancel.RamoSubramol
		AND emision.Ftervigpol=cancel.Ftervigpol
		
   
		
WHERE isnull(emision.Periodo,cancel.Periodo) BETWEEN 202501 AND 202501

) AS base

left JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NAgente

left JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

GROUP BY  --age.IdOficina, ofi.NombreOficinaComercial, ofi.Descsubdireccioncomercial,
		LEFT(base.Periodo,4)--, RIGHT	(base.Periodo,2) 