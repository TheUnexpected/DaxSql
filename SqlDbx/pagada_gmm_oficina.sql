SELECT ofi.NombreOficinaComercial AS Oficina_Comercial,
		
		sum(base.Pma1) AS Pagada

FROM (

	SELECT * 
	
	FROM dbo.TB_DWH_GmmcRecibosCobrados_CargaDiaria
	
	UNION ALL 
	
	SELECT * 
	
	FROM TB_DWH_GMMRecibosCobrados_CargaDiaria
	
) AS base


LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=base.Oficina

WHERE base.FechaPago BETWEEN '2024-01-01' AND '2024-05-31'

GROUP BY ofi.NombreOficinaComercial