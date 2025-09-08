SELECT *

FROM(

	SELECT emi.IdOficina,
			emi.NumPoliza,
			age.NombreAgente,
			aseg.NombreAsegurado,
			
			
		sum(emicob.PrimaNeta) AS Emitida


	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	LEFT JOIN tb_bi_dimasegurado AS aseg
	ON aseg.CveAsegurado=emi.CveAsegurado
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	WHERE emicob.FechaTransaccion BETWEEN 20240801 AND 20240831
	
	GROUP BY emi.IdOficina,
			emi.NumPoliza,
			age.NombreAgente,
			aseg.NombreAsegurado
) AS b2

LEFT JOIN (


	SELECT min(base.FechaEmision) AS FechaEmision,
		   min(	base.FechaInicioVigencia) AS FechaInicioVigencia,
		   min(base.FechaFinVigencia) AS FechaFinVigencia,
			base.IdOficina,
			base.NumPoliza
			
	
	FROM TB_BI_AutrFactEmisionDoc AS base
	
	WHERE base.FechaTransaccion >=20220701
	AND base.NumDocumento=0
	AND base.NumCertificado=1
	
	group BY base.IdOficina,
			base.NumPoliza
	
	) AS fechas

ON fechas.IdOficina=b2.Idoficina
AND fechas.NumPoliza=b2.NumPoliza
	
WHERE b2.emitida!=0