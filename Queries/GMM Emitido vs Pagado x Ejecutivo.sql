--------------------- GMM EMITIDO x EJECUTIVO ------------------------------
SELECT 
	CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo) 'Nombre Agente', 
	sum(gmm.Prima_Total) AS 'Prima'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm
LEFT JOIN TB_BI_DimAgente dage ON dage.NipPerfilAgente = gmm.NAgente
Left join TB_BI_DimEjecutivo eje on eje.idejecutivo = dage.IdPerfilEjecutivo
WHERE gmm.Periodo = 202411
	--AND gmm.NAgente = 
GROUP BY
CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo)
order by
CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo) desc

--------------------- GMM PAGADO x EJECUTIVO --------------------------
SELECT
    CONCAT(eje.idejecutivo, ' ', eje.NombreEjecutivo) 'Nombre Agente',
    sum(gmm.Prima) AS 'Prima Pagada'
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

----------------------------------------------------------------------------
SELECT * FROM TB_BI_DimEjecutivo
SELECT TOP 10* FROM Dshd.VW_DWH_GMMPrimaNeta
SELECT TOP 10* FROM gmm