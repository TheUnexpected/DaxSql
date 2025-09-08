SELECT LEFT(emicob.FechaTransaccion,6) AS Periodo,
		ag.NombreOficina,
		concat(ag.NipPerfilAgente,' ',ag.NombreAgente) AS Agente,
		
		round(sum(emicob.PrimaNeta),0) AS Prima_Neta



FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

inner JOIN (SELECT age.NipPerfilAgente,
		age.NipAgente,
		age.NumPerfil,
		age.NombreAgente,
		age.IdOficina,
		ofi.NombreOficina

		FROM TB_BI_DimAgente AS age

		LEFT JOIN tb_bi_dimoficina AS ofi
		ON ofi.IdOficina=age.IdOficina
		
		WHERE age.NipAgente IN (
			
			SELECT desp.NipAgente
			
			FROM TB_BI_DimAgenteDespacho desp
			
			WHERE desp.IdDespacho IN (
			
				SELECT  despII.IdDespacho
				FROM TB_BI_DimDespacho AS despII
				WHERE despII.NombreDespacho LIKE '%PyLC%'
			
				)
		
		)

) AS ag

ON ag.NipPerfilAgente=emi.nipperfilagente


WHERE emicob.FechaTransaccion BETWEEN 20230101 AND 20240531

GROUP BY  LEFT(emicob.FechaTransaccion,6),
		ag.NombreOficina,
		concat(ag.NipPerfilAgente,' ',ag.NombreAgente)
	   

HAVING round(sum(emicob.PrimaNeta),0) != 0
