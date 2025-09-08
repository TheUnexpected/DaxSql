SELECT substring(CAST(jer.IdUsuarioN2 AS CHAR),1,9) AS Ejecutivo,
		substring(CAST(jer.IdUsuarioN3 AS CHAR),1,9) AS Gerente,
		substring(CAST(jer.IdUsuarioN4 AS CHAR),1,9) AS subdirector,
		ofi.DescSubdireccionComercial AS subdireccion,
		
		CASE WHEN ofi.DescSubdireccionComercial IN ('Bajio', 'Occidente') THEN substring(Cast(jer.IdUsuarioN3 AS CHAR),1,9)
		ELSE substring(Cast(jer.IdUsuarioN4 AS CHAR),1,9) END AS Autorizador
		

FROM Cv360.Tbl_CatPathJerarquia AS jer

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=jer.IdOficina

WHERE 
		CASE WHEN ofi.DescSubdireccionComercial IN ('Bajio', 'Occidente') THEN substring(Cast(jer.IdUsuarioN3 AS CHAR),1,9)
		ELSE substring(Cast(jer.IdUsuarioN4 AS CHAR),1,9) END IS NOT NULL