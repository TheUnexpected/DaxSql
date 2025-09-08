SELECT age.IdOficina,
		age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		concat(age.NipPerfilAgente, ' ',age.NombreAgente) AS Perfil,
		age.DescEstatusAgente,
		--eje.IdEjecutivo,
		--age.IdPerfilEjecutivo,
		tage.DescTipoAgente,
		--eje.NombreEjecutivo,
		concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) AS Ejecutivo,
		
		ofi.NombreOficinaComercial,
		ofi.NombreOficina
	
FROM TB_BI_DimAgente AS age
	
LEFT  JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.EjecutivoDanios
--AND eje.IdEjecutivo Is NOT null

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

LEFT JOIN tb_bi_dimtipoagente AS tage
ON tage.IdTipoAgente=age.IdTipoAgente


where age.IdTipoAgente NOT IN (641,20)
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
--AND ofi.DescSubdireccionComercial= 'Mexico Despachos'
--AND  ofi.IdOficina IN (179,552,553, 556,876,554,937)
--AND concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) !=''
--AND age.NipPerfilAgente IN (58388,67406,67411)
--and eje.IdEjecutivo IN (430010203)
AND age.EjecutivoDanios IN (430010203)
--and ofi.NombreOficinaComercial= 'Queretaro Promotorias'




ORDER BY ofi.IdOficina, ofi.NombreOficinaComercial