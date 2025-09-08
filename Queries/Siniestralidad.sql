---------------------------- AUTOS -----------------------------------
SELECT 
		dage.IdOficina,
        CONCAT(emi.NipAgente, ' ', dage.NombreAgente) 'Nombre Agente',
        SUM(tec.PrimaNetaPropiaEmitidaDevengada)'Devengada R12',
		SUM(tec.ocurrido)'Siniestros R12'
        --SUM(tec.costosiniestroocurrido)
FROM TB_BI_AutrFactEmisionDoc emi
INNER JOIN TB_BI_AutrBase2Tecnica tec	
	ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND tec.NumDocumento=emi.NumDocumento
LEFT JOIN TB_BI_DimAgente dage	
	ON dage.NipPerfilAgente = emi.NipPerfilAgente
 
WHERE tec.Periodo BETWEEN 202311 and 202410
      AND dage.IdOficina in (110, 886, 931)
GROUP BY dage.IdOficina,
       CONCAT(emi.NipAgente, ' ', dage.NombreAgente)

--------------------------------  DAÑOS ---------------------------------------
SELECT 
		dage.IdOficina,
        CONCAT(dan.NipAgente, ' ', dage.NombreAgente) 'Nombre Agente',
        SUM(tec.PrimaNetaPropiaEmitidaDevengada)'Devengada R12',
		SUM(tec.ocurrido)'Siniestros R12'
        --SUM(tec.costosiniestroocurrido)
FROM TB_BI_DanFactEmisionDoc dan
 INNER JOIN TB_DWH_DanBaseTecnica tec
   ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
   AND tec.NumDocumento=dan.NumDocumento
LEFT JOIN TB_BI_DimAgente dage	
	ON dage.NipPerfilAgente = dan.NipPerfilAgente
 
WHERE tec.Periodo BETWEEN 202311 and 202410
      AND dage.IdOficina in (110, 886, 931)
GROUP BY dage.IdOficina,
       CONCAT(dan.NipAgente, ' ', dage.NombreAgente)

-----------------------------------------------------------------------------

SELECT * FROM TB_BI_DimEjecutivo where NombreEjecutivo like '%Erick Montalvan%'
SELECT * FROM TB_BI_DimOficina where  idOficina = 931

SELECT TOP 10* FROM TB_BI_DimAgente