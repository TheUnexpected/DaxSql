SELECT tec.Periodo,
        ofi.descdireccioncomercial,
        ofi.descsubdireccioncomercial,
        ofi.nombreoficinacomercial,
        ofi.nombreoficina,
        eje.nombreejecutivo,
        age.NipAgente,
        concat(age.nipperfilagente,' - ',age.NombreAgente) as Nombre,
        age.fechaalta,
        case when age.DescCanalComercial in ('PROMOTORÍAS MULTIMARCA', 'PROMOTORÍAS EXCLUSIVAS') THEN 'Promotoría'
        when age.DescCanalComercial ='DESPACHOS' then 'Despachos'
        else 'Otro' end as Tipo_Convenio,
        age.descestatusperfil,

		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida
		--sum(tec.Ocurrido) AS Ocurrido,
		--sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,

FROM TB_BI_DanFactEmisionDoc AS emi


INNER join TB_DWH_DanBaseTecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.Periodo BETWEEN 202504 AND 202512

left join tb_bi_dimagente as age
on age.NipPerfilAgente=emi.NipPerfilAgente

left join tb_bi_dimoficina as ofi
on ofi.idoficina=emi.idOficina

LEFT JOIN tb_bi_dimejecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo


GROUP BY ALL tec.Periodo,
        ofi.descdireccioncomercial,
        ofi.descsubdireccioncomercial,
        ofi.nombreoficinacomercial,
        ofi.nombreoficina,
        eje.nombreejecutivo,
        age.nipagente,
        concat(age.nipperfilagente,' - ',age.NombreAgente),
        age.fechaalta,
        case when age.DescCanalComercial in ('PROMOTORÍAS MULTIMARCA', 'PROMOTORÍAS EXCLUSIVAS') THEN 'Promotoría'
        when age.DescCanalComercial='DESPACHOS' then 'Despachos'
        else 'Otro' end,
        age.descestatusperfil