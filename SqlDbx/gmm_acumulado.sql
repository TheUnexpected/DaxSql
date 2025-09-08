
SELECT ofi.DescSubdireccionComercial, ofi.NombreOficinaComercial, ofi.NombreOficina,

		sum(base.Prima_Total) AS Emitida

FROM Dshd.VW_DWH_GMMPrimaNeta AS base

left JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

where periodo BETWEEN 202401 AND 202412

GROUP BY ofi.DescSubdireccionComercial, ofi.NombreOficinaComercial, ofi.NombreOficina