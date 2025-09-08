SELECT 'Autos' AS Ramo,
		emi.IdOficina,
		emi.NipAgente,
		emi.NipPerfilAgente,
		aux.NombreAgente,
		
	   sum(tec.PrimaNetaPropiaSinCoaseguro) AS Prima_Emitida,
	   sum(tec.PrimaNetaPagada) AS Pagada
	   
FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
AND emi.NumDocumento=tec.NumDocumento
AND periodo >= 202301

INNER JOIN (

		SELECT age.NipPerfilAgente, age.NipAgente, age.NumPerfil, age.NombreAgente, age.IdOficina
		
		FROM TB_BI_DimAgente AS age
		
		WHERE age.NipAgente IN (SELECT desp.NipAgente
								FROM TB_BI_DimAgenteDespacho desp
								WHERE desp.NombreDespacho LIKE '%familias%')

		) AS aux

ON aux.NipPerfilAgente=emi.NipPerfilAgente

GROUP BY emi.IdOficina,
		emi.NipAgente,
		emi.NipPerfilAgente,
		aux.NombreAgente
		
		
UNION ALL

SELECT 'Daños' AS Ramo,
		emi.IdOficina,
		emi.NipAgente,
		emi.NipPerfilAgente,
		aux.NombreAgente,
		
	    sum(tec.PrimaNetaPropiaSinCoaseguro) AS Prima_Emitida,
	    sum(tec.PrimaNetaPagada) AS Pagada
	   
FROM HDI_DWH.dbo.TB_BI_danFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_danBase2Tecnica AS tec
ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
AND emi.NumDocumento=tec.NumDocumento
AND periodo >= 202301

INNER JOIN (

		SELECT age.NipPerfilAgente, age.NipAgente, age.NumPerfil, age.NombreAgente, age.IdOficina
		
		FROM TB_BI_DimAgente AS age
		
		WHERE age.NipAgente IN (SELECT desp.NipAgente
								FROM TB_BI_DimAgenteDespacho desp
								WHERE desp.NombreDespacho LIKE '%familias%')

		) AS aux

ON aux.NipPerfilAgente=emi.NipPerfilAgente

GROUP BY emi.IdOficina,
		emi.NipAgente,
		emi.NipPerfilAgente,
		aux.NombreAgente
		
