SELECT CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
		CASE WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=01 THEN 'Enero'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=04 THEN 'Abril'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=02 THEN 'Febrero'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=03 THEN 'Marzo'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=05 THEN 'Mayo'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=06 THEN 'Junio'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=07 THEN 'Julio'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=08 THEN 'Agosto'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=09 THEN 'Septiembre'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=10 THEN 'Octubre'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=11 THEN 'Noviembre'			
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=12 THEN 'Diciembre' 
		END AS mes,
	   
		age.DescCanalComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		
		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente

LEFT JOIN tb_bi_dimOficina AS ofi 
ON ofi.IdOficina=emi.IdOficina


WHERE emicob.FechaTransaccion BETWEEN 20180101 AND 20231231
AND emi.IdTipoPoliza=4013
AND (ofi.DescSubdireccionComercial IN ('Mexico Despachos', 'Mexico Promotorias') OR ofi.NombreOficinaComercial IN ('León Agentes', 'León Despachos', 'León Promotorias')) 

GROUP BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER),
		age.DescCanalComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		CASE WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=01 THEN 'Enero'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=04 THEN 'Abril'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=02 THEN 'Febrero'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=03 THEN 'MArzo'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=05 THEN 'Mayo'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=06 THEN 'Junio'
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=07 THEN 'Julio'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=08 THEN 'Agosto'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=09 THEN 'Septiembre'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=10 THEN 'Octubre'		
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=11 THEN 'Noviembre'			
		WHEN RIGHT(left(emicob.FechaTransaccion,6),2)=12 THEN 'Diciembre' 
		END
		
ORDER BY CAST (LEFT(emicob.FechaTransaccion,4) AS INTEGER),
		CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) 