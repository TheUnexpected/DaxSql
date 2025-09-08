SELECT base.*,
		datediff(year,base.Nacimiento,getdate()) AS Edad

FROM (
	
	SELECT  DISTINCT age.NombreAgente,
					trim(RIGHT(LEFT(age.RFC,10),6)) AS NacimientoRFC,
					CASE WHEN year(convert(DATE, RIGHT(LEFT(age.RFC,10),6),12))<2024 THEN convert(DATE, RIGHT(LEFT(age.RFC,10),6),12)
						ELSE dateadd(year,-100,convert(DATE, RIGHT(LEFT(age.RFC,10),6),12)) END AS nacimiento
	
	
	FROM TB_BI_DimAgente AS age
	
	WHERE age.DescTipoPersona = 'Física'
	AND age.DescEstatusAgente='VIGOR'
	AND age.NombreAgente NOT LIKE '%HDI%'

) AS base



