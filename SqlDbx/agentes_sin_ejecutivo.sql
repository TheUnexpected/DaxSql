SELECT ofi.IdOficina,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		age.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		concat(age.NipPerfilAgente, ' ',age.NombreAgente) AS Perfil,
		age.DescEstatusAgente,
		age.FechaAlta,
		eje.IdEjecutivo,
		eje.NombreEjecutivo,
		
		sum(primas.Emitida) AS Emitida_Total

FROM TB_BI_DimAgente AS age

left JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo


inner JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)

LEFT JOIN 

	(	SELECT emi.NipPerfilAgente,
				emi.IdOficina, 
				tec.PrimaNetaPropiaSinCoaseguro AS Emitida
	
		FROM  HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi

		inner JOIN TB_BI_autrBase2Tecnica AS tec
		ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
		AND tec.NumDocumento = emi.NumDocumento 
		AND tec.Periodo =202301
		
	) AS primas


ON primas.NipPerfilAgente=age.NipPerfilAgente


WHERE age.DescEstatusAgente IN ('VIGOR','MIGRADO') 
AND age.IdPerfilEjecutivo=0
AND age.IdOficina NOT IN (1,2)
AND age.IdTipoAgente != 641

GROUP BY ofi.IdOficina,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		age.NipPerfilAgente,
		age.NipAgente,
		age.NombreAgente,
		concat(age.NipPerfilAgente, ' ',age.NombreAgente),
		age.DescEstatusAgente,
		age.FechaAlta,
		eje.IdEjecutivo,
		eje.NombreEjecutivo


HAVING sum(primas.Emitida) is NOT NULL
AND sum(primas.Emitida) !=0

ORDER BY ofi.IdOficina