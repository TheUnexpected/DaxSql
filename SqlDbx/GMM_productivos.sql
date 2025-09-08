SELECT base.IdOficina,

		count(DISTINCT(base.NombreAgente)) AS Productivos_GMM
		


FROM (

	SELECT  primas.Periodo,
			ofi.IdOficina,
			ofi.DescSubdireccionComercial AS Subdireccion,
			ofi.NombreOficinaComercial AS Oficina_Comercial,
			ofi.NombreOficina AS Oficina_Operativa,
			age.NombreAgente,
			concat(age.NipPerfilAgente, ' - ',age.NombreAgente) AS Agente,
			concat(eje.IdEjecutivo, ' - ', eje.NombreEjecutivo) AS Ejecutivo,
			
			
			sum(primas.Prima_Total) AS Prima_Total
	
	
	FROM (
	
			SELECT isnull(emision.NAgente,cancel.Nagente) AS NAgente,
					isnull(emision.Periodo,cancel.Periodo) AS Periodo,
					isnull(emision.PolSocioComercial,cancel.PolSocioComercial) AS PolSocioComercial,
					isnull(emision.NPoliza,cancel.NPoliza) AS NPoliza,
					isnull(emision.RamoSubramol,cancel.RamoSubramol) AS RamoSubramol,
					isnull(emision.Ftervigpol,cancel.Ftervigpol) AS FechaFinVigencia,
		   			isnull(emision.Emitida,0)-isnull(cancel.Cancelada,0) AS Prima_Total
	
			FROM (
					SELECT gmm_emi.NAgente,
							LEFT(gmm_emi.femirbo,6) AS Periodo,
			   				gmm_emi.PolSocioComercial,
			   				gmm_emi.NPoliza,
			   				gmm_emi.RamoSubramol,
			   				gmm_emi.Ftervigpol,
			   	
							
							sum(gmm_emi.Pma1) AS Emitida
					
					FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi
					
					WHERE LEFT(gmm_emi.femirbo,6) BETWEEN 202201 AND 202402
					
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
					
					WHERE LEFT(gmm_can.Fecha,6) BETWEEN 202201 AND 202402
					
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
			
	) AS primas
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=primas.Nagente
	
	LEFT JOIN tb_bi_dimejecutivo AS eje
	ON eje.IdEjecutivo=age.IdPerfilEjecutivo
	
	INNER  JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	AND ofi.NombreOficinaComercial= 'Guadalajara Promotorías'
	
	GROUP BY   primas.Periodo,
			ofi.IdOficina,
			ofi.DescSubdireccionComercial,
			ofi.NombreOficinaComercial,
			ofi.NombreOficina,
			age.NombreAgente,
		    concat(age.NipPerfilAgente, ' - ',age.NombreAgente),
			concat(eje.IdEjecutivo, ' - ', eje.NombreEjecutivo)
) AS base


WHERE base.Prima_Total!=0

GROUP BY base.IdOficina