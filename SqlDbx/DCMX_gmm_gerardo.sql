SELECT gmm.Periodo,
		case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end as Ciudad,


		sum(Prima_Total)  AS emitida


FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=gmm.NAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina


where (ofi.NombreOficinacomercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') OR ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias'))
and (ofi.nombreOficinaComercial) not in ('Pachuca','Toluca','Cuernavaca','Acapulco')
AND Periodo BETWEEN 202401 AND 202410


GROUP BY gmm.Periodo,
		case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end
