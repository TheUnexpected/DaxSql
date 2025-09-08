
SELECT  cob.NumReclamo,
	
	
				sum(cob.Ocurrido) AS Ocurrido, 
				sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
				sum(cob.RecuperacionesTercerosResponsables)+isnull((SELECT sum(sipac.Monto) 
					FROM tb_bi_autrajusteSipacCopac AS sipac
					WHERE sipac.NumReclamo=cob.NumReclamo 
					AND sipac.FechaMovimiento BETWEEN 20230101 AND 20230430	
				),0)AS Rec_TercerosII,
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
		
	 	WHERE cob.IdLineaNegocio=4
		AND cob.idoficinaemision=62
		AND cob.NumPoliza IN (49117,49119,49142,49144,49556)
		AND  cob.FechaMovimiento BETWEEN 20230401 AND 20230430
				


GROUP BY cob.NumReclamo