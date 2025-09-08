SELECT TOP 5 *
FROM DWH.Tb_bi_GrlEmiCotizado AS cotiz

WHERE cotiz.AjusteEspecial>1000
WHERE cotiz.NumCompletoCotizacion=40030001658641


SELECT *
FROM dwh.TB_Dwh_DanCotizacionesCob AS cotd
WHERE  cotd.NumCompletoCotizacionMaestra IN (10330001656673)



WHERE FechaCotizacion BETWEEN 20240101 AND 20241231
AND Eliminado=0
AND NumDocumento=0
AND NumPolizaAnterior=0
AND numcertificado=0
AND numpoliza=0


SELECT  *
FROM DWH.Tb_bi_GrlEmiAgenteCotizacion
--WHERE NumCompletoCotizacion IN (40060001045340,42130000033016,42910000021905)
WHERE NumCompletoCotizacion =40030001658641


SELECT OficinaMexico 
FROM dbo.TB_BI_DimZonaContable

SELECT *
FROM DWH.Tb_bi_AutrEmiCotiz AS emicot
WHERE NumCompletoCotizacion IN (40030001658641)

SELECT *
FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS vc
WHERE IdOficina=153
AND NumPoliza=18962

	
SELECT TOP 5 *
FROM dbo.TB_DWH_AutrConversionPolizasIndividual  
WHERE CodigoPostalPoliza IS ma


SELECT *
FROM dbo.TB_DWH_AutrConversionPolizasIndividual   
WHERE numcompletocotizacion = 44840000004582

WHERE FechaCotizacion BETWEEN 20250401 AND 20250430	


SELECT TOP 3 *
FROM DWH.Tb_bi_AutrEmiCotizacionZonaCirc AS cotcp

SELECT TOP 10 *
FROM VW_BI_AutrFactEmision


SELECT  *
FROM HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
WHERE tec.NumCompletoCotizacion in (40220001539318,41230002746953)



SELECT *
FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
WHERE emi.IdOficina=176
AND emi.NumPoliza IN (51279)




SELECT TOP 300 * 
FROM TB_BI_AutrFactEmisionCob AS cob
WHERE cob.IdModulo !=0

Select Top 100 *
From TB_BI_AutrEmisionCobDevMes t1


SELECT TOP 3 *
FROM TB_BI_AutrFactCobrado


select 
	FR.Periodo
	, [Ocurrido_BIHDI] = FORMAT(SUM(FR.Ocurrido), 'C') --Ocurrido de BIHDI
	, [OcurridoCoaseguro] = FORMAT(SUM(FR.OcurridoCoaseguro), 'C') --BIHDI
	, [OcurridoNeto] = FORMAT(SUM(FR.OcurridoNeto), 'C') --En tabular es Ocurrido sin Coaseguro, en BIHDI es Ocurrido Neto
	, [CostoSiniestroNeto] = FORMAT(SUM(FR.CostoSiniestroOcurridoNeto), 'C') --En tabular es Costo Siniestro Ocurrido
from 
	dbo.VW_BI_AutrFactReservacom  FR
where 
	FR.Periodo = 202401
group by
	FR.Periodo



SELECT TOP 3 *
FROM TB_BI_AutrVariablesPorCobertura
WHERE Periodo BETWEEN 202401 AND 202409

SELECT TOP 3 *
FROM TB_DWH_DanBaseTecnica AS tec
WHERE tec.Periodo between 202501 AND 202501
GROUP BY tec.Periodo

SELECT TOP 3 *
from HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
WHERE emi.IdOficina=176
AND emi.NumPoliza IN (51279)

AND emi.FechaTransaccion BETWEEN 20250501 AND 20250531

SELECT *
FROM TB_BI_DanFactEmisionCob AS emicob
WHERE emicob.NumDocumento=0


SELECT *
FROM dbo.TB_BI_DanFactCobrado AS cobr
WHERE cobr.NumCompletoCotizacion=10780000057584

SELECT TOP 3 *
FROM dbo.VW_BI_DanFactCobrado

SELECT *
FROM TB_BI_DimAgente AS age 
WHERE age.NipPerfilAgente IN (112472)




SELECT age.idtipoagente, *
FROM VW_BI_DimAgente
WHERE NipPerfilAgente=114147

SELECT DISTINCT categoriacedula
FROM dbo.TB_Bi_DimAgenteDatos

SELECT * 
FROM TB_BI_DimCanalDeDistribucion
WHERE age

SELECT  *
FROM TB_BI_DimEjecutivo AS eje
WHERE eje.IdEjecutivo IN (430006350,430009517)

SELECT *
fROM tb_bi_dimoficina AS ofi
WHERE ofi.IdOficina IN (586)
WHERE ofi.IdDireccionComercial IN (26862,31690,26861)

SELECT *
FROM TB_DWH_GrlSinValuacion AS val
WHERE val.NumSiniestro IN (20250000066773,20250000068318,20250000068749,20250000068805,20250000069129,20250000069233,20250000070549, 
 20250000070693,20250000073100,20250000073605,20250000074248,20250000075012,20250000075447,20250000076728,20250000076932,20250000077063, 
 20250000077968,20250000078357,20250000068598,20250000068791,20250000068909,20250000069173,20250000069183,20250000069265,20250000069278, 
 20250000070252,20250000072000,20250000072648,20250000073161,20250000074383,20250000074718,20250000077407, 20250000078428)
AND val.IdLineaNegocio=4

SELECT * 
FROM dbo.VW_BI_DimTipoCambio


SELECT *
FROM TB_BI_DimZonaContable

SELECT *
FROM TB_BI_AutrModulo

SELECT *
FROM TB_BI_AutrTabModulos
WHERE Periodo=202301

SELECT *
FROM dbo.TB_BI_DimEstadoOficina

SELECT *
FROM TB_BI_DimTipoAgente

SELECT *
FROM Cv360.VW_BI_DimOficinaComercial
WHERE IdOficina=465


SELECT *
FROM Cv360.Tbl_CatOficinas
WHERE IdOficina=586

SELECT DISTINCT CodigoPostal, Estado, Municipio
FROM TB_BI_DimCodigoPostal

SELECT * 
FROM TB_BI_DimCausaRechazo

SELECT TOP 3 * --DISTINCT  cat.DescMarcaVehiculo, cat.DescSubMarcaVehiculo, concat(cat.DescMarcaVehiculo,'-',cat.DescSubMarcaVehiculo)
FROM DMSin.Tb_BI_CatVehiculo AS cat


SELECT *
FROM TB_BI_DimUsoVehiculo

SELECT TOP 3 *
FROM   VW_BI_DimVehiculo AS vehi
WHERE vehi.DescMarcaVehiculo LIKE '%regu%'
AND vehi.IdEstatusVehiculo=171

SELECT * 
FROM TB_BI_DimTipoVehiculo


SELECT * 
FROM TB_BI_DimCatTonelaje

SELECT *
FROM TB_BI_DimTarifa
WHERE NombreVersion LIKE '%Tradicional%'

SELECT *
FROM TB_BI_DimCatArmadora

SELECT *
FROM TB_BI_DimZonaCirculacion

SELECT *
FROM tb_bi_dimriesgocarga

SELECT *
FROM HDI_DWH.dbo.TB_BI_DimCanalVenta



select * 
from dbo.TB_Bi_DimAgenteDatos

SELECT *
FROM TB_BI_DimTipoPoliza



SELECT *
FROM TB_BI_DimDanTipoPoliza


SELECT *
FROM TB_BI_DimModalidad


SELECT *
FROM TB_BI_DimPaquete AS paq
--WHERE descgrupopaquete LIKE '%Ampli%'
WHERE paq.DescPaquete LIKE '%Idri%'

SELECT * 
FROM DMSin.Tb_BI_CatMoneda


 
SELECT *
FROM HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS page
--WHERE page.CanalVenta IS NOT NULL
WHERE page.NipPerfilAgente IN (114149)

SELECT *
FROM DMSin.Tb_BI_CatDanPaquete


SELECT *
FROM DMSin.Tb_BI_CatAutPaquete


SELECT * 
FROM TB_BI_DimCausaCancelacion


SELECT * 
FROM TB_BI_DimAgrupadorNegocio




SELECT *
FROM TB_BI_DimTipoDocumento
WHERE idtipodocumento IN (144,162)


Select * 
From VW_Bi_DimCLasificacionProductos 
WHERE IdLineaNegocio=1

SELECT *
FROM TB_BI_DimClasificacionProductos

SELECT *
FROM TB_BI_DimLocacionGeografica


SELECT *
FROM DMSin.Tb_BI_CatMunicipios AS catm
WHERE idestado=11

SELECT *
FROM VW_BI_DimEstados


SELECT aseg.NombreAsegurado, aseg.IdOcupacionOGiro,aseg.DescOcupacionOGiro, aseg.CveAsegurado

SELECT *
FROM TB_BI_DimAsegurado AS aseg
WHERE aseg.NombreAsegurado LIKE '%gobierno%queretaro%'

WHERE aseg.EntidadGubernamental=1


WHERE aseg.IdEstado=9 OR aseg.NombreMunicipio IN ('GUADALAJARA', 'MONTERREY', 'LEON','PUEBLA','TIJUANA','QUERETARO','MERIDA','CHIHUAHUA')

SELECT RIGHT(concat('000',ramo.IdSubRamo),3),*
FROM TB_BI_DimGrlRamos AS ramo
WHERE lineaNegocio='DAN'


WHERE aseg.FechaUltAct >='2023-03-25'
AND aseg.FechaIngreso<'2023-03-25'



SELECT TOP 3 *
FROM Cv360.Tbl_CatAsegurados
WHERE nombreasegurado LIKE '%TRES%B'

SELECT *
FROM TB_BI_DimCobertura AS cob
WHERE idlineaNegocio=1
AND DescCobertura LIKE '%fune%'

SELECT *
FROM TB_Bi_DimTipoConservacion

SELECT DISTINCT iddespacho,nombredespacho,tipodespacho

SELECT *
FROM TB_BI_DimAgenteDespacho desp
WHERE desp.IdDespacho LIKE 162


SELECT  *
FROM TB_BI_DimDespacho AS desp
WHERE desp.NombreDespacho LIKE '%Espinola%'

and desp.NombreDespacho LIKE '%FANTAS%'
--216 es el estatus activo


SELECT TOP 50 *
FROM TB_BI_DimDespachoIntegranteHistorico



SELECT TOP 50 *
--SELECT DISTINCT periodo
FROM tmp.Tb_Bi_Observatorio272Conservacion
--WHERE IdOficina=3
WHERE Periodo>= 202401



SELECT * 
FROM TB_BI_AutrRptRenovaciones AS rev
WHERE Asegurado LIKE '%JOSEFINA BAEZA%'




SELECT TOP 5 * 
FROM Vw_bi_GrlRecibosEstatus_Procesos


SELECT * 
FROM DMSin.Tb_BI_CatFrecuenciaPago

SELECT * 
FROM TB_BI_DimFormaPago

SELECT TOP 3 *
FROM DWH.Tb_BI_GrlFacRecibosMae
WHERE IdlineaNegocio=1


SELECT TOP 5 *
FROM DWH.Tb_BI_GrlFacRecibosHistorico
WHERE IdRecibo=52103236

SELECT * 
FROM tb_bi_dimreciboestatus



SELECT  *
FROM DWH.Tb_Bi_AutrIDrivingUsuarioCliente
WHERE CustomerKey IN ('00469-0000006760-1-1','00004-0000228937-1-1')

SELECT * 
FROM DWH.Tb_Bi_AutrIDrivingClienteDireccion

SELECT * 
FROM DWH.Tb_Bi_AutrIDrivingUsuarioReto

SELECT * 
FROM Tb_bi_DimRetoiDriving

SELECT TOP 3 *
FROM dwh.Tb_Bi_AutrIDrivingPuntajeDiario

SELECT *
FROM dwh.Tb_Bi_AutrIDrivingUsuarioEnvioCampaña

SELECT *
FROM Tb_bi_DimCampañaiDriving

SELECT * 
FROM Tb_bi_AutrIDrivingReporeCanjes 



SELECT * 
FROM TB_BI_DimCanalDeDistribucion


SELECT *
FROM Cv360.Tbl_AgentesDatosAdicionales
WHERE correo='rodrigoperez@bidaseguros.org'


SELECT * 
FROM DMSin.Tb_BI_CatLineaNegocio

SELECT *
FROM dbo.TB_BI_DimGpoBono  

SELECT * 
FROM TB_BI_DimCausaSiniestro

SELECT *
FROM DMSin.Tb_BI_CatSinTipoSiniestro

Select * 
From TB_BI_DimSubEvento  

SELECT monto, *
FROM TB_BI_AutrFactReserva
WHERE NumReclamo=20230000184362


SELECT monto,*
FROM TB_BI_AutrFactReservaPag
where NumReclamo=20230000184362

SELECT *
FROM VW_BI_DimTipoMovimientoRva


SELECT  cob.NumReclamo,
	   	sum(cob.Ocurrido) AS Ocurrido,
		sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
		sum(cob.AjustesSalvamentos)+sum(cob.EstimadoSalvamentos) AS Salvamentos,
		sum(cob.GastosIndirectos) AS Gastos_indirectos,  
		sum(cob.GastosAjuste) AS Gastos_ajustados,
		sum(cob.Reserva) AS Reserva,
		sum(cob.Pagos) AS Pagos,
		sum(cob.Deducible) AS Deducible
		
FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
WHERE IdLineaNegocio=4
AND cob.NumReclamo IN ( 20220000006763)

GROUP BY cob.NumReclamo


SELECT TOP 5 *
FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
WHERE IdLineaNegocio=4
AND cob.NipPerfilAgente= 98351
AND cob.FechaMovimiento BETWEEN 20240101 AND 20241231




SELECT TOP 5 *
FROM DWH.Tb_BI_GrlSinReporte AS rep
WHERE rep.IdLineaNegocio=4
AND rep.Observaciones IS NOT null
AND rep.NumReclamo= 20230000184362


SELECT TOP 5 *
FROM dwh.Tb_BI_GrlSinReclamo
WHERE numreclamo IN (20230000184362 )

SELECT TOP 200 *
FROM DMSin.Tb_BI_AutSinSiniestros sinaut
WHERE sinaut.Rec_Num=20230000184362

SELECT TOP 2000 *
FROM TB_BI_AutrTipoPerdida


SELECT TOP 5 *
FROM DWH.Tb_BI_GrlSinDeclaraciones
WHERE declaracionajustador LIKE '%sexo%'


where cob.NumReclamo= 20230000196968
AND cob.FechaMovimiento BETWEEN 20220801 AND 20230731
--AND  FechaMovimiento BETWEEN 20230401 AND 20230430


SELECT *
FROM tb_bi_autrajusteSipacCopac
WHERE idoficina=139
AND NumPoliza IN (34761)
AND NumCertificado=22


SELECT *
FROM DMSin.Tb_BI_DanSinDatosEconomicosCob AS dan_cob
WHERE dan_cob.Ocurrido<-100000
AND dan_cob.FechaMovimiento>=20240101

SELECT sum(d_r.OcurridoConsolidado)
FROM vw_Bi_danfactreserva AS d_r
WHERE periodo BETWEEN 202201 AND 202212

SELECT TOP 3 *
FROM TB_BI_DanFactReserva


SELECT TOP 3 *
FROM DMSin.tb_bi_autsincoberturaafectada 
WHERE IdCoberturaAlborada=2

SELECT TOP 3 *
FROM Dshd.Vw_Bi_DanSinSiniestros

SELECT TOP 3 *
FROM tb_BI_siniestrosEventoAUTR

SELECT * 
FROM DMSin.Tb_BI_CatEstatusSiniestro

SELECT *
FROM  DMSin.Tb_BI_AutSinGastos
WHERE NumReclamo IN  (20220000109506) 


SELECT *
FROM  DMSin.Tb_BI_AutSinDetallePagos
WHERE NumReclamo IN  (20240000079488,20240000093712) 


SELECT *
FROM  DMSin.Tb_BI_AutSinPagos
WHERE NumReclamo IN  (20220000109506) 

SELECT TOP 5 *
FROM TB_DWH_AutrCapacidadInstaladaCDR



SELECT TOP 5 * 
FROM Dshd.Tb_bi_SinModeloOcurrido

SELECT TOP 5 *
FROM DMSin.Tb_BI_AutSinEmisionDoc


SELECT  *
From VW_BI_AutrFactReserva e 
WHERE NumReclamo IS NULL


SELECT *
From TB_BI_AutrFactCisVigentes t1
WHERE Numcompletocotizacion = 40030001416139


SELECT * 
FROM  TB_BI_ACAGrlAdmonCurso
WHERE Nombre LIKE '%bienve%'


SELECT *
FROM TB_BI_GrlCursoAgenteAdmon AS curso
where curso.Instructor='DAVID PINEDA'
AND curso.NipAgente=90488
AND curso.CursoId=15




SELECT * 
FROM Cv360.Tbl_IndicadoresXEjecutivo AS xeje
WHERE  xeje.IdEjecutivo IN (430007368002)
and  TipoPeriodo IN (1,2,3)
AND Periodo=202503
AND idTipoIndicador IN (1,2,35)
ORDER BY xeje.IdEjecutivo



SELECT *
FROM Cv360.Tbl_IndicadoresXgerente
WHERE  IdTipoIndicador IN (1,2,35)
AND IdGerente=430008014003
AND TipoPeriodo IN (2)
AND Periodo=202411


SELECT *
FROM Cv360.Tbl_IndicadoresXdirector
WHERE  IdTipoIndicador IN (1)
AND IdDirector=430002985005
AND TipoPeriodo IN (1,2,3)
AND Periodo=202409



SELECT *
FROM Cv360.Tbl_IndicadoresXAgente AS iage
WHERE  iage.IdAgente IN (105729,59913)
AND TipoPeriodo IN (3)
AND idTipoIndicador IN (1)



SELECT *
FROM Cv360.Tbl_IndicadoresXOficina
WHERE IdTipoIndicador IN (1)
AND IdOficina IN (737)
AND TipoPeriodo IN (1,2,3)

SELECT  *
from Cv360.Tbl_CatTipoIndicador AS catti


SELECT *
FROM Cv360.Tbl_CatPathJerarquia AS jer
--WHERE idoficina IN (7)
WHERE jer.IdUsuarioN3=430005663003


SELECT *
FROM Cv360.Tbl_CatPathJerarquia2 AS jer
WHERE jer.IdUsuarioN2=430008067002

SELECT * 
FROM Cv360.Tbl_CatJerarquia AS jer
WHERE jer.IdNivel>=2
AND jer.SSOPerfil=430009080

SELECT * 
FROM Cv360.Tbl_CatNivelesJerarquia


--------OTS

SELECT * 
FROM Cv360.Tbl_CatTipoDocumentoOT

SELECT *
FROM [dbo].[Tb_BI_DimTipoDocumentoOT]

SELECT * 
FROM dbo.Tb_BI_DimEstatusOT

SELECT *
from TB_BI_DimCausaRechazoOT

SELECT *
FROM Tb_BI_DimTipoSolicitudOT

SELECT *
FROM TB_BI_AutrCisMaestroCotizacion
WHERE NumCompletoCotizacion=40050001608571

SELECT *
FROM TB_BI_AutrCisMaestroNegocio AS cis
WHERE cis.IdCisMaestro=852204


SELECT *
FROM DWH.TB_BI_GrlFactOTSolicitud ot
WHERE ot.IdLineaNegocio=6
AND ot.TiempoAltaOt>='2024-01-01'


SELECT mas.Siniestralidad,

		count(*)
FROM DWH.Tb_bi_GrlOTComplementoMasivo mas
WHERE mas.IdLineaNegocio=6
--AND mas.Siniestralidad >0
AND mas.IdEstatusSuscripcion=23286
AND mas.FechaAlta>='2024-01-01'

GROUP BY mas.Siniestralidad

SELECT *
FROM TB_dwh_CatEstatusSuscripcionOt


SELECT *
FROM TB_dwh_CatEstatusNegocio

SELECT *
FROM TB_DWH_CatProgramaOt

SELECT *
FROM TB_dwh_CatCausaRechazoOt

SELECT *
FROM TB_dwh_CatEstatusCotizOt

SELECT *
FROM Cv360.Tbl_CatEstatusOT

SELECT *
FROM TB_dwh_CatCIAOt

SELECT *
FROM TB_dwh_CatComentarioSucripcion

SELECT *
FROM TB_BI_DimOrigenOT

SELECT *
FROM TB_DWH_CatCausaRechazoEmisionOT


--------

SELECT * 
FROM Dshd.Vw_bi_DimUsuariosSSO
WHERE Departamento LIKE '%Planeacion%'


SELECT *
FROM TB_BI_SOPromotorias_agentes
WHERE NipAgente=95782
AND Periodo=202211
--AND IdTipoIndicador='AUTOS'
AND TipoPeriodo=2


SELECT TOP 3 *
FROM TB_BI_SOPromotorias_oficinas



SELECT TOP 3 *
FROM ventas.VW_BI_AutrPrimas_IDRIVING AS vpid


SELECT *
FROM Ventas.VW_BI_AutrCotizaciones_Conversion_IDRIVING AS vcid

SELECT * 
FROM Ventas.VW_DWH_AutrConservacion_IDRIVING  AS vconid


SELECT TOP 3 *
FROM RR8.SumaAseguradaExpuesta
WHERE NumPoliza=0


SELECT turi.Periodo,
		--sum(turi.PrimaTotal) AS total,
		round(sum(turi.PrimaNeta),0) AS neta --cuadra con cubos
FROM VW_BI_AuttFactEmision turi
WHERE turi.Periodo BETWEEN 202504 AND 202504
GROUP BY turi.Periodo

SELECT sum(RiesgoVigente) AS Riesgos --cuadra con cubos
FROM VW_BI_AuttFactCisVigentes
WHERE Periodo BETWEEN 202301 AND 202312

SELECT sum(turi_dev.PrimaNetaEmitidaDevengada) AS Dev, --cuadra con cubos
		sum(turi_dev.UnidadesExpuestasMes) AS Expuestas_Mes,--cuadra con cubos
		sum(turi_dev.UnidadesExpuestas) AS expuestas
FROM VW_BI_AuttFactEmisionDevMes turi_dev
WHERE Periodo BETWEEN 202301 AND 202312

SELECT sum(turi_sin.Monto) AS monto, 
		sum(turi_sin.Ocurrido) AS Ocurrido, -- cuadra con cubos
		sum(turi_sin.CostoSiniestroOcurrido) AS Costo_Ocurrido, 
		sum(turi_sin.Siniestro) AS Siniestros -- cuadra con cubos
		
		
SELECT turi_sin.Periodo, turi_sin.NipPerfilAgente,turi_sin.Ocurrido
FROM VW_BI_AuttFactReserva turi_sin
WHERE Periodo =202405

SELECT TOP 3 *
FROM  VW_Bi_AuttVigentes



SELECT 
sum(primaNetaCobertura)
FROM VW_DWH_SII_AuttEmiCob
WHERE Periodo=202212

SELECT TOP 3 *
FROM VW_DWH_SII_AuttEmiEndosos

SELECT TOP 3 *
FROM VW_DWH_SII_AuttEmiIncisos


SELECT TOP 3 *
FROM VW_DWH_SII_AuttEmiPoliza
WHERE Periodo =202201




SELECT * 
FROM Cv360.VW_BI_DimOficinaComercial

SELECT sum(aca.PrimaNetaPagada), sum(aca.PrimaNetaProduccion, aca.PrimaNetaEmitida
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca
WHERE aca.IdOficina=449
AND aca.Periodo=202502
AND aca.IdGpoBono=201


AND aca.NipAgente=1020
GROUP BY aca.NipAgente, aca.NipPerfilAgente, aca.IdDespacho, aca.IdGpoBono
order BY aca.NipAgente, aca.IdDespacho


SELECT TOP 3 *
FROM dbo.VW_BI_GrlInfoModuloxAgente AS aca
WHERE aca.CveAsegurado NOT IN (' ')


SELECT TOP 10 *
FROM TB_ACA_BONOXPERFIL


SELECT TOP 5 *
FROM Tb_Bi_ClientesVigentesNipAgrupador
WHERE NipAgrupador=4841190

SELECT TOP 1000 *
FROM TB_DWH_GMMEmisionDoc
WHERE fechatransaccion BETWEEN '2025-01-01' AND '2025-03-31'

SELECT sum(primatotal)
FROM TB_DWH_GMMEmisionCob
WHERE fechatransaccion BETWEEN '2025-01-01' AND '2025-03-31'

SELECT max(convert(DATETIME,fecha,101))

SELECT  *
FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria
WHERE Fecha BETWEEN 20250601 AND 20250630


SELECT max(convert(DATETIME,femirbo,101))

SELECT *
FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS emi_gmm
WHERE emi_gmm.FemiRbo BETWEEN 20250601 AND 20250630

SELECT max(convert(DATETIME,pag.FechaPago,101)
SELECT *
FROM TB_DWH_GMMRecibosCobrados_CargaDiaria AS pag
WHERE pag.FechaPago BETWEEN '2025-06-01' AND '2025-06-30'


SELECT *
FROM dbo.TB_DWH_GMMCotizaciones AS cot
WHERE CAST(cot.FechaCotiz AS DATE) >= '2024-01-01' 
AND CAST(cot.FechaCotiz AS DATE)<='2024-12-31'
--AND cot.CotizacionDemo=1

WHERE FechaCotiz BETWEEN'2024-07-01' AND '2024-07-31'

WHERE Cliente != ' '
OR len(trim(Cliente))>6

SELECT *
FROM dbo.TB_DWH_GMMSolicitudes
--WHERE EstatusSol='Rechazada'
WHERE NumSolic=96184

SELECT *
FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS emi_gmm
where femirbo BETWEEN 20250601 AND 20250630

SELECT *
FROM dbo.TB_DWH_GmmcEmitidoCancelaciones_CargaDiaria
WHERE Fecha BETWEEN 20250601 AND 20250630

SELECT *
FROM dbo.TB_DWH_GmmcRecibosCobrados_CargaDiaria
WHERE FechaPago BETWEEN '2025-06-01' AND '2025-06-30'



SELECT *
FROM dbo.TB_DWH_GMMDeudor_Pago

SELECT  PrimaNetaMetaEmision,Periodo,Idoficina
FROM dbo.TB_DWH_GMMPresupuestoMetaOficina AS ppto_gmm	
WHERE ppto_gmm.Periodo>=202501  --aquí cámbienle el periodo a la necesidad


SELECT Periodo, sum(Prima_Total)  

SELECT  *
FROM Dshd.VW_DWH_GMMPrimaNeta
WHERE Periodo BETWEEN 202506 AND 202506
AND RamoSubramol='MED VITAL PYMES  '
order BY Periodo 

SELECT * 
FROM Dshd.VW_DWH_GMMPptoxOficina
WHERE Periodo=202501

SELECT *
FROM VW_DWH_GMMCifrasDiariasPagadas
where fechapago between '2025-01-01' and '2025-06-30'

SELECT *
FROM TB_DWH_GmmMetaPrimaEmitidaxEjecutivo

SELECT SSO, Meta, Periodo
FROM Dshd.VW_DWH_GmmMetaPrimaEmitidaxEjecutivo
WHERE Periodo>=202401


SELECT *
FROM TB_DWH_GMMSiniestros_Reserva

SELECT *
FROM TB_DWH_GMMSiniestros_Pagos

SELECT DISTINCT *
FROM TB_DWH_GMMSiniestros_Gral
WHERE EventoReportado LIKE '%dia%'

SELECT met_aut.Periodo,
		met_aut.IdPerfilEjecutivo,
		met_aut.PrimaNetaMetaEmision
FROM VW_BI_AutrFactMeta AS met_aut
WHERE met_aut.Periodo>=202401
--AND met_aut.PrimaNetaMetaEmision !=0
AND met_aut.IdPerfilEjecutivo IN (430010366,430008483)
ORDER BY met_aut.Periodo



SELECT met_aut.Periodo,
		met_aut.IdPerfilEjecutivo,
		met_aut.PrimaNetaMetaEmision
FROM VW_BI_DAnFactMeta AS met_aut
WHERE met_aut.Periodo>=202401
--AND met_aut.PrimaNetaMetaEmision !=0
AND met_aut.IdPerfilEjecutivo IN (430008188)
ORDER BY met_aut.Periodo

SELECT primanetametaemision,Periodo,IdOficina
FROM VW_BI_AutrFactMetaOficina AS met_aut
WHERE met_aut.Periodo>=202501
--AND met_aut.IdOficina=3


SELECT primanetametaemision,Periodo,IdOficina
FROM VW_BI_DanFactMetaOficina AS met_dan
WHERE met_dan.Periodo>=202501
--AND met_dan.IdOficina IN (3)

GROUP BY idoficina

SELECT *
FROM TB_NE_HistoricoJato AS jato
WHERE jato.Periodo_Colocado>='2020-01-01'
AND jato.Sector='Captiva'


select TOP 3 *
from Dshd.Vw_DWH_AutrEmiCifrasDiarias
WHERE Periodo=202305

SELECT Periodo, sum(PrimaEmitida) AS Emitida
from Dshd.Vw_DWH_DanEmiCifrasDiarias
GROUP BY Periodo
ORDER BY periodo
WHERE Periodo=202309

SELECT * 
FROM VW_BI_DimAgente AS ag
WHERE ag.IdOficinaAgente IN (276,307,355,363,374,403,494,502,650,656,657,751,791,843,868,869,912,945,946,947)


SELECT *
FROM Cv360.VW_BI_DimOficinaComercial
WHERE idOficina IN (276,307,355,363,374,403,494,502,650,656,657,751,791,843,868,869,912,945,946,947)



SELECT * 
FROM VW_BI_GrlCIRSalvamentos_Ventas



SELECT TOP 3 * 
FROM TB_BI_GrlUDIProvision


SELECT  TOP 3 * 
FROM aca.dbo.TB_ACA_EMISIONINTEG

SELECT TOP 3 *
FROM TB_ACA_AGENTESEQV

SELECT sum(ap.PrimaNetaVigencia) 
FROM TB_BI_VgcaFactEmisionDoc AS ap
WHERE ap.Periodo BETWEEN 202401 AND 202412

SELECT TOP 5 *
FROM Tb_BI_VgcaFactEmision


SELECT *
FROM TB_DWH_GRLSOfDigBitacora

SELECT *
FROM Dshd.VW_DWH_GmmMetaPagadoxEjecutivo
WHERE SSO=430008725

SELECT *
FROM Dshd.VW_DWH_AutrMetaPagadoxEjecutivo
WHERE SSO IN (430006378)

SELECT *
FROM Dshd.VW_DWH_DanMetaPagadoxEjecutivo
WHERE SSO IN (430006378)


Select TOP 10 * 
from VigenteAutosFlotilla

SELECT TOP 10 *
FROM Tb_Bi_ClientesVigentesNipAgrupador

SELECT TOP 10 *
FROM TB_BI_DimProductosAutos


SELECT TOP 500 *
FROM Dshd.Vw_DWH_AutrMasivosSuscripcion_Impacto AS cot
where siniestralidad >0



SELECT TOP 5 *
FROM Dshd.VW_DWH_AutrEmisionFlotillas_Impacto




 

select * 
from [Dshd].[VW_DWH_AutrPresupuestoPrimaPagadaxOficina] AS aut_pag
WHERE CAST(periodo AS FLOAT) BETWEEN 202501 AND 202512
AND aut_pag.Idoficina=8
ORDER BY IdOficina




select * from [Dshd].[VW_DWH_DanPresupuestoPrimaPagadaxOficina]
select * from [Dshd].[VW_DWH_GmmPresupuestoPrimaPagadaxOficina]
 
SELECT *
FROM TB_BI_Reportes_SegSSO_ListaAD
WHERE NombresUsuario LIKE '%Ricardo%'

SELECT *
FROM Dshd.VW_DWH_AuttPresupuestoTuristasxOficina