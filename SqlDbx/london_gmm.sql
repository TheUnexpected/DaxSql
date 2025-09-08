SELECT emi.Periodo,
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

		sum(emi.Prima_Total) AS Emitida
		--sum(tec.Ocurrido) AS Ocurrido,
		--sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,

FROM Dshd.VW_DWH_GMMPrimaNeta AS emi

left join tb_bi_dimagente as age
on age.NipPerfilAgente=emi.NAgente

left join tb_bi_dimoficina as ofi
on ofi.idoficina=emi.idOficina

LEFT JOIN tb_bi_dimejecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo


WHERE emi.Periodo>=202504

GROUP BY emi.Periodo,
        ofi.descdireccioncomercial,
        ofi.descsubdireccioncomercial,
        ofi.nombreoficinacomercial,
        ofi.nombreoficina,
        eje.nombreejecutivo,
        age.NipAgente,
        concat(age.nipperfilagente,' - ',age.NombreAgente),
        age.fechaalta,
        case when age.DescCanalComercial in ('PROMOTORÍAS MULTIMARCA', 'PROMOTORÍAS EXCLUSIVAS') THEN 'Promotoría'
        when age.DescCanalComercial='DESPACHOS' then 'Despachos'
        else 'Otro' end,
        age.descestatusperfil