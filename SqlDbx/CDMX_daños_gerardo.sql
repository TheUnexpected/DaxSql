SELECT left(emicob.FechaTransaccion,6) as Periodo,
		
        case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end as Ciudad,

	
	  	sum(emicob.PrimaNeta*tc.TipoCambio) AS Prima_Neta


FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento



LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)

left join TB_BI_DimOficina as ofi
on ofi.IdOficina=emi.IdOficina




where (ofi.NombreOficinacomercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') OR ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias'))
and (ofi.nombreOficinaComercial) not in ('Pachuca','Toluca','Cuernavaca','Acapulco')
and emicob.FechaTransaccion BETWEEN 20240101 AND 20241031 

GROUP BY  left(emicob.FechaTransaccion,6),
		
        case when ofi.nombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end


ORDER BY Ciudad, Periodo