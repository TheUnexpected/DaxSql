SELECT aseg.NipAgrupador,
		aseg.NombreAsegurado,
		aseg.TipoPersona,
		aseg.NombreEstado,
		aseg.NombreCiudad,
		aseg.NivelRiesgoCliente,
		aseg.DescOcupacionOGiro,
		CASE WHEN primas.FechaFinVigencia BETWEEN '2019-01-01' AND '2019-12-31'  THEN 2019
			WHEN primas.FechaFinVigencia BETWEEN '2020-01-01' AND '2020-12-31'  THEN 2020
			WHEN primas.FechaFinVigencia BETWEEN '2021-01-01' AND '2021-12-31'  THEN 2021
			WHEN primas.FechaFinVigencia BETWEEN '2022-01-01' AND '2022-12-31'  THEN 2022
			WHEN primas.FechaFinVigencia BETWEEN '2023-01-01' AND '2023-12-31' THEN 2023
			WHEN primas.FechaFinVigencia BETWEEN '2024-01-01' AND '2024-12-31' THEN 2024
			WHEN primas.FechaFinVigencia BETWEEN '2025-01-01' AND '2025-12-31' THEN 2025
			END AS Anio,

		
	   sum(primas.PrimaNetaPropiaSinCoaseguro) AS Emitida,
	   sum(primas.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
	   --	sum(tec.UnidadesEmitidasReales) AS Unidades,
	   sum(primas.Ocurrido) AS Ocurrido
	   --	sum(tec.RiesgoVigente) AS RV
		
FROM (

	SELECT emi.CveAsegurado,
			tec.Ocurrido,
			tec.PrimaNetaPropiaEmitidaDevengada,
            tec.PrimaNetaPropiaSinCoaseguro,
            emi.FechaFinVigencia
			--tec.Periodo
	
	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
	ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
	AND tec.NumDocumento=emi.NumDocumento
	--AND tec.Periodo >=201901
	
	WHERE emi.IdTipoPoliza!=4013
	AND emi.FechaFinVigencia>='2019-01-01'

) AS primas
			
INNER JOIN (		


	SELECT  DISTINCT emi.CveAsegurado
	
	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	
	INNER JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=emi.IdOficina
	AND ofi.IdDireccionComercial IN (26862,31690,26861)
	
	WHERE 	emi.FechaFinVigencia BETWEEN '20231001' AND '20241231'
	AND emi.IdTipoPoliza!=4013

) AS cve

ON cve.CveAsegurado=primas.CveAsegurado


LEFT JOIN tb_bi_dimasegurado AS aseg
ON aseg.CveAsegurado=primas.CveAsegurado



GROUP BY aseg.NombreAsegurado,
		aseg.NipAgrupador,
		aseg.TipoPersona,
		aseg.NombreEstado,
		aseg.NombreCiudad,
		aseg.NivelRiesgoCliente,
		aseg.DescOcupacionOGiro,
		   CASE WHEN primas.FechaFinVigencia BETWEEN '2019-01-01' AND '2019-12-31'  THEN 2019
			WHEN primas.FechaFinVigencia BETWEEN '2020-01-01' AND '2020-12-31'  THEN 2020
			WHEN primas.FechaFinVigencia BETWEEN '2021-01-01' AND '2021-12-31'  THEN 2021
			WHEN primas.FechaFinVigencia BETWEEN '2022-01-01' AND '2022-12-31'  THEN 2022
			WHEN primas.FechaFinVigencia BETWEEN '2023-01-01' AND '2023-12-31' THEN 2023
			WHEN primas.FechaFinVigencia BETWEEN '2024-01-01' AND '2024-12-31' THEN 2024
			WHEN primas.FechaFinVigencia BETWEEN '2025-01-01' AND '2025-12-31' THEN 2025
			END