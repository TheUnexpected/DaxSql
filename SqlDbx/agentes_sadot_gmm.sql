SELECT aux.Nagente,
		sum(aux.Prima_Total)

FROM(   
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
				
				WHERE gmm_emi.FemiRbo<=20231231
				
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
				
				WHERE gmm_can.Fecha<=20231231
				
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
		
		
		WHERE isnull(emision.NAgente,cancel.Nagente) IN (53375,53262,53384,53297,102194,53164,53423,53345,53225,53150,53294,108034,53257,53382,53536,105565,53685,
69799,60116,53873,53761,59622,55166,54034,54113,54851,55124,54156,54778,98380,54241,54243,55182,53864,55818,56438,69347,105690,56354,56620,56849,55753,56538,57895,57120,56239,105571,59042,
56614,56550,56915,57150,56889,90373,57119,58138,102541,57583,58082,69077,57933,69995,61255,67118,58772,59458,59472,59294,58704,58541,58708,
58586,105953,101870,63046,67755,58968,59088,110433,108815,61948,61955,61959,61778,63300,63301,66136,63013,63165,61993,63990,103573,69792,64925,
90329,69724,66378,91645,108659,95335,96149,103845,103362,103269,103459,104189,104539,104540,104605,104670,104679,104913,
104914,104943,105416,106107,106373,106376,105574,105656,108024,110018,110532,112145,112158,112354,105730,111533)
	
) AS aux

GROUP BY aux.Nagente