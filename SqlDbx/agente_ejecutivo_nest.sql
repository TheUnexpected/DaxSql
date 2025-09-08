SELECT DISTINCT age.NipPerfilAgente,
		concat(isnull(eje.IdEjecutivo,0), ' ', isnull(eje.NombreEjecutivo,'Sin Ejecutivo')) AS Ejecutivo,
		isnull(eje.IdEjecutivo,0) AS IdEjecutivo,
		isnull(eje.NombreEjecutivo,'Sin Ejecutivo') AS NombreEjecutivo
	
FROM TB_BI_DimAgente AS age
	
left JOIN TB_BI_DimEjecutivo AS eje
ON isnull(eje.IdEjecutivo,0)=age.IdPerfilEjecutivo
--AND eje.IdEjecutivo Is NOT null

inner JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=age.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861,26859)

--WHERE age.DescEstatusAgente='VIGOR'
