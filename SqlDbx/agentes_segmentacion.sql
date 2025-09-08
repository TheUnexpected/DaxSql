SELECT upper(ofi.DescDireccionComercial) AS Direccion,
		upper(ofi.DescSubdireccionComercial) AS Subdireccion,
		upper(ofi.NombreOficinaComercial) AS OficinaComercial,
		ofi.NombreOficina AS OficinaOperativa,
		base.NombreAgente,
		base.Fecha_alta


FROM (
	
	
	SELECT trim(age.NombreAgente) as NombreAgente,
			
			CAST(min(age.fechaalta)AS DATE) as Fecha_alta,
	        max(age.idoficina) As IdOficina
	
	
	FROM  TB_BI_DimAgente as age
	
	INNER JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	AND ofi.IdDireccionComercial IN (26862,31690,26861,26859)
	
	where age.idtipoagente=19
	AND age.DescEstatusAgente NOT IN ('FALLECIDO', 'CANCELADO')
	
	GROUP BY  trim(age.NombreAgente)
			
		
) AS base

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=base.idoficina