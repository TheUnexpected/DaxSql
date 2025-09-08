SELECT base.periodo,
		base.direccioncomercial,
		base.subdireccioncomercial,
		base.DescCanalComercial,
		
		count(base.numeroserie) AS A_renovar,
		sum(base.reno) AS Renovadas,
		CAST(sum(base.reno) AS NUMERIC) / CAST(count(base.numeroserie) AS NUMERIC) AS Porc_Reno

FROM (
	SELECT con.DireccionComercial,
			con.SubDireccionComercial,
			age.DescCanalComercial,
			con.NumeroSerie,
			con.Periodo,
			CASE WHEN con.Renovacion='SI' THEN 1 ELSE 0 END AS reno
			
	FROM tmp.Tb_Bi_Observatorio272Conservacion AS con
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=con.AgenteID
	
	
	WHERE con.Periodo BETWEEN 202301 AND 202503
	
) AS base

GROUP BY base.periodo,
		base.direccioncomercial,
		base.subdireccioncomercial,
		base.DescCanalComercial