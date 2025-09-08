SELECT left(emicob.FechaTransaccion,6) as Periodo,
		tpol.DescGrupoTipoPoliza,
		case when tv.descmarcavehiculo in ('FRONTERIZO', 'REGULARIZADO') then 'Fronterizos'
        else 'Otros' end as T_Vehiculo,
        case when paq.idpaquete in (2610,2609,2608,2607,2530,2529,2459,2458) then 'Idriving'
                when paq.idpaquete in (3211) then 'Prime'
                else 'Otros' end as Paquete,
        case when tveh.idtipovehiculo =22809 then 'Tracto'
                else 'Otros' end as Tipo_V,
        case when ofi.NombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end as Ciudad,

	
		sum(emicob.PrimaNeta) AS Prima_Neta
		--round(sum(emicob.PrimaTotal),0) AS Prima_Total


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN TB_BI_dimTipoPoliza AS tpol
ON tpol.IdTipoPoliza=emi.IdTipoPoliza


LEFT JOIN VW_BI_DimVehiculo  AS tv
ON tv.idvehiculointerno=emi.IdVehiculo

left join TB_BI_dimPAQUETE as paq
on paq.idpaquete=emi.idpaquete

left join TB_BI_DimOficina as ofi
on ofi.IdOficina=emi.IdOficina

left join TB_BI_DimTipoVehiculo as tveh
on tveh.idtipovehiculo=emi.idtipovehiculo

where (ofi.NombreOficinacomercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') OR ofi.descSubdireccioncomercial in ('Mexico Despachos', 'Mexico Promotorias'))
and (ofi.nombreOficinaComercial) not in ('Pachuca','Toluca','Cuernavaca','Acapulco')
and emicob.FechaTransaccion BETWEEN 20240901 AND 20241031 

GROUP BY  left(emicob.FechaTransaccion,6),
		tpol.DescGrupoTipoPoliza,
		case when tv.descmarcavehiculo in ('FRONTERIZO', 'REGULARIZADO') then 'Fronterizos'
        else 'Otros' end,
        case when paq.idpaquete in (2610,2609,2608,2607,2530,2529,2459,2458) then 'Idriving'
                when paq.idpaquete in (3211) then 'Prime'
                else 'Otros' end,
        case when tveh.idtipovehiculo =22809 then 'Tracto'
                else 'Otros' end,
        case when ofi.nombreOficinaComercial in ('Monterrey Agentes','Monterrey Promotorías', 'Monterrey Despachos') then 'Monterrey'
                when ofi.DescSubdireccionComercial in ('Mexico Despachos', 'Mexico Promotorias') then 'CDMX'
                else 'Otros' end
