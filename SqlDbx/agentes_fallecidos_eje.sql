SELECT ofi.IdOficina,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		age.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		concat(age.NipPerfilAgente, ' ',age.NombreAgente) AS Perfil,
		age.DescEstatusAgente,
		eje.IdEjecutivo,
		eje.NombreEjecutivo,
		concat(eje.IdEjecutivo, ' - ', eje.NombreEjecutivo) AS Ejecutivo

FROM TB_BI_DimAgente AS age

left JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE age.DescEstatusAgente IN ('CANCELADO','FALLECIDO')
AND eje.IdEjecutivo IS NOT NULL



ORDER BY ofi.IdOficina