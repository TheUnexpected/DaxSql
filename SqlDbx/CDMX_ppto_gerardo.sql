SELECT Periodo,
		case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end as Ciudad,


		sum(met_aut.PrimaNetaMetaEmision) AS meta

--FROM VW_BI_DanFactMetaOficina AS met_aut

FROM Dshd.VW_DWH_GMMPptoxOficina AS met_aut

left join TB_BI_DimOficina as ofi
on ofi.IdOficina=met_aut.IdOficina


where (ofi.NombreOficinacomercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') OR ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias'))
and (ofi.nombreOficinaComercial) not in ('Pachuca','Toluca','Cuernavaca','Acapulco')

AND met_aut.Periodo>=202310

GROUP BY Periodo,
		case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end