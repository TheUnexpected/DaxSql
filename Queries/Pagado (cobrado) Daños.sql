--------------------------- AUTOS Emitido/Pagado x Periodo,oficina,ejecutivo,mes -------------------------------------------
Select 
    tec.periodo,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    age.nipagente,
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente'
    ,sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'
    ,SUM(tec.PrimaNetaPropiaPagada) 'Pagada'    
    --sum(tec.primanetapropiaemitidadevengada) 'Devengado',
    --sum(tec.ocurrido) 'Ocurrido'
    --,sum(tec.unidadesemitidasreales) 'unidades'
  SELECT tec.Periodo, sum(UnidadesExpuestasMes)
FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
      ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
      AND tec.NumDocumento=aut.NumDocumento where tec.Periodo in (202401, 202412) and IdOficina =586 group by tec.periodo
 LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = aut.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo

WHERE
    tec.Periodo BETWEEN 202501 and 202506
    AND age.NipPerfilAgente in (93440)
    --and ofi.IdOficina in (617,106)
    --and not aut.idtipopoliza = 4013
    --and ofi.nombreoficinacomercial like '%Toluca%'

GROUP BY
    tec.periodo,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    age.nipagente,
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)
    --,aut.NumPoliza


------------------------------ DAÑOS---------------------------------------------------
Select 
    tec.periodo,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    age.nipagente,
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'
    --tec.NumSiniestro
    --SUM(tec.PrimaNetaPropiaPagada) 'Pagada'
    --sum(tec.primanetapropiaemitidadevengada) 'Devengado',
    --sum(tec.ocurrido) 'Ocurrido'
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
    tec.Periodo BETWEEN 202501 and 202506
    --AND ofi.IdOficina = 1032
    and age.NipPerfilAgente in (52672,4304,99483,115104,108336)
GROUP BY
    tec.Periodo,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    age.nipagente,
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)
   

--------------------------------- GMM Emitida -----------------------------------
SELECT 
    LEFT(gmm.Periodo,4) año,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    --CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    --age.nipagente,
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',
    --gmm.RamoSubRamol,
    sum(gmm.Prima_Total) AS 'Prima Emitida'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
   --gmm.Periodo BETWEEN 202501 and 202506
   --LEFT(gmm.periodo) = 2024
   ofi.NombreOficinaComercial in ('Agentes y Despachos en Desarrollo','Cuentas Especiales',
'Guadalajara Agentes','Guadalajara Despachos','Guadalajara Promotorías','León Agentes','León Despachos',
'León Promotorias','México Despachos Sur','México Polanco','México Satélite','Monterrey Agentes',
'Monterrey Despachos','Monterrey Promotorías','Promotorías México Centro','Promotorías México Insurgentes',
'Promotorías México Polanco','Promotorías México Satélite','Puebla','Querétaro Agentes','Queretaro Despachos','Queretaro Promotorias','Toluca')
  --  AND ofi.NombreOficinaComercial like '%Toluca%'
GROUP BY
    LEFT(gmm.Periodo,4),
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina
    
ORDER BY ofi.NombreOficina, LEFT(gmm.Periodo,4)
    --CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    --age.nipagente,
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)

--------------------------------- GMM Pagado -----------------------------------
SELECT 
    FORMAT(gmm.FechaPago, 'yyyyMM') Periodo,
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    age.nipagente,
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',    
    sum(gmm.Prima) AS 'Prima Pagada'
FROM VW_DWH_GmmCifrasDiariasPagadas gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NumeroAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
   gmm.FechaPago BETWEEN '2025/01/01' and '2025/06/30'
   AND age.NipPerfilAgente in (52672,4304,99483,115104,108336)
GROUP BY
    FORMAT(gmm.FechaPago, 'yyyyMM'),
    --ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    age.nipagente,
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)



SELECT * FROM TB_BI_DimEjecutivo
SELECT *  FROM TB_BI_DimAgente
SELECT TOP 3* FROM VW_DWH_GmmCifrasDiariasPagadas



 