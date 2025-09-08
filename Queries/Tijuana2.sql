SELECT aux.NumReclamo,
		aux.Ocurrido-aux.Rec_Terceros-aux.Salvamentos+aux.Gastos_indirectos+aux.Gastos_ajustados+aux.Hon_empleado
		 AS Sin_Total
 
FROM(
	SELECT  cob.NumReclamo,

				sum(cob.Ocurrido) AS Ocurrido, 
				sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
				--sum(cob.RecuperacionesTercerosResponsables)+isnull((SELECT sum(sipac.Monto) 
				--	FROM tb_bi_autrajusteSipacCopac AS sipac
				--	WHERE sipac.NumReclamo=cob.NumReclamo 
				--	AND sipac.FechaMovimiento BETWEEN 20230101 AND 20230731
				--),0)AS Rec_TercerosII,
				sum(cob.AjustesSalvamentos)+sum(cob.EstimadoSalvamentos) AS Salvamentos,
				sum(cob.GastosDirectos) AS gastos_directos, 
				sum(cob.GastosIndirectos) AS Gastos_indirectos,  
				sum(cob.GastosAjuste) AS Gastos_ajustados,
				sum(cob.GastosHonorariosEmpleados)  AS  Hon_empleado,
				sum(cob.GastosHonorariosAjustadores) AS Hon_ajus,
				sum(cob.GastosHonorariosOtros) AS hon_otros,
				sum(cob.GastosHonorariosEmpleados)+sum(cob.GastosHonorariosAjustadores)+sum(cob.GastosHonorariosOtros) AS sum_hon,
				sum(cob.GastosHonorarios)AS hon,
				sum(cob.GastosGruas) AS gruas,
				sum(cob.OtrosGastos) AS otros_gastos,
				sum(cob.GastosHonorarios)+sum(cob.GastosGruas) +sum(cob.OtrosGastos) AS directosII
 
 
				
		FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
		WHERE IdLineaNegocio=4
		AND idoficinaemision IN (273,58)
		AND cob.FechaMovimiento BETWEEN 20250101 AND 20250731
		AND cob.NipAgente IN (
			SELECT desp.NipAgente
			FROM TB_BI_DimAgenteDespacho AS desp
			WHERE desp.IdDespacho IN (314)
	)

 
GROUP BY cob.NumReclamo
 
) AS aux