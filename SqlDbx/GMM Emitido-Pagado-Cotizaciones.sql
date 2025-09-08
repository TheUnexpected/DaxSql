SELECT 
    gmm.Periodo mes,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.Periodo BETWEEN 202501 and 202506 THEN 'Primer Semestre 2025'
         WHEN gmm.Periodo BETWEEN 202401 AND 202406 THEN 'Primer Semestre 2024'
    END Semestre,
   -- age.nipagente,
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',
    --gmm.RamoSubRamol,
    sum(gmm.Prima_Total) AS 'Prima Emitida'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
WHERE
   (gmm.Periodo BETWEEN 202501 and 202506 or gmm.Periodo BETWEEN 202401 AND 202406)
   and ofi.IdOficina in (465,10,665,968,1057,466,467,468,469,470,473,475,592,684,747,749,803,808,898,926,955)
GROUP BY
    gmm.Periodo,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.Periodo BETWEEN 202501 and 202506 THEN 'Primer Semestre 2025'
         WHEN gmm.Periodo BETWEEN 202401 AND 202406 THEN 'Primer Semestre 2024'
    END
-------------------------------------------------------------------------------------
SELECT 
    FORMAT(gmm.FechaPago, 'yyyyMM') Periodo,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.FechaPago BETWEEN '2025/01/01' and '2025/06/30' THEN 'Primer Semestre 2025'
         WHEN gmm.FechaPago BETWEEN '2024/01/01' and '2024/06/30' THEN 'Primer Semestre 2024'
    END Semestre,
    --CONCAT(eje.idEjecutivo, ' ', eje.NombreEjecutivo) 'Ejecutivo',
    --age.nipagente,
    --CONCAT(age.NipPerfilAgente,' ', age.NombreAgente) 'Agente',    
    sum(gmm.Prima) AS 'Prima Pagada'
FROM VW_DWH_GmmCifrasDiariasPagadas gmm
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NumeroAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
   (gmm.FechaPago BETWEEN '2025/01/01' and '2025/06/30' or gmm.FechaPago BETWEEN '2024/01/01' and '2024/06/30')
   and ofi.IdOficina in (465,10,665,968,1057,466,467,468,469,470,473,475,592,684,747,749,803,808,898,926,955)
GROUP BY
    FORMAT(gmm.FechaPago, 'yyyyMM'),
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.FechaPago BETWEEN '2025/01/01' and '2025/06/30' THEN 'Primer Semestre 2025'
         WHEN gmm.FechaPago BETWEEN '2024/01/01' and '2024/06/30' THEN 'Primer Semestre 2024'
    END
-------------------------------------------------------------------------------
SELECT 
  FORMAT(gmm.FechaCotiz, 'yyyyMM') Periodo,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.FechaCotiz BETWEEN '2025/01/01' and '2025/06/30' THEN 'Primer Semestre 2025'
         WHEN gmm.FechaCotiz BETWEEN '2024/01/01' and '2024/06/30' THEN 'Primer Semestre 2024'
    END Semestre,
    COUNT(NumCotizacion) cotizaciones
FROM dbo.TB_DWH_GMMCotizaciones gmm
 LEFT JOIN TB_BI_DimAgente age 
  ON age.NipPerfilAgente = gmm.CveAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
WHERE
  (gmm.FechaCotiz BETWEEN '2025/01/01' and '2025/06/30' or gmm.FechaCotiz BETWEEN '2024/01/01' and '2024/06/30')
   and ofi.IdOficina in (465,10,665,968,1057,466,467,468,469,470,473,475,592,684,747,749,803,808,898,926,955)
GROUP BY
  FORMAT(gmm.FechaCotiz, 'yyyyMM'),
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    CASE WHEN gmm.FechaCotiz BETWEEN '2025/01/01' and '2025/06/30' THEN 'Primer Semestre 2025'
         WHEN gmm.FechaCotiz BETWEEN '2024/01/01' and '2024/06/30' THEN 'Primer Semestre 2024'
    END