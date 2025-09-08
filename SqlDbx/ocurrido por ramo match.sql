SELECT LEFT(dan_cob.FechaMovimiento,4) AS Anio,
		cat.NombreEstado,
		ramo.DescripcionRamo,
		ramo.RamoTecnico,
        age.IdTipoAgente,
        
		sum(dan_cob.Ocurrido) AS ocurrido

FROM DMSin.Tb_BI_DanSinDatosEconomicosCob AS dan_cob

left JOIN TB_BI_DimGrlRamos AS ramo
ON CAST(concat(ramo.IdRamo, RIGHT(concat('000',ramo.IdSubRamo),3)) AS INTEGER)=dan_cob.IdSubramo
and ramo.LineaNegocio='DAN'


LEFT JOIN TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=dan_cob.NumCompletoCotizacion
AND emi.NumDocumento=dan_cob.NumDocumento


left JOIN TB_BI_dimAsegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado


LEFT JOIN 

		(SELECT DISTINCT IdEstado, NombreEstado
			FROM DMSin.Tb_BI_CatMunicipios
		) AS cat
ON cat.IdEstado=aseg.IdEstado

left join tb_bi_dimagente as age
on age.NipPerfilagente=emi.NipPerfilagente

WHERE dan_cob.FechaMovimiento BETWEEN 20190101 AND 20231231

GROUP BY LEFT(dan_cob.FechaMovimiento,4),
		cat.NombreEstado,
		ramo.DescripcionRamo,
		ramo.RamoTecnico,
        age.IdTipoAgente