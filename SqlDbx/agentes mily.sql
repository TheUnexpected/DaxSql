SELECT ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial AS Oficina_Comercial,
		ofi.NombreOficina AS Oficina_Operativa,
		ofi.IdOficina,
		age.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		age.FechaAlta,
		year(age.FechaAlta) AS Anio,
		month(age.FechaAlta) AS Mes
		  
	
	FROM TB_BI_DimAgente AS age 
	
	INNER JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	AND ofi.IdDireccionComercial IN (31690,26859,26861,26862)
	
	WHERE age.FechaAlta BETWEEN '20240101' AND '20240930'
	AND age.IdTipoAgente=19
	AND age.DescEstatusAgente IN ('VIGOR')
	--AND age.IdTipoPersona=1