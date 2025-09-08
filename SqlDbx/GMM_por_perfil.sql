SELECT isnull(emision.Periodo,cancel.Periodo) AS Periodo,
		age.NipAgente AS Clave,
		isnull(emision.NAgente,cancel.Nagente) AS Perfil,
		age.NombreAgente,
				--isnull(emision.Periodo,cancel.Periodo) AS Periodo,
				--isnull(emision.PolSocioComercial,cancel.PolSocioComercial) AS PolSocioComercial,
				--isnull(emision.NPoliza,cancel.NPoliza) AS NPoliza,
				--isnull(emision.RamoSubramol,cancel.RamoSubramol) AS RamoSubramol,
				--isnull(emision.Ftervigpol,cancel.Ftervigpol) AS FechaFinVigencia,
	   			sum(isnull(emision.Emitida,0)-isnull(cancel.Cancelada,0)) AS Prima_Total
 
		FROM (
				SELECT gmm_emi.NAgente,
						LEFT(gmm_emi.femirbo,6) AS Periodo,
		   				gmm_emi.PolSocioComercial,
		   				gmm_emi.NPoliza,
		   				gmm_emi.RamoSubramol,
		   				gmm_emi.Ftervigpol,

						sum(gmm_emi.Pma1) AS Emitida
				FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
				WHERE LEFT(gmm_emi.femirbo,6) BETWEEN 202301 AND 202312
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
						sum(gmm_can.Pma1) AS Cancelada
				FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS gmm_can
				WHERE 	LEFT(gmm_can.Fecha,6) BETWEEN 202301 AND 202312
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
		
		
LEFT JOIN tb_bi_dimagente AS age
ON isnull(emision.NAgente,cancel.Nagente)=age.NipPerfilAgente

GROUP BY isnull(emision.Periodo,cancel.Periodo),
		age.NipAgente,
		isnull(emision.NAgente,cancel.Nagente),
		age.NombreAgente