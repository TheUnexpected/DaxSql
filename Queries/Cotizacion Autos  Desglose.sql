SELECT TOP 5 *
FROM DWH.Tb_BI_GrlSinReporte AS rep
WHERE rep.IdLineaNegocio=4

SELECT TOP 5 *
FROM dwh.Tb_BI_GrlSinReclamo
 
SELECT *
FROM DMSin.Tb_BI_AutSinSiniestros sinaut where NumCompletoCotizacion = 42640000039057
where TipoPerdida = 1 and year(TiempoOcurrencia) = 2025 and MONTH(TiempoOcurrencia) = 6
 
SELECT top 1000*
FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
WHERE IdLineaNegocio=4

SELECT TOP 100* FROM TB_BI_AutrFactEmisionDoc where Placas is not null and Placas <> '' and Placas <> ' ' 

SELECT * FROM TB_BI_AutrFactEmisionDoc where NumCompletoCotizacion = 42640000039057 and NumPoliza = 37245

SELECT * FROM TB_BI_DimEstatusSiniestro
SELECT * FROM TB_BI_DimCobertura
SELECT * FROM TB_BI_DimAsegurado
SELECT * FROM DMsin.TB_BI_CatVehiculo
SELECT * FROM TB_BI_DimTipoVehiculo
SELECT * FROM TB_BI_DimEstatusSiniestro
SELECT * FROM TB_BI_DimEstados
SELECT * FROM dwh.Tb_BI_GrlSinReclamo where NumCompletoCotizacion = 42640000039057 and NumPoliza = 37245
SELECT * FROM  DMSin.Tb_BI_AutSinDetallePagos WHERE NumReclamo IN  (20070000002874) --Saber si se pago el siniestro
 

SELECT
--    sinaut.NumCompletoCotizacion,
    sinaut.NumReclamo,
    sinaut.NumPoliza,
    NombreAsegurado,
    aut.ModeloVehiculo 'Mod(Año)',
--    aut.Placas 'PlacasAsegurado',
    sinaut.PlacasVehiculoNA 'PlacasSiniestro',
    sinaut.SerieVehiculoNA,
    TipoPerdida 'Perdida Total',
    sinaut.IdEstadoOcurrencia 'Entidad',
    '-' 'Cobertura',
    CONCAT(sinaut.NombresConductorVehiculoNA, ' ', sinaut.ApellidoPaternoConductorVehiculoNA, ' ',sinaut.ApellidoMaternoConductorVehiculoNA) 'Nombre Conductor',
    th.DescTipoVehiculo,
    CONCAT(vih.DescMarcaVehiculo, ' ',vih.DescSubMarcaVehiculo) 'DEscripcion Vehículo',
    sinaut.TiempoOcurrencia 'Fecha Siniestro'
    ,SinReclamo.IdEstatusSiniestro
    ,min(SinPago.DescPago) 'Descr'
    ,Sum(SinPago.ImporteNetoPago) 'Importe Pagado'

FROM DMSin.Tb_BI_AutSinSiniestros sinaut 
--LEFT JOIN DMSin.tb_bi_autsinDatoseconomicoscob AS cob on sinaut.NumCompletoCotizacion = cob.NumCompletoCotizacion
INNER JOIN tb_bi_dimagente age on age.nipperfilagente = sinaut.nipperfilagente

InneR JOIN TB_BI_AutrFactEmisionDoc aut on aut.NumCompletoCotizacion = sinaut.NumCompletoCotizacion and aut.NumDocumento = 0

INNER JOIN TB_BI_DimAsegurado ase on ase.CveAsegurado = aut.CveAsegurado
LEFT JOIN DMsin.TB_BI_CatVehiculo vih on vih.idinternovehiculo = aut.IdVehiculo
LEFT JOIN TB_BI_DimTipoVehiculo th on th.IdTipoVehiculo = aut.IdTipoVehiculo

INNER JOIN dwh.Tb_BI_GrlSinReclamo SinReclamo on
    sinaut.IdCompuestoSiniestro = SinReclamo.NumCompuestoSiniestro and sinaut.NumCompletoCotizacion = SinReclamo.NumCompletoCotizacion

LEFT JOIN DMSin.Tb_BI_AutSinDetallePagos SinPago ON SinPago.NumReclamo = sinaut.NumReclamo and year(TiempoCreacionPago) > 2024

where TipoPerdida = 1 and sinaut.TiempoOcurrencia BETWEEN '2024-06-01' and '2025-05-31'
    and aut.FechaFinVigencia >= '2025/06/05'
and age.IdOficina in (264,352, 783) 

GROUP BY    
    sinaut.NumReclamo,
    sinaut.NumPoliza,
    NombreAsegurado,
    aut.ModeloVehiculo,
--    aut.Placas 'PlacasAsegurado',
    sinaut.PlacasVehiculoNA,
    sinaut.SerieVehiculoNA,
    TipoPerdida,
    sinaut.IdEstadoOcurrencia,
    CONCAT(sinaut.NombresConductorVehiculoNA, ' ', sinaut.ApellidoPaternoConductorVehiculoNA, ' ',sinaut.ApellidoMaternoConductorVehiculoNA),
    th.DescTipoVehiculo,
    CONCAT(vih.DescMarcaVehiculo, ' ',vih.DescSubMarcaVehiculo),
    sinaut.TiempoOcurrencia
    ,SinReclamo.IdEstatusSiniestro
    --,SinPago.DescPago