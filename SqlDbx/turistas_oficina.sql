SELECT turi.Periodo, 
		--turi.IdOficina,
		ofi.NombreOficina,
		--turi.NipPerfilAgete,
		concat(age.NipPerfilAgente, ' - ',age.NombreAgente) AS Agente,
		concat(age.IdPerfilEjecutivo, ' - ',eje.NombreEjecutivo) AS Ejecutivo,
		
		--sum(turi.PrimaTotal) AS total,
		sum(turi.PrimaNeta) AS neta
		
FROM VW_BI_AuttFactEmision turi

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=turi.NipPerfilAgete

INNER JOIN TB_BI_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina
AND ofi.NombreOficinaComercial = 'Chihuahua'

LEFT JOIN tb_bi_dimejecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo

WHERE turi.Periodo BETWEEN 202301 AND 202312

GROUP BY turi.Periodo, 
		--turi.IdOficina,
		ofi.NombreOficina,
		--turi.NipPerfilAgete,
		concat(age.NipPerfilAgente, ' - ',age.NombreAgente),
		concat(age.IdPerfilEjecutivo, ' - ',eje.NombreEjecutivo)