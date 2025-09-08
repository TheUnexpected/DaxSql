SELECT 
	age.NipAgente,
	age.NipPerfilAgente,
	age.NombreAgente,
	ofi.NombreOficinaComercial,
	ofi.NombreOficina,
	ofi.IdOficina,
	prima.periodo,
	sum(prima.PrimaEmitida) AS PrimaEmitida,
	sum(prima.Pagada) AS PrimaPagada
	


FROM (

		   
		    SELECT  
		    		 tec.Periodo,
		             emi.IdOficina,
		             emi.NipPerfilAgente,
		             emi.NipAgente,
		             sum(Tec.PrimaNetaPropiaSinCoaseguro)AS PrimaEmitida,
		             sum(tec.PrimaNetaPropiaPagada) AS Pagada
		
		    FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS Emi
		
		
		    INNER JOIN TB_DWH_DanBaseTecnica AS Tec
		    ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		    AND tec.NumDocumento=emi.NumDocumento
		    AND Tec.Periodo  BETWEEN 202401 AND 202410
		   
			
			WHERE emi.IdOficina IN (10, 13, 27, 926,3,556)
		 
		 
		
		    GROUP BY tec.Periodo,
		             emi.IdOficina,
		             emi.NipPerfilAgente,
		             emi.NipAgente
					

) AS prima



LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=prima.idoficina


LEFT JOIN TB_BI_DimAgente AS age 
ON age.NipPerfilAgente=prima.nipperfilagente


WHERE age.NipPerfilAgente IN (3016,5743,61541,70327,90187,91772,91954,94743,95339,98006,98088,99557,102097,102249,103892,103898,104996,105335,105378,105379,105638,
108145,108336,108567,108603,108718,108882,109246,109282,109358,109375,109376,109418,109547,109593,110202,110203,110265,
110434,110456,110537,111009,111825,111826,111827,111828,111829,111830,111831,111832,111935,111953,112131,112133,112154)

GROUP BY 
		age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		ofi.IdOficina,
		prima.periodo