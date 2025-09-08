SELECT CAST(LEFT(turi.Periodo,4) AS INTEGER) AS Anio,
	   CASE WHEN aseg.NombrePais !='MEXICO' THEN aseg.NombrePais
	   WHEN aseg.NombrePais='MEXICO' THEN aseg.NombreEstado END AS NombreEstado,
	   'Turistas' AS DescGrupoTipoPoliza,

		sum(turi.PrimaNeta) AS Prima_Neta
		
FROM VW_BI_AuttFactEmision turi



LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=turi.CveAsegurado

WHERE turi.Periodo BETWEEN 201901 AND 202312

GROUP BY CAST(LEFT(turi.Periodo,4) AS INTEGER),
	   CASE WHEN aseg.NombrePais !='MEXICO' THEN aseg.NombrePais
	   WHEN aseg.NombrePais='MEXICO' THEN aseg.NombreEstado END