SELECT CAST(LEFT(ap.Periodo,4) AS INTEGER) AS Anio,
	  aseg.NombreEstado,
	  'AP' AS DescGrupoTipoPoliza,
	  
		sum(ap.PrimaNetaVigencia) AS neta
		
FROM TB_BI_VgcaFactEmisionDoc AS ap

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=ap.CveAsegurado


WHERE ap.Periodo BETWEEN 201901 AND 202312

GROUP BY  CAST(LEFT(ap.Periodo,4) AS INTEGER),
	  aseg.NombreEstado