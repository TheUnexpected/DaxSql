
SELECT ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial,
		tec.Periodo,
		'Autos' AS Ramo,
	   

		sum(tec.PrimaNetaPropiaSinCoaseguro) AS emitida

FROM TB_BI_AutrFactEmisionDoc AS emi
		
INNER JOIN TB_BI_AutrBase2Tecnica AS tec	
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND (tec.Periodo BETWEEN 202407 AND 202408
OR tec.Periodo BETWEEN 202307 and 202308)

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina


WHERE ofi.IdDireccionComercial IN (26862,31690, 26861)

GROUP BY ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		tec.Periodo
		
UNION 


SELECT ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial,
	  	tec.Periodo,
		'Daños' AS Ramo,
	   

		sum(tec.PrimaNetaPropiaSinCoaseguro) AS emitida

FROM TB_BI_DanFactEmisionDoc AS emi
		
INNER JOIN TB_DWH_DanBaseTecnica AS tec	
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND (tec.Periodo BETWEEN 202407 AND 202408
OR tec.Periodo BETWEEN 202307 and 202308)

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina


WHERE ofi.IdDireccionComercial IN (26862,31690, 26861)

GROUP BY ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		tec.Periodo


UNION 

SELECT ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial,
		gmm.Periodo,
		'GMM' AS Ramo,
	   

	    sum(gmm.Prima_Total)  AS emitida

FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=gmm.IdOficina


WHERE ofi.IdDireccionComercial IN (26862,31690, 26861)
AND (gmm.Periodo BETWEEN 202407 AND 202408
OR gmm.Periodo BETWEEN 202307 and 202308)

GROUP BY ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		gmm.Periodo

