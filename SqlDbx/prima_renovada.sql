select base.*,
        plz.Unidades,
        --renov.numpolizaanterior,
        case when  renov.numpolizaanterior>0 then 1 else 0 end as renov,
        renov.Emitida_Renov,
        renov.Unidades_renov,
        renov.Pagada_renov
        

from ( 

SELECT emi.IdOficina, 
		emi.NumPoliza,
        --ofi.oficinacomercial,
		
	     sum(emicob.PrimaNeta) AS Emitida_Autos
	   
FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento	

inner join TB_BI_DimOficina as ofi
on ofi.idoficina=emi.idOficina
and ofi.IdDireccionComercial IN (26862,31690,26861)

WHERE emi.fechafinvigencia between '2025-01-01' and '2025-05-31'--aquí mueven el día
--where emicob.fechatransaccion between '2024-01-01' and '2024-01-31'
and emi.idtipopoliza=4013
--and emi.idtipodocumento in (21,91,531,351)
	--AND ofi.IdOficina IN (916,273)

GROUP BY emi.IdOficina, 
		emi.NumPoliza
			
) as base

LEFT JOIN 

(

SELECT emi.idoficina,
		emi.NumPoliza,
		
		sum(tec.UnidadesEmitidasReales) AS Unidades

FROM  TB_BI_AutrFactEmisionDoc  AS emi

inner JOIN TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
--AND tec.Periodo >=202301

inner join TB_BI_DimOficina as ofi
on ofi.idoficina=emi.idOficina
and ofi.IdDireccionComercial IN (26862,31690,26861)

where emi.idtipopoliza=4013

GROUP BY emi.idoficina,
		emi.NumPoliza

) as plz

on plz.Idoficina=base.Idoficina
and base.numpoliza=plz.numpoliza

LEFT JOIN 

(

SELECT emi.idoficina,
		emi.NUMPOLIZAANTERIOR, 

         sum(tec.PrimaNeta) AS Emitida_Renov,
         sum(tec.unidadesemitidasreales) as Unidades_Renov,
         sum(tec.primanetapropiapagada) as Pagada_renov

FROM  TB_BI_AutrFactEmisionDoc  AS emi

inner JOIN TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
--AND tec.Periodo >=202301

inner join TB_BI_DimOficina as ofi
on ofi.idoficina=emi.idOficina
and ofi.IdDireccionComercial IN (26862,31690,26861)

where emi.idtipopoliza=4013

group by emi.idoficina,
		emi.NUMPOLIZAANTERIOR

) as renov

on renov.Idoficina=base.Idoficina
and base.numpoliza=renov.numpolizaanterior