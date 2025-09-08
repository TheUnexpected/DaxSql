SELECT CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
		cat.NombreEstado,
		ofi.NombreOficinaComercial,

		sum(emicob.PrimaNeta) AS Prima_Neta


FROM TB_BI_AutrFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=4

LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN 

		(SELECT DISTINCT IdEstado, NombreEstado
			FROM DMSin.Tb_BI_CatMunicipios 
		) AS cat
ON cat.IdEstado=emi.IdEstadoCliente


LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.idoficina=emi.IdOficina

WHERE emicob.FechaTransaccion BETWEEN 20230101 AND 20240430

GROUP BY CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER),
		cat.NombreEstado,
		ofi.NombreOficinaComercial
			
ORDER BY CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER)