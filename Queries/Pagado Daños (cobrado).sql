SELECT
    'daños' RAMO,
    --periodo,
    --ofi.DescSubdireccionComercial,
    --ofi.nombreoficinacomercial,
    ofi.NombreOficina,
    --CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',
    --age.NipPerfilAgente,
    SUM(co.primanppagadaconsolidada) pagada
fROM dbo.VW_BI_DanFactCobrado co
   LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = co.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
where Periodo BETWEEN 202312 and 202312 
    AND age.nombreagente like '%AARCO AGENTE DE SEGUROS Y DE FIANZAS SA DE CV%'

GROUP BY
    --Periodo,
    --ofi.DescSubdireccionComercial,    
    --ofi.nombreoficinacomercial,
    ofi.NombreOficina,
    --CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo),
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente),
    --age.NipPerfilAgente


SELECT * 
FROM TB_BI_DimAgente
where nipperfilagente = 112255


SELEcT * FROM


SELECT  
     -- DISTINCT dan.NumCompletoCotizacion AS cotizaciones, 
						NumPoliza,
						ase.NombreAsegurado,
						CONCAT(age.nipagente, ' ',age.nombreagente) Agente
            ,DescFrecuenciaPago FrecuenciaPago,
            sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida'
				
FROM TB_BI_DanFactEmisionDoc dan
INNER JOIN TB_DWH_DanBaseTecnica tec
   ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
   AND tec.NumDocumento=dan.NumDocumento
LEFT JOIN TB_BI_DimAsegurado ase
	ON ase.CveAsegurado = dan.CveAsegurado
	LEFT JOIN TB_BI_DimAgente age
	ON age.NipAgente = dan.NipAgente
  LEFT JOIN TB_BI_DimFrecuenciaPago fp
  ON fp.IdFrecuenciaPago = dan.IdFrecuenciaPago
WHERE --IdTipoDocumento = 21 and
   dan.NipAgente in (64397,57515)
	--and FechaFinVigencia > '2025-04-23'
  and NombreAsegurado like '%y/o%'

GROUP BY
--dan.NumCompletoCotizacion,
  NumPoliza,
						ase.NombreAsegurado,
						CONCAT(age.nipagente, ' ',age.nombreagente)
            ,DescFrecuenciaPago 

  SELECT * FROM  TB_BI_DanFactEmisionDoc where NumPoliza = 16591 and NipAgente in (57515,64397)
  SELECT * FROM TB_BI_DimFrecuenciaPago
  SELECT * FROM Tb_BI_DimMoneda
  SELECT * FROM TB_BI_DimConductoCobro
  SELECT * FROM TB_BI_DimAsegurado where NombreAsegurado like '%y/o%'