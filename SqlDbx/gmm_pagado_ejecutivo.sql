SELECT
    CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo) AS 'Ejecutivo',
    sum(gmm.Prima) AS 'Prima'
    
FROM VW_DWH_GMMCifrasDiariasPagadas  gmm

LEFT JOIN TB_BI_DimAgente dage
ON dage.NipPerfilAgente = gmm.NumeroAgente

Left join TB_BI_DimEjecutivo eje 
on eje.idejecutivo = dage.IdPerfilEjecutivo

WHERE year(gmm.FechaPago)*100+month(gmm.FechaPago) =202411

GROUP BY
CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo)

order by
CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo) desc