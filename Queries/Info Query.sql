SELECT 
        ofi.nombreoficina,
        age.NipAgente,
        age.NipPerfilAgente
FROM TB_BI_DimAgente age
LEft JOIN TB_BI_DimOficina ofi
        on age.idoficina = ofi.idoficina
WHERE --ofi.NombreOficinaComercial like '%mexicali%' and DescEstatusPerfil = 'VIGOR' (descEstatusAgente = 'CANCELADO' or  descEstatusAgente = 'FALLECIDO')
 age.idOficina in (004)
       --IdPerfilEjecutivo = 430009508

SELECT distinct descEstatusAgente from TB_BI_DimAgente

SELECT  * FROM TB_BI_DimEjecutivo where NombreEjecutivo like '%peralta%'
SELECT * FROM TB_BI_DimAgente where nipperfilagente in (114932)
SELECT * FROM TB_BI_DimOficina where NombreOficinaComercial like '%santander%' or NombreOficinaComercial like '%autocompara%' or NombreOficinaComercial like '%santander%'
SELECT * FROM TB_BI_DimOficina where IdOficina BETWEEN 1049 and 1060
SELECT * FROM TB_BI_DimOficina where IdOficina in (644)

SELECT * FROM TB_BI_DimOficina where idoficina in ()

--(31690,26861,26862) --Canal Tradicional

SELECT 
        nombreoficina,
        idoficina,
        descdireccioncomercial,
        DescSubdireccionComercial,
        NombreOficinaComercial
         from TB_BI_DIMOFICINA where NombreOficinaComercial like '%chihuahua%'
where IdDireccionComercial in (31690,26861,26862) 

SELECT * FROM TB_BI_DimAgente WHERE IdPerfilEjecutivo in (430009508)  
SELECT distinct IdPerfilEjecutivo from tb_bi_dimagente where idoficina = 139 and descEstatusAgente = 'VIGOR' and DescEstatusPerfil = 'VIGOR'
SELECT * FROM TB_BI_DimEjecutivo where IdEjecutivo = 430000598
SELECT * FROM TB_BI_DimAgente where idoficina = 737 and descEstatusAgente = 'VIGOR' and DescEstatusPerfil = 'VIGOR'

SELECT * FROM TB_BI_DimTipoAgente 
SELECT * FROM Tb_BI_DimLineaNegocio
SELECT * FROM TB_BI_DimTipoPoliza
SELECT * FROM TB_BI_DimClasificacionProductos
SELECT * FROM TB_BI_DimCanalVenta
SELECT * FROM Tb_BI_DimLineaNegocio
select * FROM TB_BI_DimTipoDocumento --cotizaciones
SELECT * FROM TB_BI_DimTipoVehiculo ---4579 Autos residentes, 3829 pickup
SELECT * FROM TB_BI_DimPaquete order by DescGrupoPaquete
SELECT * FROM tb_bi_dimgrlramos where descripcionramo like '%de carga%'

SELECT * FROM DMsin.TB_BI_CatVehiculo --Descripción de vehículos

SELECT * FROM DMsin.TB_BI_CatVehiculo where IdMarcaVehiculo = 3609

SELECT * FROM TB_Bi_DimTipoConservacion
SELECT * FROM TB_BI_DimCausaCancelacion
SELECT * FROM tb_bi_DimTarifa 
-- autdoc Entidad gubernamental -> 1 es de gobierno, descripcion del giro
-- nombre asegurado like entidad gubernamental
SELECT * FROM TB_BI_DimFrecuenciaPago 

SELECT distinct TipoDocumento
FROM Dshd.Vw_DWH_AutrMasivosSuscripcion_Impacto
SELECT * FROM TB_BI_DimAsegurado


SELECT IdDireccionComercial, DescDireccionComercial FROM TB_BI_DimOficina where IdDireccionComercial in (26862,26861,31690) 

SELECT * FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria where Oficina = 152;
SELECT * FROM TB_DWH_GMMEmitidoCancelaciones_CargaDiaria where Oficina = 152;

SELECT * FROM TB_BI_AutrFactEmisionDoc WHERE IdOficina = 057 and NumPoliza = 169995
SELECT * FROM TB_BI_DanFactEmisionDoc WHERE IdOficina = 057 and NumPoliza = 16995
SELE

SELECT distinct NombreOficina, DescSubdireccionComercial, NombreOficinaComercial FROM tb_bi_dimoficina where IdSubdireccionComercial = 33106
SELECT TOP 100* FROM TB_BI_AutrFactEmisionDoc

SELECT * FROM TB_BI_DimPaquete 
where DescPaquete like '%IDRIVING%' 
--and IdPaquete 
AND emi.IdPaquete IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610, 4034, 4035) --Mandarle a Erneest para modificar las vistas 

SELECT * 
FROM Ventas.VW_DWH_AutrConservacion_IDRIVING

SELECT TOP (1000) *
  FROM Tb_Bi_AutrFactEmisionCob

SELECT * FROM TB_BI_DimOficina where IdDireccionComercial = 31690


        SELECT nipperfilagente,nombreoficina FROM TB_BI_DimAgente
        left join tb_bi_dimoficina on TB_BI_DimAgente.idoficina = tb_bi_dimoficina.idoficina
       

SELECT * FROM TB_DWH_GMMSiniestros_Gral order by NumSiniestro, NumReclamo --Evento Reportado = causa

SELECT * FROM dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria where  LEFT(FemiRbo,4) = 202504

SELECT CONCAT(nipperfilagente, ' ',nombreagente) Agentes FROM TB_BI_DimAgente

SELECT * FROM Dshd.VW_DWH_GmmMetaPagadoxEjecutivo where SSO in (430008282) and periodo between 202501 and 202512
SELECT * FROM Dshd.VW_DWH_DanMetaPagadoxEjecutivo where SSO in (430008282) and periodo between 202501 and 202512
SELECT * FROM Dshd.VW_DWH_AutrMetaPagadoxEjecutivo where SSO in (430008412) and periodo between 202501 and 202512
SELECT * FROM VW_BI_AutrFactMeta where IdPerfilEjecutivo in (430009708) and Periodo BETWEEN 202501 and 202512 order by periodo

SELECT * FROM Dshd.VW_DWH_GmmMetaPrimaEmitidaxEjecutivo WHERE Periodo>=202501 

SELECT * FROM TB_DWH_AutrPresupuestoPrimaPagadaxOficina where anio = 2025 and IdOficina in (146, 176, 891)

SELECT * FROM Tb_BI_DimOrigenOT = 3865

SELECT TOP 5 *
FROM DWH.Tb_BI_GrlSinReporte AS rep
WHERE rep.IdLineaNegocio=4

SELECT TOP 5 *
FROM dwh.Tb_BI_GrlSinReclamo
 
SELECT *
FROM DMSin.Tb_BI_AutSinSiniestros sinaut 
where TipoPerdida = 1 and year(TiempoOcurrencia) = 2025 and MONTH(TiempoOcurrencia) = 6
 
SELECT TOP 5 *
FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
WHERE IdLineaNegocio=4

SELECT * FROM VW_BI_DimVehiculo as cv where DescTipoVehiculo like '%TRACTOCAMIONES%'