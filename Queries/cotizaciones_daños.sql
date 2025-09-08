SELECT --LEFT(base.fecha,6) AS Periodo,
		base.Subdireccion,
		base.NombreOficinaComercial,
		
		count(cotizaciones) AS Ctz,
		sum(base.plz) AS plz

FROM (


	SELECT  DISTINCT cot.NumCompletoCotizacionMaestra AS cotizaciones,
					CASE WHEN cot.NumPoliza>0 THEN 1
					ELSE 0 END AS plz,
					ofi.DescSubdireccionComercial AS subdireccion,
					ofi.NombreOficinacomercial,
						
					min(cot.FechaCotizacion) AS fecha
	 
	FROM dwh.TB_Dwh_DanCotizacionesCob cot
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=cot.IdOficina
	 
	WHERE Eliminado=0
	AND NumDocumento=0 --nueva (preguntar renovado)
	AND NumPolizaAnterior=0 --renovado diferente de cero
	--AND ofi.IdSubdireccionComercial IN (33106,33107)
	--AND ofi.NombreOficinaComercial NOT IN ('Pachuca')
	 
	GROUP BY  cot.NumCompletoCotizacionMaestra,
			CASE WHEN cot.NumPoliza>0 THEN 1
			ELSE 0 END,
			ofi.DescSubdireccionComercial,
			ofi.NombreOficinacomercial
	 
	HAVING min(cot.FechaCotizacion) BETWEEN 20240301 AND 20240331

) AS base


GROUP BY --LEFT(base.fecha,6)
		base.Subdireccion,
		base.NombreOficinaComercial