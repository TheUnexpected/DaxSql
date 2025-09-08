SELECT base.CveAgente,
		base.Producto,
		base.Cliente,
		base.Edad,
		base.Sexo,
		base.TipoNegocio,
		base.maternidadtitular,
		
		min(base.NumCotizacion) AS Cotizacion,
		min(base.FechaCotiz) AS FechaCotiz,
		sum(base.PLZ) AS PLZ,
		sum(base.EsPrueba) AS Prueba


FROM (
		
		SELECT cot.*,
				CASE WHEN emi.num_cotizacion is NULL THEN 0
				ELSE 1 END AS PLZ,
				emi.*
		
		FROM dbo.TB_DWH_GMMCotizaciones AS cot
		
		LEFT JOIN (SELECT DISTINCT gmm.NUM_COTIZACION, gmm.Renueva
		
		
					FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm
		
					) 
					
		AS emi
		
		ON emi.Num_Cotizacion=cot.NumCotizacion
		
		--WHERE FechaCotiz BETWEEN'2024-01-01' AND '2024-01-31'

) AS base


GROUP BY base.CveAgente,
		base.Producto,
		base.Cliente,
		base.Edad,
		base.Sexo,
		base.TipoNegocio,
		base.maternidadtitular

ORDER BY plz DESC, prueba desc