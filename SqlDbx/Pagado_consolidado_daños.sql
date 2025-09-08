SELECT LEFT (cobr.FechaPago,6) AS Periodo,
		--sum (cobr.PrimaNeta) AS Neta_sin_cambio , 
		round(sum(cobr.PrimaNeta*tc.TipoCambio),0) AS Pagada

FROM dbo.TB_BI_DanFactCobrado AS cobr

INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=cobr.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=cobr.IdMoneda
AND tc.Periodo = left(cobr.FechaPago,6)

WHERE cobr.FechaPago BETWEEN 20240101 AND 20241231

GROUP BY LEFT (cobr.FechaPago,6)