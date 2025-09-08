SELECT --mon.DescMoneda,
		--sum(emicob.PrimaNeta) AS Prima_Neta,
		LEFT(emicob.FechaTransaccion,4) AS Anio,
		ramo.DescripcionRamo,
		ramo.DescClaveRR3Cat01,
		ramo.DescripcionIdPlanSeguroRR3,
		ramo.RamoTecnico,
		
		sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Pesos



FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
--AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

left JOIN TB_BI_DimGrlRamos AS ramo
ON CAST (ramo.IdRamo AS INT)=CAST (emicob.ClaveRamo AS INT)
AND CAST (ramo.IdSubRamo AS INT)= CAST (emicob.ClaveSubRamo AS INT)
AND ramo.LineaNegocio='DAN'


WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20231231

GROUP BY LEFT(emicob.FechaTransaccion,4),
		ramo.DescripcionRamo,
		ramo.DescClaveRR3Cat01,
		ramo.DescripcionIdPlanSeguroRR3,
		ramo.RamoTecnico