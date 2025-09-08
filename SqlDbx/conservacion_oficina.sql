SELECT base.Subdireccion,
		base.Oficina,
		--base.nombreoficina,
		
		count(DISTINCT(base.Numeroserie)) AS A_Renovar,
		sum(base.renov) AS Renovados
	
FROM (
	
	SELECT 	ofi.DescSubdireccionComercial AS Subdireccion,
	  	ofi.NombreOficinaComercial AS Oficina,
	  	ofi.NombreOficina,
	  	con.NumeroSerie,
	  	CASE WHEN con.Renovacion='SI' THEN 1
	  	ELSE 0 END AS renov
	 
	
	FROM tmp.Tb_Bi_Observatorio272Conservacion AS con
	
	LEFT JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=con.IdOficina
	
	WHERE Periodo BETWEEN 202401 AND 202412
	AND ofi.IdSubdireccionComercial IN (33106,33107)
	AND ofi.NombreOficinaComercial NOT IN ('Pachuca')

) AS base

GROUP BY base.Subdireccion,
		base.Oficina
	   --	base.nombreoficina