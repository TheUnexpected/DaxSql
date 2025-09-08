SELECT age.NipPerfilAgente,
		age.NombreAgente,
		age.IdOficina,
		
		LEFT(emicob.FechaTransaccion,4) AS Anio,
		
		--sum(emicob.PrimaNeta) AS Prima_Neta,
		sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Emitida



FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
--AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
ON mon.IdMoneda=emi.IdMoneda

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente


WHERE emicob.FechaTransaccion BETWEEN 20240501 AND 20240831

GROUP BY age.NipPerfilAgente,
		age.NombreAgente,
		age.IdOficina,
		
		LEFT(emicob.FechaTransaccion,4)