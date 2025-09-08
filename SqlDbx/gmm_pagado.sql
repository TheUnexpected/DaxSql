SELECT pag.RamoSubramol,
		pag.Oficina,
		pag.Pma1 AS Prima_Pagada,
		pag.FechaPago,
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		age.NombreAgente,
		age.NipPerfilAgente



FROM 

(SELECT *

FROM TB_DWH_GMMRecibosCobrados_CargaDiaria 

UNION all

SELECT *
FROM dbo.TB_DWH_GmmcRecibosCobrados_CargaDiaria

) AS pag

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=pag.Oficina 

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=pag.NAgente

WHERE pag.FechaPago BETWEEN '2023-01-01' AND '2024-05-31'