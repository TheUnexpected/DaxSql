SELECT  sum(aca.PrimaNetaSiniestroConvenido)  AS Siniestros, sum(aca.PrimaNetaDevengadaConvenido) AS Devengada
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca
WHERE Periodo BETWEEN 202301 AND 202304
AND aca.IdDespacho IN (314)
AND idlineaNegocio IN (4)