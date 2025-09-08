SELECT  --ofi.descdireccioncomercial,
		--ofi.descsubdireccioncomercial,
		--age.DescCanalComercial,
		--CASE WHEN base.renueva !=0 THEN 'Renovacion'
		--ELSE 'Nueva' END AS Conservacion,
		
		base.periodo,
		--base.NAgente,
		
		
		sum(base.prima_total) AS prima_emitida

FROM (


		SELECT isnull(isnull(isnull(emision.NAgente,cancel.Nagente),emi_colectivo.Nagente),cancel_c.Nagente) AS NAgente,
				isnull(isnull(isnull(emision.Periodo,cancel.Periodo),emi_colectivo.Periodo),cancel_c.Periodo) AS Periodo,
				isnull(isnull(isnull(emision.PolSocioComercial,cancel.PolSocioComercial),emi_colectivo.PolSocioComercial),cancel_c.PolSocioComercial) AS PolSocioComercial,
				isnull(isnull(isnull(emision.NPoliza,cancel.NPoliza),emi_colectivo.NPoliza),cancel_c.NPoliza) AS NPoliza,
				isnull(isnull(isnull(emision.RamoSubramol,cancel.RamoSubramol),emi_colectivo.RamoSubramol),cancel_c.RamoSubramol) AS RamoSubramol,
				isnull(isnull(isnull(emision.Ftervigpol,cancel.Ftervigpol),emi_colectivo.Ftervigpol),cancel_c.Ftervigpol) AS FechaFinVigencia,
				isnull(isnull(isnull(emision.Renueva,cancel.Renueva),emi_colectivo.Renueva),cancel_c.Renueva) AS Renueva,
	   		
	   			isnull(emision.Emitida,0)-isnull(cancel.Cancelada,0)+isnull(emi_colectivo.Emitida_c,0)-isnull(cancel_c.Cancelada,0) AS Prima_Total

		FROM (
				SELECT gmm_emi.NAgente,
						LEFT(gmm_emi.femirbo,6) AS Periodo,
		   				gmm_emi.PolSocioComercial,
		   				gmm_emi.NPoliza,
		   				gmm_emi.RamoSubramol,
		   				gmm_emi.Ftervigpol,
		   				gmm_emi.Renueva,
		   	
						
						sum(gmm_emi.Pma1) AS Emitida
				
				FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
				
			   --	WHERE 	LEFT(gmm_emi.femirbo,6) BETWEEN 202401 AND 202403
				
				GROUP BY gmm_emi.NAgente,
						LEFT(gmm_emi.femirbo,6),
		   				gmm_emi.PolSocioComercial,
		   				gmm_emi.NPoliza,
		   				gmm_emi.RamoSubramol,
		   				gmm_emi.Ftervigpol,
		   				gmm_emi.Renueva
		
		) AS emision
		
		FULL JOIN (
		
				SELECT gmm_can.NAgente,
						LEFT(gmm_can.Fecha,6) AS Periodo,
		   				gmm_can.PolSocioComercial,
		   				gmm_can.NPoliza,
		   				LEFT(gmm_can.RamoSubramol,charindex(',',gmm_can.RamoSubramol)-1) AS RamoSubramol,
		   				gmm_can.Ftervigpol,
		   				gmm_can.Renueva,
						
						sum(gmm_can.Pma1) AS Cancelada
				
				FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS gmm_can
				
			   --	WHERE 	LEFT(gmm_can.Fecha,6) BETWEEN 202401 AND 202403
				
				GROUP BY 	gmm_can.NAgente,
						LEFT(gmm_can.Fecha,6),
		   				gmm_can.PolSocioComercial,
		   				gmm_can.NPoliza,
		   				LEFT(gmm_can.RamoSubramol,charindex(',',gmm_can.RamoSubramol)-1),
		   				gmm_can.Ftervigpol,
		   				gmm_can.Renueva
				
		) AS cancel
		
		ON emision.NAgente=cancel.NAgente
		AND emision.Periodo=cancel.Periodo
		AND emision.PolSocioComercial=cancel.PolSocioComercial
		AND emision.NPoliza=cancel.NPoliza
		AND emision.RamoSubramol=cancel.RamoSubramol
		AND emision.Ftervigpol=cancel.Ftervigpol
		AND emision.renueva=cancel.renueva
		
	FULL JOIN (
		
				SELECT emi_c.NAgente,
						LEFT(emi_c.FemiRbo,6) AS Periodo,
		   				emi_c.PolSocioComercial,
		   				emi_c.NPoliza,
		   				emi_c.RamoSubramol,
		   				emi_c.Ftervigpol,
		   				emi_c.Renueva,
						
						sum(emi_c.Pma1) AS Emitida_c
				
				FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS emi_c
				
				GROUP BY 	emi_c.NAgente,
						LEFT(emi_c.FemiRbo,6),
		   				emi_c.PolSocioComercial,
		   				emi_c.NPoliza,
		   				emi_c.RamoSubramol,
		   				emi_c.Ftervigpol,
		   				emi_c.Renueva
				
		) AS emi_colectivo


	ON emision.NAgente=emi_colectivo.NAgente
	AND emision.Periodo=emi_colectivo.Periodo
	AND emision.PolSocioComercial=emi_colectivo.PolSocioComercial
	AND emision.NPoliza=emi_colectivo.NPoliza
	AND emision.RamoSubramol=emi_colectivo.RamoSubramol
	AND emision.Ftervigpol=emi_colectivo.Ftervigpol
	AND emision.renueva=emi_colectivo.renueva


	FULL JOIN (
		
				SELECT can_c.NAgente,
						LEFT(can_c.Fecha,6) AS Periodo,
		   				can_c.PolSocioComercial,
		   				can_c.NPoliza,
		   				LEFT(can_c.RamoSubramol,charindex(',',can_c.RamoSubramol)-1) AS RamoSubramol,
		   				can_c.Ftervigpol,
		   				can_c.Renueva,
						
						sum(can_c.Pma1) AS Cancelada
				
				FROM dbo.TB_DWH_GmmcEmitidoCancelaciones_CargaDiaria AS can_c
				
			   --	WHERE 	LEFT(gmm_can.Fecha,6) BETWEEN 202401 AND 202403
				
				GROUP BY 	can_c.NAgente,
						LEFT(can_c.Fecha,6),
		   				can_c.PolSocioComercial,
		   				can_c.NPoliza,
		   				LEFT(can_c.RamoSubramol,charindex(',',can_c.RamoSubramol)-1),
		   				can_c.Ftervigpol,
		   				can_c.Renueva
				
		) AS cancel_c
		
		ON emision.NAgente=cancel_c.NAgente
		AND emision.Periodo=cancel_c.Periodo
		AND emision.PolSocioComercial=cancel_c.PolSocioComercial
		AND emision.NPoliza=cancel_c.NPoliza
		AND emision.RamoSubramol=cancel_c.RamoSubramol
		AND emision.Ftervigpol=cancel_c.Ftervigpol
		AND emision.renueva=cancel_c.renueva
		
		
WHERE isnull(isnull(isnull(emision.Periodo,cancel.Periodo),emi_colectivo.Periodo),cancel_c.Periodo) BETWEEN 202505 AND 202505

) AS base

left JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NAgente

left JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

--WHERE CAST(age.fechaalta AS DATE)>='2022-01-01'


GROUP BY base.periodo
		--base.NAgente

--HAVING sum(base.prima_total)>=50000 AND sum(base.prima_total)<=500000