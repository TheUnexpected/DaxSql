SELECT 
    --gmm.Periodo,
    ofi.IdOficina,
   --age.NipPerfilAgente,
   
    --gmm.RamoSubRamol,
    sum(gmm.Prima_Total) AS 'Prima Emitida'
FROM Dshd.VW_DWH_GMMPrimaNeta gmm 
 LEFT JOIN TB_BI_DimAgente age ON age.NipPerfilAgente = gmm.NAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
  gmm.Periodo BETWEEN 202401 and 202408
   --AND ofi.IdDireccionComercial in (31690,26861,26862)
  --and ofi.nombreoficinacomercial like'%villahermosa%'

    
GROUP BY 
    ofi.IdOficina
    --age.NipPerfilAgente

----------------------- ACC ---------------------
SELECT sum(ap.PrimaNetaVigencia) 
FROM TB_BI_VgcaFactEmisionDoc AS ap
WHERE ap.Periodo BETWEEN 202501 AND 202508