---------------------------------  DAÑOS -----------------------------------------------------
SELECT  
	CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
		END as 'Oficinas Comerciales',
	tec.Periodo,
	sum(tec.PrimaNetaPropiaSinCoaseguro) AS Prima_a_Renovar
 
FROM TB_BI_DanFactEmisionDoc AS emi
	INNER JOIN TB_DWH_DanBaseTecnica AS tec	
		ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		AND tec.NumDocumento=emi.NumDocumento
	LEFT JOIN TB_BI_DimOFicina AS ofi
		ON ofi.IdOficina = emi.IdOficina
WHERE tec.Periodo BETWEEN 202408 AND 202410
 
GROUP BY 
	CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
		END, tec.Periodo;

---------------------------------  AUTOS -----------------------------------------------------
SELECT  
	CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
		END as 'Oficinas Comerciales',
	tec.Periodo,
	sum(tec.PrimaNetaPropiaSinCoaseguro) AS Prima_a_Renovar
 
FROM TB_BI_AutrFactEmisionDoc AS emi
	INNER JOIN TB_BI_AutrBase2Tecnica AS tec	
		ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		AND tec.NumDocumento=emi.NumDocumento
	LEFT JOIN TB_BI_DimOFicina AS ofi
		ON ofi.IdOficina = emi.IdOficina
WHERE tec.Periodo BETWEEN 202408 AND 202410
 
GROUP BY 
	CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
		END, tec.Periodo;

----------------------- GMM -------------------------------------------------------------------------
SELECT 
    CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
	END as 'Oficinas Comerciales',
	gmm.Periodo,
	sum(gmm.Prima_Total) AS 'Prima'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm
LEFT JOIN TB_BI_DimAgente dage ON dage.NipAgente = gmm.NAgente
LEFT JOIN TB_BI_DimOFicina AS ofi ON dage.IdOficina = ofi.IdOficina
WHERE gmm.Periodo BETWEEN 202408 AND 202410
	--AND gmm.NAgente = 
GROUP BY CASE
		WHEN nombreOficinaComercial like '%León%' THEN 'León'
		WHEN nombreOficinaComercial like '%Quer%taro%' THEN 'Querétaro'
		WHEN 
			DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') 
			and nombreOficinaComercial not in ('Toluca', 'Virtuales Expansión', 'Cuernavaca', 'Pachuca', 'Acapulco') THEN 'CDMX'
		WHEN nombreOficinaComercial like '%Guadalajara%' THEN 'Guadalajara'
		WHEN nombreOficinaComercial like '%Monterrey%' THEN 'Monterrey'
		WHEN nombreOficinaComercial like '%Tijuana%' THEN 'Tijuana'
		WHEN nombreOficinaComercial like '%Chihuahua%'THEN 'Chihuahua'
		WHEN nombreOficinaComercial like '%Mérida%' THEN 'Mérida'
		WHEN nombreOficinaComercial like '%Puebla%' THEN 'Puebla'
	END, gmm.Periodo
    order by gmm.Periodo



---------------	PRUEBAS --------------------------------------------
SELECT TOP 20* FROM TB_BI_DanFactEmisionDoc
SELECT TOP 20* FROM TB_DWH_DanBaseTecnica
SELECT * FROM TB_BI_DimOFicina 
WHERE nombreOficinaComercial like '%Puebla%'

Select 
 Top 10*
FROM TB_BI_AutrFactEmisionDoc aut
 INNER JOIN TB_BI_AutrBase2Tecnica tec
   ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
   AND tec.NumDocumento=aut.NumDocumento

SELECT * FROM Dshd.VW_DWH_GMMPrimaNeta 
where CONVERT(INT, FechaFinVigencia) BETWEEN 20241001 AND 20241231
SELECT * FROM TB_BI_DimAgente