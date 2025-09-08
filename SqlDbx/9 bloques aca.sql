SELECT aca.Periodo,
		aca.NipPerfilAgente,
		aca.NipAgente,
		age.NombreAgente,
		aca.IdOficina,
		neg.DescLineaNegocio,
		
		sum(aca.PrimaNetaEmitida) AS Emitida,
		sum(aca.PrimaNetaPagada) AS Pagada,
	  	sum(aca.PrimaNetaSiniestroConvenido) AS Ocurrido,
	  	sum(aca.PrimaNetaDevengadaConvenido) AS Devengada
	   

FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca


INNER JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=aca.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

INNER JOIN TB_BI_DimAgente AS age
ON age.NipPerfilAgente=aca.NipPerfilAgente
AND age.DescEstatusAgente='VIGOR'
AND age.NombreAgente NOT LIKE '%HDI%'
AND age.IdTipoAgente=19
	
LEFT JOIN DMSin.Tb_BI_CatLineaNegocio AS neg
ON neg.IdLineaNegocio=aca.IdLineaNegocio



WHERE aca.Periodo>=202101
AND aca.IdLineaNegocio IN (1,4)

Group BY aca.Periodo,
		aca.NipPerfilAgente,
		aca.NipAgente,
		age.NombreAgente,
		aca.IdOficina,
		neg.DescLineaNegocio