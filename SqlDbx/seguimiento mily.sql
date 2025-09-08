SELECT 	'Autos' AS Ramo,
		CASE WHEN tec.Periodo IN (202401,202402,202403) THEN 'Q1'
		WHEN tec.Periodo IN (202404,202405,202406) THEN 'Q2'
		ELSE 'Q3' END AS Trimestre,
		agen.Direccion,
		agen.Subdireccion,
		agen.Oficina_Comercial,
		agen.IdOficina,
		emi.NipPerfilAgente,
		emi.NipAgente,
		agen.NombreAgente,
		
		round(sum(tec.Primanetapropiasincoaseguro),0) AS Emitida,
		round(sum(tec.Primanetapropiapagada),0) AS Pagada
		

FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumcompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.periodo BETWEEN 202401 AND 202409

INNER JOIN (
	
	
	SELECT age.NipPerfilAgente,
			age.NipAgente,
			age.NombreAgente,
			age.FechaAlta,
			ofi.DescDireccionComercial AS Direccion,
			ofi.DescSubdireccionComercial AS Subdireccion,
			ofi.NombreOficinaComercial AS Oficina_Comercial,
			ofi.IdOficina
	
	FROM TB_BI_DimAgente AS age 
	
	INNER JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	AND ofi.IdDireccionComercial IN (31690,26859,26861,26862)
	
	WHERE age.FechaAlta BETWEEN '20240101' AND '20240930'
	AND age.IdTipoAgente=19
	AND age.DescEstatusAgente IN ('VIGOR')
	--AND age.IdTipoPersona=1
	--AND age.NumPerfil=1

) AS agen

ON agen.NipPerfilAgente=emi.NipPerfilAgente

GROUP BY CASE WHEN tec.Periodo IN (202401,202402,202403) THEN 'Q1'
		WHEN tec.Periodo IN (202404,202405,202406) THEN 'Q2'
		ELSE 'Q3' END,
		agen.Direccion,
		agen.Subdireccion,
		agen.Oficina_Comercial,
		agen.IdOficina,
		emi.NipPerfilAgente,
		emi.NipAgente,
		agen.NombreAgente
		
UNION ALL 

SELECT 	'Daños' AS Ramo,
		CASE WHEN tec.Periodo IN (202401,202402,202403) THEN 'Q1'
		WHEN tec.Periodo IN (202404,202405,202406) THEN 'Q2'
		ELSE 'Q3' END  AS Trimestre,
		agen.Direccion,
		agen.Subdireccion,
		agen.Oficina_Comercial,
		agen.IdOficina,
		emi.NipPerfilAgente,
		emi.NipAgente,
		agen.NombreAgente,
		
		round(sum(tec.Primanetapropiasincoaseguro),0) AS Emitida,
		round(sum(tec.Primanetapropiapagada),0) AS Pagada
		

FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi

INNER JOIN tb_DWH_DanBaseTecnica AS tec
ON tec.NumcompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.periodo BETWEEN 202401 AND 202409

INNER JOIN (
	
	
	SELECT age.NipPerfilAgente,
			age.NipAgente,
			age.NombreAgente,
			age.FechaAlta,
			ofi.DescDireccionComercial AS Direccion,
			ofi.DescSubdireccionComercial AS Subdireccion,
			ofi.NombreOficinaComercial AS Oficina_Comercial,
			ofi.IdOficina
	
	FROM TB_BI_DimAgente AS age 
	
	INNER JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	AND ofi.IdDireccionComercial IN (31690,26859,26861,26862)
	
	WHERE age.FechaAlta BETWEEN '20240101' AND '20240930'
	AND age.IdTipoAgente=19
	AND age.DescEstatusAgente IN ('VIGOR')
	--AND age.IdTipoPersona=1
	--AND age.NumPerfil=1

) AS agen

ON agen.NipPerfilAgente=emi.NipPerfilAgente

GROUP BY CASE WHEN tec.Periodo IN (202401,202402,202403) THEN 'Q1'
		WHEN tec.Periodo IN (202404,202405,202406) THEN 'Q2'
		ELSE 'Q3' END ,
		agen.Direccion,
		agen.Subdireccion,
		agen.Oficina_Comercial,
		agen.IdOficina,
		emi.NipPerfilAgente,
		emi.NipAgente,
		agen.NombreAgente