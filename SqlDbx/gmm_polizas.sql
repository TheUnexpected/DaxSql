SELECT aux.Oficina,
		aux.NPoliza,
		aux.NAgente,
		aux.Fecha,
		aux.PolSocioComercial,
		aux.RamoSubramol,
		aux.Ftervigpol,
		aux.renueva,
		
		sum(p_total) AS P_total


FROM(

	SELECT distinct emi.Oficina, 
			emi.NPoliza,
			emi.NAgente,
		   	concat(LEFT(emi.femirbo,6),'01') as Fecha,
		   	emi.PolSocioComercial,
		   	emi.RamoSubramol,
		   	emi.Ftervigpol,
		   	emi.Renueva,
		   	
		   	sum(emi.Pma1) AS p_total
			 
	
	
	FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS emi
	
	WHERE isnull(emi.Tipo_Recibo,0)!=2
	
	                
	GROUP BY  emi.Oficina, 
			emi.NPoliza,
			emi.NAgente,
		   	concat(LEFT(emi.femirbo,6),'01'),
		   	emi.PolSocioComercial,
		   	emi.RamoSubramol,
		   	emi.Ftervigpol,
		   	emi.Renueva
		   	
	UNION ALL   	
		   	
	SELECT can.Oficina, 
			can.NPoliza,
			can.NAgente,
		   	concat(LEFT(can.Fecha,6),'01') AS Fecha,
		   	can.PolSocioComercial,
		   	LEFT(can.RamoSubramol,charindex(',',can.RamoSubramol)-1) AS RamoSubramol,
		   	can.Ftervigpol,
		   	can.Renueva,
		   	
		   	-sum(can.Pma1) AS p_total
			 
	
	
	FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS can
	
	WHERE isnull(can.Tipo_Recibo,0)!=2
	
	
	GROUP BY can.Oficina, 
			can.NPoliza,
			can.NAgente,
		   	concat(LEFT(can.Fecha,6),'01'),
		   	can.PolSocioComercial,
		   	LEFT(can.RamoSubramol,charindex(',',can.RamoSubramol)-1),
		   	can.Ftervigpol,
		   	can.Renueva
	

) AS aux


GROUP BY aux.Oficina,
		aux.NPoliza,
		aux.NAgente,
		aux.Fecha,
		aux.PolSocioComercial,
		aux.RamoSubramol,
		aux.Ftervigpol,
		aux.renueva