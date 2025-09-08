SELECT * FROM dbo.VW_BI_DimTipoCambio 
SELECT top 10*  FROM TB_BI_DanFactEmisionDoc
SELECT * FROM Tb_BI_DimLineaNegocioERP
SELECT * FROM tb_bi_dimgrlramos where descripcionramo like '%de carga%'
SELECT
        LEFT(emi.fechatransaccion,4) As Año,
        COUNT(distinct age.nombreagente) Agente
        --Top 100*
        --left(fechatransaccion)
        --round(sum(emicob.PrimaNeta*tc.TipoCambio),0) AS Prima_Neta
FROM TB_BI_DanFactEmisionCob AS emicob
 
 
INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1
 
LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento
 
LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
ON mon.IdMoneda=emi.IdMoneda
 
LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

left JOIN TB_BI_DimGrlRamos AS ramo
ON CAST (ramo.IdRamo AS INT)=CAST (emicob.ClaveRamo AS INT)
AND CAST (ramo.IdSubRamo AS INT)= CAST (emicob.ClaveSubRamo AS INT)
AND ramo.LineaNegocio='DAN'

LEFT JOIN TB_BI_DimAgente As age
ON age.nipperfilagente = emi.nipperfilagente

where   claveramo = 3 and clavesubramo = 1
        and emi.fechatransaccion between 20220101 and 20250331

GROUP BY LEFT(emi.fechatransaccion,4)
order by LEFT(emi.fechatransaccion,4)
