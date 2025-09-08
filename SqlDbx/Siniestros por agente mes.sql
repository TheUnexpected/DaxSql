

SELECT base.*, rep.TiempoInicioAtencionReporte


FROM (

	SELECT sin.NumReclamo
	  , Ocurrido = sum(sin.Ocurrido)
	  , GastosAjuste =  sum(sin.GastosDirectos)
	  , GastosIndirectos = sum(sin.GastosIndirectos)
	  , Salvamentos = sum(sin.Salvamentos)
	  , Rec3Ros = sum(sin.RecuperacionesTercerosResponsables + isnull(sc.Monto, 0))
	  , SinTotal = 
	      (
	        sum(sin.Ocurrido)
	        + sum(sin.GastosDirectos)
	        + sum(sin.GastosIndirectos)
	        - sum(sin.Salvamentos)
	        - sum(sin.RecuperacionesTercerosResponsables + isnull(sc.Monto, 0))
	      )
	from
	  (
	    SELECT sin.NumReclamo
	      , Ocurrido = sum(sin.Ocurrido)
	      , GastosDirectos = sum(sin.GastosAjuste)
	      , GastosIndirectos = sum(sin.GastosIndirectos)
	      , Salvamentos = sum(sin.EstimadoSalvamentos + sin.AjustesSalvamentos)
	      , RecuperacionesTercerosResponsables = sum(RecuperacionesTercerosResponsables)
	    from
	      DMSin.Tb_BI_AutSinDatosEconomicosCob sin
	    
	    -- aquí hay que poner los filtros que queramos de fechas, oficinas o agente
	    WHERE sin.IdLineaNegocio=4
		AND sin.FechaMovimiento BETWEEN 20240801 AND 20240831
		AND sin.NipPerfilAgente IN (55906,56893,56894,95734,103860,105110,105602,106182,107088,111459)

	      
	    group BY sin.NumReclamo
	  ) sin
	    left join
	      (
	        SELECT sc.NumReclamo
	          , Monto = sum(sc.Monto)
	        from
	          dbo.TB_BI_AutrAjusteSipacCopac sc
	        WHERE sc.FechaMovimiento BETWEEN 20240801 AND 20240831
	        group by sc.NumReclamo
	      ) sc
	    ON sc.NumReclamo = sin.NumReclamo
	   
	   GROUP BY sin.numreclamo 

) AS base

LEFT JOIN DWH.Tb_BI_GrlSinReporte AS rep
ON rep.NumReclamo=base.NumReclamo
AND rep.IdLineaNegocio=4



