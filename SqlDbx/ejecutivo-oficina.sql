SELECT DISTINCT ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo) AS Ejecutivo
	
FROM TB_BI_DimAgente AS age
	
inner JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo
AND eje.IdEjecutivo Is NOT null

inner JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=age.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

WHERE age.DescEstatusAgente NOT IN ('CANCELADO','FALLECIDO')
--AND ofi.NombreOficinaComercial LIKE '%Guadalajara%'

--AND eje.IdEjecutivo IN  (430006350,430008647,430008880,430009517)

ORDER BY concat(eje.IdEjecutivo, ' ', eje.NombreEjecutivo)