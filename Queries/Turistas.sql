SELECT LEFT(turi.periodo,4) año,
		--sum(turi.PrimaTotal) AS total,
		round(sum(turi.PrimaNeta),0) AS neta --cuadra con cubos
FROM VW_BI_AuttFactEmision turi
WHERE turi.Periodo BETWEEN 201901 AND 202412
GROUP BY LEFT(turi.periodo,4)