SELECT  cob.IdOficinaEmision,
		--cob.NumPoliza,
		--cob.NumCertificado,
		--sum(cob.RecuperacionesTercerosResponsables)+sum(cob.PreingresoSipac)+sum(cob.PreingresoCopac) AS Rec_Terceros,
		sum(cob.RecuperacionesTercerosResponsables)+isnull((SELECT sum(sipac.Monto) 
					FROM tb_bi_autrajusteSipacCopac AS sipac
					WHERE sipac.IdOficina=cob.IdOficinaEmision
					--AND sipac.NumPoliza=cob.NumPoliza
					--AND sipac.NumCertificado=cob.NumCertificado
					AND sipac.FechaMovimiento BETWEEN 20200101 AND 20211231
					--AND sipac.FechaMovimiento BETWEEN 20220101 AND 20230630
					--AND sipac.FechaMovimiento BETWEEN 20200101 AND 20230630
				),0)AS Rec_TercerosII
				

				
		FROM DMSin.tb_bi_autsinDatoseconomicoscob AS cob
		
		WHERE cob.IdLineaNegocio=4
		AND cob.idoficinaemision IN (139)
		--AND cob.NumPoliza=34761
		AND cob.FechaMovimiento BETWEEN 20200101 AND 20211231
		--AND cob.FechaMovimiento BETWEEN 20220101 AND 20230630
		--AND cob.FechaMovimiento BETWEEN 20220101 AND 20230630
	  
GROUP BY cob.IdOficinaEmision
		--cob.NumPoliza
		--cob.NumCertificado