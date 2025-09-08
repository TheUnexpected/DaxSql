SELECT LEFT(ap.periodo,4) año, sum(ap.PrimaNetaVigencia) 
FROM TB_BI_VgcaFactEmisionDoc AS ap
WHERE ap.Periodo BETWEEN 201901 AND 202412
GROUP BY LEFT(ap.periodo,4)