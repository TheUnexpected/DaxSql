SELECT tec.Periodo,
		emi.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		emi.IdOficina,
		
		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(tec.PrimaNetaPropiaPagada) AS Pagada,
	  	sum(tec.Ocurrido) AS Ocurrido,
	  	sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada
	   

FROM  HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

inner JOIN TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
AND tec.NumDocumento = emi.NumDocumento 
AND tec.Periodo >=202101

INNER JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

INNER JOIN TB_BI_DimAgente AS age
ON age.NipPerfilAgente=emi.NipPerfilAgente
AND age.DescEstatusAgente='VIGOR'
AND age.NombreAgente NOT LIKE '%HDI%'
AND age.IdTipoAgente=19
	

Group BY tec.Periodo,
		emi.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		emi.IdOficina