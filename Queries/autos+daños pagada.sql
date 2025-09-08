--------------------------- AUTOS Emitido/Pagado x Periodo,oficina,ejecutivo,mes -------------------------------------------
Select
    --tec.periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida',
    SUM(tec.PrimaNetaPropiaPagada) 'Pagada'
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
    tec.Periodo BETWEEN 202301 and 202312 
    and ofi.idoficina in (110, 886 , 931)
GROUP BY
    --tec.Periodo,
    ofi.NombreOficina,
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente)

---------------------------- autos + daños --------------------------------------

SELECT 
   NipPerfilAgente,
   NombreOficina,    
   Agente,
   Ejecutivo,
   sum([Emitida]) Emitida,
   sum([Pagada]) Pagada/*,
   sum([Devengada R12]) Devengado,
   SUM([Siniestros R12]) Siniestros*/
FROM (
Select 
    age.NipPerfilAgente,
    ofi.NombreOficina,    
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida',
    SUM(tec.PrimaNetaPropiaPagada) 'Pagada'/*,
    SUM(tec.PrimaNetaPropiaEmitidaDevengada)'Devengada R12',
	  SUM(tec.ocurrido)'Siniestros R12'*/

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
    tec.Periodo BETWEEN 202301 and 202312
    AND ofi.IdOficina in (110, 886, 931)

GROUP BY
    age.NipPerfilAgente,
    ofi.NombreOficina,
    CONCAT(age.NipPerfilAgente,' ', age.NombreAgente),
    CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo)
    
UNION

Select 
    age.NipPerfilAgente,
    ofi.NombreOficina,
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente) 'Agente',    
    CONCAT(age.IdPerfilEjecutivo, ' ',eje.NombreEjecutivo) 'Ejecutivo',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida',
    SUM(tec.PrimaNetaPropiaPagada) 'Pagada'
    --SUM(tec.PrimaNetaPropiaEmitidaDevengada)'Devengada R12',
	  --SUM(tec.ocurrido)'Siniestros R12'
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
    tec.Periodo BETWEEN 202301 and 202312
    AND ofi.IdOficina in (110, 886, 931)
GROUP BY
    age.NipPerfilAgente,
    ofi.NombreOficina,
    CONCAT(age.NipPerfilAgente, ' ',age.NombreAgente),    
    CONCAT(age.IdPerfilEjecutivo, ' ',eje.NombreEjecutivo)

) as AutDan
GROUP BY
  NipPerfilAgente,
   NombreOficina,    
   Agente,
   Ejecutivo


SELECT * FROM tb_bi_dimoficina