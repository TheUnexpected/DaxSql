

SELECT  cob.NumReclamo,
	
	
				sum(cob.Ocurrido) AS Ocurrido, 
				sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
				--sum(cob.RecuperacionesTercerosResponsables)+isnull((SELECT sum(sipac.Monto) 
				--	FROM tb_bi_autrajusteSipacCopac AS sipac
				--	WHERE sipac.NumReclamo=cob.NumReclamo 
				--	AND sipac.FechaMovimiento BETWEEN 20230101 AND 20230430	
				--),0)AS Rec_TercerosII,
				sum(cob.AjustesSalvamentos)+sum(cob.EstimadoSalvamentos) AS Salvamentos,
		
				sum(cob.GastosDirectos) AS gastos_directos, 
				sum(cob.GastosIndirectos) AS Gastos_indirectos,  
				--sum(cob.GastosAjuste) AS Gastos_ajustados,
				sum(cob.GastosHonorariosEmpleados)  AS  Hon_empleado,
				sum(cob.GastosHonorariosAjustadores) AS Hon_ajus,
				sum(cob.GastosHonorariosOtros) AS hon_otros,
				sum(cob.GastosHonorariosEmpleados)+sum(cob.GastosHonorariosAjustadores)+sum(cob.GastosHonorariosOtros) AS sum_hon,
				sum(cob.GastosHonorarios)AS hon,
				sum(cob.GastosGruas) AS gruas,
				sum(cob.OtrosGastos) AS otros_gastos,
				sum(cob.GastosHonorarios)+sum(cob.GastosGruas) +sum(cob.OtrosGastos) AS directosII


				
		FROM DMSin.tb_bi_dansinDatoseconomicoscob AS cob
		
	 	WHERE cob.IdLineaNegocio=1
		AND cob.NipPerfilAgente=59240
		AND cob.NumPoliza IN (1635,1632,1633,1668,1631,1629,1669,1628,1652,1658,1659,1660,1673,1672,1671,1661,1656,1662,1674,1667,1676,1675,1663,1649,1655,1664,1665,1678,1666,1657,1670,1653,1630,1650,1679,1688,1634,1636,1689,1654,1681,1683,1702,1700,1711)
		--AND  cob.FechaMovimiento BETWEEN 20230401 AND 20230430
				


GROUP BY cob.NumReclamo