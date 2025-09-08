--------------------------- AUTOS Emitido/Pagado x Periodo,oficina,ejecutivo,mes -------------------------------------------
Select 
    tec.periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida',
    SUM(tec.PrimaNetaPropiaPagada) 'Pagada'

FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
      ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
      AND tec.NumDocumento=aut.NumDocumento
 LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = aut.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo

WHERE
    tec.Periodo BETWEEN 202401 and 202410 
    AND IdSubdireccionComercial = 33107

GROUP BY
    tec.Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)

------------------------------ DAÑOS---------------------------------------------------

Select 
    tec.periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'
    --SUM(tec.PrimaNetaPropiaPagada) 'Pagada'
FROM TB_BI_DanFactEmisionDoc dan
 INNER JOIN TB_DWH_DanBaseTecnica tec
   ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
   AND tec.NumDocumento=dan.NumDocumento
 LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = dan.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
    tec.Periodo BETWEEN 202401 and 202410 
    AND IdSubdireccionComercial = 33107
GROUP BY
    tec.Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)

--------------------------------- GMM Emitida -----------------------------------
SELECT 
    gmm.Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',    
    sum(gmm.Prima_Total) AS 'Prima Emitida'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
   gmm.Periodo BETWEEN 202401 and 202410 
   AND IdSubdireccionComercial = 33107
GROUP BY
    gmm.Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)

--------------------------------- GMM Pagado -----------------------------------
SELECT 
    FORMAT(gmm.FechaPago, 'yyyyMM') Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',    
    sum(gmm.Prima) AS 'Prima Pagada'
FROM VW_DWH_GmmCifrasDiariasPagadas gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NumeroAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
   gmm.FechaPago BETWEEN '2024/01/01' and '2024/10/31'
   AND IdSubdireccionComercial = 33107
GROUP BY
    FORMAT(gmm.FechaPago, 'yyyyMM'),
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)



SELECT * FROM TB_BI_DimEjecutivo
SELECT *  FROM TB_BI_DimAgente
SELECT TOP 3* FROM VW_DWH_GmmCifrasDiariasPagadas



 