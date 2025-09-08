-------------------  Emision ----------------------
SELECT 
    base.RamoSubramol Subramo,
    ofi.IdOficina Oficina,
    ofi.DescSubdireccionComercial Subdireccion,
    ofi.NombreOficinaComercial 'Oficina Comercial',
    ofi.NombreOficina 'Oficina Operativa',
    base.NPoliza Poliza,
    base.Folio Folio, 
    base.Contrat Contratante,
    base.FMaPago 'Forma de Pago',
    base.FemiRbo,
    base.Finivig,
    base.Ftervig,
    base.Prima_Total,
    base.NAgente,
    age.NombreAgente,
    base.Renueva,
    base.PolSocioComercial

FROM
  ( SELECT 
        isnull(emision.NAgente,emi_colectivo.Nagente) AS NAgente,
        isnull(emision.Periodo,emi_colectivo.Periodo) AS Periodo,
        isnull(emision.PolSocioComercial,emi_colectivo.PolSocioComercial) AS PolSocioComercial,
        isnull(emision.NPoliza,emi_colectivo.NPoliza) AS NPoliza,
        isnull(emision.FolioRbo,emi_colectivo.FolioRbo) AS Folio,
        isnull(emision.RamoSubramol,emi_colectivo.RamoSubramol) AS RamoSubramol,
        isnull(emision.Ftervigpol,emi_colectivo.Ftervigpol) AS FechaFinVigencia,
        isnull(emision.Contrat,emi_colectivo.Contrat) AS Contrat,
        isnull(emision.FMaPago,emi_colectivo.FMaPago) AS FMaPago,
        isnull(emision.FemiRbo,emi_colectivo.FemiRbo) AS FemiRbo,
        isnull(emision.Finivig,emi_colectivo.Finivig) AS Finivig,
        isnull(emision.Ftervig,emi_colectivo.Ftervig) AS Ftervig,
        isnull(emision.Renueva,emi_colectivo.Renueva) AS Renueva,
        isnull(emision.Emitida,0)+isnull(emi_colectivo.Emitida_c,0) AS Prima_Total
    FROM(
        (SELECT gmm_emi.NAgente,
            LEFT(gmm_emi.femirbo,6) AS Periodo,
            gmm_emi.PolSocioComercial,
            gmm_emi.NPoliza,
            gmm_emi.FolioRbo,
            gmm_emi.RamoSubramol,
            gmm_emi.Ftervigpol,
            gmm_emi.Contrat,
            gmm_emi.FMaPago,
            gmm_emi.FemiRbo,
            gmm_emi.Finivig,
            gmm_emi.Ftervig,
            gmm_emi.Renueva,
            gmm_emi.Pma1 AS Emitida
        FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm_emi     
        ) AS emision
        FULL JOIN
        (SELECT emi_c.NAgente,
            LEFT(emi_c.FemiRbo,6) AS Periodo,
            emi_c.PolSocioComercial,
            emi_c.NPoliza,
            emi_c.FolioRbo,
            emi_c.RamoSubramol,
            emi_c.Ftervigpol,
            emi_c.Contrat,
            emi_c.FMaPago,
            emi_c.FemiRbo,
            emi_c.Finivig,
            emi_c.Ftervig,
            emi_c.Renueva,
            emi_c.Pma1 AS Emitida_c
        FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS emi_c
    ) AS emi_colectivo
        ON emision.NAgente=emi_colectivo.NAgente
        AND emision.Periodo=emi_colectivo.Periodo
        AND emision.PolSocioComercial=emi_colectivo.PolSocioComercial
        AND emision.NPoliza=emi_colectivo.NPoliza
        AND emision.RamoSubramol=emi_colectivo.RamoSubramol
        AND emision.Ftervigpol=emi_colectivo.Ftervigpol
    )
    WHERE isnull(emision.Periodo,emi_colectivo.Periodo) BETWEEN 202401 AND 202412
 ) as base 
 LEFT JOIN TB_BI_DimAgente age on age.NipPerfilAgente = base.NAgente
 LEFT JOIN TB_BI_DimOficina ofi on ofi.IdOficina = age.IdOficina
 WHERE ofi.IdSubdireccionComercial in (33107,33106) and not NombreOficinaComercial = 'Pachuca'

 --------------------- Cancelaciones ------------------------------

 SELECT 
    base.RamoSubramol Subramo,
    ofi.IdOficina Oficina,
    ofi.DescSubdireccionComercial Subdireccion,
    ofi.NombreOficinaComercial 'Oficina Comercial',
    ofi.NombreOficina 'Oficina Operativa',
    base.NPoliza Poliza,
    base.FolioRbo Folio,
    base.Contrat Contratante,
    base.FMaPago 'Forma de Pago',
    base.FemiRbo,
    base.Finivig,
    base.Ftervig,
    base.Fecha FCancelacion,
    base.Prima_Total,
    base.NAgente,
    age.NombreAgente,
    base.Renueva,
    base.PolSocioComercial

FROM
  ( SELECT 
        isnull(emision.NAgente,emi_colectivo.Nagente) AS NAgente,
        isnull(emision.Periodo,emi_colectivo.Periodo) AS Periodo,
        isnull(emision.PolSocioComercial,emi_colectivo.PolSocioComercial) AS PolSocioComercial,
        isnull(emision.NPoliza,emi_colectivo.NPoliza) AS NPoliza,
        isnull(emision.FolioRbo,emi_colectivo.FolioRbo) AS FolioRbo,
        isnull(emision.RamoSubramol,emi_colectivo.RamoSubramol) AS RamoSubramol,
        isnull(emision.Ftervigpol,emi_colectivo.Ftervigpol) AS FechaFinVigencia,
        isnull(emision.Contrat,emi_colectivo.Contrat) AS Contrat,
        isnull(emision.FMaPago,emi_colectivo.FMaPago) AS FMaPago,
        isnull(emision.FemiRbo,emi_colectivo.FemiRbo) AS FemiRbo,
        isnull(emision.Finivig,emi_colectivo.Finivig) AS Finivig,
        isnull(emision.Ftervig,emi_colectivo.Ftervig) AS Ftervig,
        isnull(emision.Fecha, emi_colectivo.Fecha) AS Fecha,
        isnull(emision.Renueva,emi_colectivo.Renueva) AS Renueva,
        isnull(emision.Cancelada,0)+isnull(emi_colectivo.Cancelada_c,0) AS Prima_Total
    FROM(
        (SELECT gmm_can.NAgente,
            LEFT(gmm_can.femirbo,6) AS Periodo,
            gmm_can.PolSocioComercial,
            gmm_can.NPoliza,
            gmm_can.FolioRbo,
            LEFT(gmm_can.RamoSubramol,charindex(',',gmm_can.RamoSubramol)-1) AS RamoSubramol,
            gmm_can.Ftervigpol,
            gmm_can.Contrat,
            gmm_can.FMaPago,
            gmm_can.FemiRbo,
            gmm_can.Finivig,
            gmm_can.Ftervig,
            gmm_can.Fecha,
            gmm_can.Renueva,
            gmm_can.Pma1 AS Cancelada
        FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS gmm_can     
        ) AS emision
        FULL JOIN
        (SELECT can_c.NAgente,
            LEFT(can_c.FemiRbo,6) AS Periodo,
            can_c.PolSocioComercial,
            can_c.NPoliza,
            can_c.FolioRbo,
            LEFT(can_c.RamoSubramol,charindex(',',can_c.RamoSubramol)-1) AS RamoSubramol,
            can_c.Ftervigpol,
            can_c.Contrat,
            can_c.FMaPago,
            can_c.FemiRbo,
            can_c.Finivig,
            can_c.Ftervig,
            can_c.Fecha,
            can_c.Renueva,
            can_c.Pma1 AS Cancelada_c
        FROM dbo.TB_DWH_GmmcEmitidoCancelaciones_CargaDiaria AS can_c
    ) AS emi_colectivo
        ON emision.NAgente=emi_colectivo.NAgente
        AND emision.Periodo=emi_colectivo.Periodo
        AND emision.PolSocioComercial=emi_colectivo.PolSocioComercial
        AND emision.NPoliza=emi_colectivo.NPoliza
        AND emision.RamoSubramol=emi_colectivo.RamoSubramol
        AND emision.Ftervigpol=emi_colectivo.Ftervigpol
    )
    WHERE isnull(emision.Periodo,emi_colectivo.Periodo) BETWEEN 202401 AND 202412
 ) as base 
 LEFT JOIN TB_BI_DimAgente age on age.NipPerfilAgente = base.NAgente
 LEFT JOIN TB_BI_DimOficina ofi on ofi.IdOficina = age.IdOficina
 WHERE ofi.IdSubdireccionComercial in (33107,33106) and not NombreOficinaComercial = 'Pachuca'