SELECT age.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		age.IdOficina,
		nest.Promotoria,
		CASE WHEN age.FechaAlta >='2021-01-01' THEN CAST (year(age.FechaAlta) AS VARCHAR)
		ELSE 'Otros Casos' END AS generacion

 
FROM TB_BI_DimAgente AS age
 
LEFT JOIN TB_BI_DimProgramasAgentes AS nest
ON nest.NipPerfilAgente= age.NipPerfilAgente
 
WHERE nest.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta', 'HDI Spot')