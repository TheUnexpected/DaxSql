SELECT * FROM TB_BI_DanFactEmisionDoc 
where fechafinvigencia BETWEEN '2025-01-01' and '2025-03-31';

WITH CotVencidas AS (
    SELECT DISTINCT
IdOficina, 
NumPoliza 
--NumCertificado
FROM TB_BI_DanFactEmisionDoc t1
where exists(Select 1 
from TB_BI_DanFactCisVigentes t2 
where t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
and t2.NumDocumento = t1.NumDocumento
and t2.Periodo between convert(char(6),dateadd(month,-1,FechaFinVigencia),112) and convert(char(6),FechaFinVigencia,112))
and fechafinvigencia BETWEEN '2025-02-01' and '2025-03-31' --periodo 
and NumDocumento = 0
and IdPaquete not in (
1--PÓLIZA ESPECÍFICA
,226--PÓLIZA DE HOYO EN UNO
,3797--Seguro Montaje de Maquinaria
,3798--Seguro de Obra Civil
,512--KIPO
)
and (
(IdPaquete in 
(
10--POLIZA DE RESPONSABILIDAD CIVIL
,514--RESPONSABILIDAD CIVIL CONSTRUCTORES Y SERVICIOS
) and IdMesesVigenciaCis >= 11) or (IdPaquete not in (10,514))
) 
)

SELECT
    distinct dan.idoficina, dan.numPolizaAnterior
FROM TB_BI_DanFactEmisionDoc dan
inner join CotVencidas on CotVencidas.idoficina = dan.idoficina and CotVencidas.NumPoliza = dan.numPolizaAnterior

    --AND FechaInicioVigencia > '2025-01-31'
--   ON dan.NumCompletoCotizacion = CotVencidas.NumCompletoCotizacion
--WHERE dan.NumPolizaAnterior <> 0

SELECT * FROM TB_BI_DanFactEmisionDoc WHERE NumCotizacionMaestra  = 5097307
SELECT * FROM TB_BI_DanFactEmisionDoc WHERE NumPoliza in (15327, 10957, 9604, 11305, 5396, 4807) order by NumPoliza, IdTipoDocumento}

SELECT * FROM TB_BI_DimOficina where IdSubdireccionComercial = 26876

SELECT * 
FROM DMsin.TB_BI_CatVehiculo 
where IdMarcaVehiculo = 3494

SELECT  TOP 1000* FROM TB_BI_AutrBase2Tecnica
SELECT TOP 1000* FROM TB_BI_AutrFactEmisionDoc where numcotizacionmaestra = 885

SELECT DISTINCT 
IdOficina, 
NumPoliza,
NumDocumento,--
NumCertificado
INTO #PRUEBA --DROP TABLE #PRUEBA
FROM TB_BI_DanFactEmisionDoc t1
where exists(Select 1 
from TB_BI_DanFactCisVigentes t2 
where t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
and t2.NumDocumento = t1.NumDocumento
and t2.Periodo between convert(char(6),dateadd(month,-1,FechaFinVigencia),112) and convert(char(6),FechaFinVigencia,112))
and fechafinvigencia BETWEEN '2025-03-01' and '2025-03-31'
and NumDocumento = 0
and IdPaquete not in (
1--PÓLIZA ESPECÍFICA
,226--PÓLIZA DE HOYO EN UNO
,3797--Seguro Montaje de Maquinaria
,3798--Seguro de Obra Civil
,512--KIPO
)
and (
(IdPaquete in 
(
10--POLIZA DE RESPONSABILIDAD CIVIL
,514--RESPONSABILIDAD CIVIL CONSTRUCTORES Y SERVICIOS
) and IdMesesVigenciaCis >= 11) or (IdPaquete not in (10,514))
)

SELECT count(*) from #PRUEBA

SELECT DISTINCT t1.IdOficina,t1.NumPolizaAnterior 
FROM TB_BI_DanFactEmisionDoc t1
INNER JOIN #PRUEBA t2
ON t1.IdOficina = t2.IdOficina  
AND t1.NumPolizaAnterior = t2.NumPoliza
AND t2.NumDocumento = t1.NumDocumento
AND t2.NumCertificado = t1.NumCertificado
WHERE
NumPolizaAnterior <> 0  
and t1.NumDocumento = 0

