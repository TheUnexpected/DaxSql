SELECT 
	   CASE WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220701 AND 20220731 THEN 'Jul-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220801 AND 20220831 THEN 'Ago-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220901 AND 20220930 THEN 'Sep-22'	
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221001 AND 20221031 THEN 'Oct-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221101 AND 20221130 THEN 'Nov-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221201 AND 20221231 THEN 'Dic-22'
		  	WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230701 AND 20230731 THEN 'Jul-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230801 AND 20230831 THEN 'Ago-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230901 AND 20230930 THEN 'Sep-23'	
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231001 AND 20231031 THEN 'Oct-23'		
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231101 AND 20231130 THEN 'Nov-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231201 AND 20231231 THEN 'Dic-23'
			ELSE 'otro'
			END AS Periodo,
		
		ofi.DescDireccionComercial,
		
  
		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob

INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4


inner JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento
AND emi.IdPaquete NOT IN (SELECT idpaquete FROM TB_BI_DimPaquete WHERE DescPaquete IN ('ELITE', 'HDI ELITE'))
AND emi.IdTipoPoliza=4013

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina

inner  JOIN (SELECT aseg.cveasegurado 

			FROM TB_BI_DimAsegurado AS aseg
			WHERE IdEstado=9 OR aseg.NombreMunicipio IN ('GUADALAJARA', 'MONTERREY', 'LEON','PUEBLA','TIJUANA','QUERETARO','MERIDA','CHIHUAHUA')
			) AS aseg
			
ON aseg.CveAsegurado=emi.CveAsegurado

WHERE (emicob.FechaTransaccion BETWEEN 20220701 AND 20221231
OR emicob.FechaTransaccion BETWEEN 20230701 AND 20231231) AND emicob.IdModulo != 0


GROUP BY 
		   	CASE WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220701 AND 20220731 THEN 'Jul-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220801 AND 20220831 THEN 'Ago-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20220901 AND 20220930 THEN 'Sep-22'	
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221001 AND 20221031 THEN 'Oct-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221101 AND 20221130 THEN 'Nov-22'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20221201 AND 20221231 THEN 'Dic-22'
		  	WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230701 AND 20230731 THEN 'Jul-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230801 AND 20230831 THEN 'Ago-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20230901 AND 20230930 THEN 'Sep-23'	
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231001 AND 20231031 THEN 'Oct-23'		
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231101 AND 20231130 THEN 'Nov-23'
			WHEN CAST(emicob.FechaTransaccion AS INT) BETWEEN 20231201 AND 20231231 THEN 'Dic-23'
			ELSE 'otro'
			END,
		ofi.DescDireccionComercial