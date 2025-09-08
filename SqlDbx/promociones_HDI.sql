SELECT year(convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)) AS Anio,
		month(convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)) as Mes,
		datepart(wk,convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)) AS Semana, --para esta funcion la semana empieza en domingo y termina en sabado
                convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111) AS fecha,
		--emi.IdOficina,
	   con.DescGrupoConservacion,
		
		round(sum(emicob.PrimaNeta),0) AS Prima_Neta
		--round(sum(emicob.PrimaTotal),0) AS Prima_Total


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=emi.IdOficina

LEFT JOIN tb_bi_dimpaquete AS paq
ON paq.IdPaquete=emi.IdPaquete

LEFT JOIN TB_Bi_DimTipoConservacion AS con
ON con.IdTipoConservacion=emi.IdTipoConservacion


WHERE emicob.FechaTransaccion >= 20220101 --aquí mueven el día
AND emi.IdTipoPoliza=4013
--AND emi.IdTipoConservacion=0
AND emi.IdTipoVehiculo IN (4579, 3829)
AND ofi.IdDireccionComercial IN (31690, 26861, 26862)
AND emi.IdTarifa=1
AND paq.DescPaquete LIKE '%AMPLI%'


GROUP BY year(convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)), 
		month(convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)),
		datepart(wk,convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111)),
                convert(DATE,CAST(emicob.FechaTransaccion AS VARCHAR),111),
	   con.DescGrupoConservacion

		--emi.IdOficina,
		
		
ORDER BY round(sum(emicob.PrimaNeta),0) desc
			