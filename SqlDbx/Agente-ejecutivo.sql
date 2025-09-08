SELECT age.IdOficina,
		age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		concat(age.NipPerfilAgente, ' ',age.NombreAgente) AS Perfil,
		age.FechaAlta,
		age.DescEstatusAgente,
		--eje.IdEjecutivo,
		age.IdPerfilEjecutivo,
		tage.DescTipoAgente,
		--eje.NombreEjecutivo,
		concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) AS Ejecutivo,
		
		ofi.NombreOficinaComercial,
		ofi.NombreOficina
	
FROM TB_BI_DimAgente AS age
	
LEFT  JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo
--AND eje.IdEjecutivo Is NOT null

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina



LEFT JOIN tb_bi_dimtipoagente AS tage
ON tage.IdTipoAgente=age.IdTipoAgente


where age.IdTipoAgente NOT IN (641,20)
AND age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
--AND (ofi.DescSubdireccionComercial IN ('Mexico Despachos', 'Mexico Promotorias') OR ofi.NombreOficinaComercial= 'Monterrey Promotorías')
--AND  ofi.IdOficina IN (653)
--AND concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) !=''
--AND age.NipPerfilAgente IN (58388,67406,67411)
--where eje.IdEjecutivo IN (430010203)
And age.IdPerfilEjecutivo IN (217015007)
--and ofi.NombreOficinaComercial IN ('Guadalajara Promotorías')
--AND ofi.DescDireccionComercial IN ('Norte')
--or ofi.IdOficina IN (563,806,1029,1030))

ORDER BY ofi.IdOficina, ofi.NombreOficinaComercial