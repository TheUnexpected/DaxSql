
SELECT aux.Periodo,
		aux.NipPerfilAgente,
		aux.IdOficina,

		
		sum(aux.PrimaNetaPropiaSinCoaseguro) AS Emitida
	   --	sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
	   --	sum(tec.UnidadesEmitidasReales) AS Unidades,
	   --	sum(tec.Ocurrido) AS Ocurrido,
	   --	sum(tec.RiesgoVigente) AS RV
		
FROM (		

SELECT tec.Periodo, emi.NipPerfilAgente, emi.IdOficina, tec.PrimaNetaPropiaSinCoaseguro

FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND Periodo>=202210

INNER JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=emi.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

) AS aux



GROUP BY aux.Periodo,
		aux.NipPerfilAgente,
		aux.IdOficina