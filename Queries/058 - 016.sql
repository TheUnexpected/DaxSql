
SELECT 
    ofi.NombreOficina,
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) 'Perfil Agente',
    CONCAT(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) 'Perfil Ejecutivo',
    DescEstatusAgente,
    DescEstatusPerfil
    FROM TB_BI_DimAgente age
    LEFT JOIN TB_BI_DimOficina ofi ON age.IdOficina = ofi.IdOficina
    LEFT JOIN TB_BI_DimEjecutivo eje ON age.IdPerfilEjecutivo = eje.IdEjecutivo
WHERE age.IdPerfilEjecutivo = 430008339

SELECT * FROM TB_BI_DimEjecutivo where NombreEjecutivo like '%Montalvan%' --= 430010212
SELECT * FROM TB_BI_DimAgente where IdPerfilEjecutivo = 430010161 -- NipPerfilAgente = 104748 
SELECT IdOficina, NombreOficina, NombreOficinaComercial FROM TB_BI_DimOficina where nombreOficinaComercial like '%Tijuana%'

/** ------------------------   AUTOS   --------------------------------------- **/

SELECT
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END 'Oficina Operativa',
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente) 'NombreAgente',
    emi.Periodo,
	SUM(tec.PrimaNetaPropiaSinCoaseguro) 'Emision?'
FROM TB_BI_AutrFactEmisionDoc emi
INNER JOIN TB_BI_AutrBase2Tecnica tec	
	ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND tec.NumDocumento=emi.NumDocumento
LEFT JOIN TB_BI_DimAgente dage	
	ON dage.NipPerfilAgente = emi.NipPerfilAgente     
WHERE dage.IdOficina in (016, 058) 
    AND emi.Periodo BETWEEN 202301 and 202410
 
GROUP BY 
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END,
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente),
    emi.Periodo
ORDER BY 
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END,
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente),
    emi.Periodo

------------------- DAÑOS ------------------------------------------

SELECT
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END 'Oficina Operativa',
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente) 'NombreAgente',
    tec.Periodo,
	SUM(tec.PrimaNetaPropiaSinCoaseguro) 'Emision?'
FROM TB_BI_DanFactEmisionDoc emi
INNER JOIN TB_DWH_DanBaseTecnica tec	
	ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND tec.NumDocumento=emi.NumDocumento
LEFT JOIN TB_BI_DimAgente dage	
	ON dage.NipPerfilAgente = emi.NipPerfilAgente     
WHERE dage.IdOficina in (016, 058) 
    AND tec.Periodo BETWEEN 202301 and 202410
 
GROUP BY 
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END,
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente),
    tec.Periodo
ORDER BY 
    CASE
        WHEN dage.IdOficina = 016 THEN '016 Ensenada'
        WHEN dage.IdOficina = 058 THEN '058 Tijuana'
    END,
    CONCAT(dage.NipPerfilAgente, ' ', dage.NombreAgente),
    tec.Periodo