
SELECT CAST(ap.Oficina AS INTEGER) AS Oficina,
		sum(ap.PrimaNetaVigencia) 

FROM TB_BI_VgcaFactEmisionDoc AS ap

WHERE ap.Periodo BETWEEN 202301 AND 202312

GROUP BY CAST(ap.Oficina AS INTEGER)


SELECT CAST(ap.CliNip AS INTEGER) AS Agente,
		sum(ap.PrimaNetaVigencia) 

FROM TB_BI_VgcaFactEmisionDoc AS ap

WHERE ap.Periodo BETWEEN 202301 AND 202312

GROUP BY CAST(ap.CliNip AS INTEGER)