----------------- AUTOS -------------------------
Select   
 CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) 'Agente',
 tec.Periodo,
 SUM(PrimaNetaPropiaSinCoaseguro) 'Prima Emitida',
 SUM(PrimanetaPropiaPagada) 'Prima Pagada'
FROM TB_BI_AutrFactEmisionDoc aut
 INNER JOIN TB_BI_AutrBase2Tecnica tec
   ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
   AND tec.NumDocumento=aut.NumDocumento
 LEFT JOIN TB_BI_DimAgente age
    ON age.NipPerfilAgente = aut.NipPerfilAgente
WHERE
    age.IdOficina = 607
    AND tec.Periodo BETWEEN 202311 and 202410
    --AND not (PrimaNetaPropiaSinCoaseguro = 0 or PrimanetaPropiaPagada=0)
GROUP BY
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
    tec.Periodo
ORDER BY 
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
    tec.Periodo

----------------------- DAÑOS --------------------------
Select   
 CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) 'Agente',
 tec.Periodo,
 SUM(PrimaNetaPropiaSinCoaseguro) 'Prima Emitida',
 SUM(PrimanetaPropiaPagada) 'Prima Pagada'
FROM TB_BI_DanFactEmisionDoc dan
 INNER JOIN TB_DWH_DanBaseTecnica tec
   ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
   AND tec.NumDocumento=dan.NumDocumento
 LEFT JOIN TB_BI_DimAgente age
    ON age.NipPerfilAgente = dan.NipPerfilAgente
WHERE
    age.IdOficina = 607
    AND tec.Periodo BETWEEN 202311 and 202410
    --AND not (PrimaNetaPropiaSinCoaseguro = 0 or PrimanetaPropiaPagada=0)
GROUP BY
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
    tec.Periodo
ORDER BY 
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
    tec.Periodo

