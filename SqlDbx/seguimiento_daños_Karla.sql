SELECT prima.*,
		movi.DescTipoDocumento AS Ultimo_Movimiento

FROM (  

		SELECT emi.IdOficina,
				emi.NumPoliza,
				emi.NumPolizaAnterior,
				age.NipPerfilAgente,
				age.NombreAgente,
				aseg.NombreAsegurado,
				aseg.IdRFCBase AS RFC,
				paq.DescPaquete,
				
				round(sum(emicob.PrimaNeta*tc.TipoCambio),0) AS Prima_Pesos
		
		
		
		FROM TB_BI_DanFactEmisioSELECT *
FROM Dshd.VW_DWH_GmmMetaPagadoxEjecutivo
WHERE SSO=430008412

SELECT *
FROM Dshd.VW_DWH_AutrMetaPagadoxEjecutivo
WHERE SSO=430008412


SELECT *
FROM Dshd.VW_DWH_DanMetaPagadoxEjecutivo
WHERE SSO=430008412nCob AS emicob
		
		
		INNER JOIN TB_BI_DimCobertura AS cob
		ON cob.IdCobertura=emicob.IdCobertura
		AND cob.DescTipoCobertura='Cobertura Propia'
		AND cob.IdLineaNegocio=1
		
		LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
		ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
		AND emi.NumDocumento=emicob.NumDocumento
		
		LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
		ON tc.IdMoneda=emi.IdMoneda
		AND tc.Periodo = left(emi.FechaTransaccion,6)
		
		LEFT JOIN tb_bi_dimagente AS age
		ON age.NipPerfilAgente=emi.NipPerfilAgente
		
		LEFT JOIN tb_bi_dimasegurado AS aseg
		ON aseg.CveAsegurado=emi.CveAsegurado
		
		LEFT JOIN tb_bi_dimpaquete AS paq
		ON paq.IdPaquete=emi.IdPaquete
		
		
		
		WHERE emicob.FechaTransaccion BETWEEN 20241001 AND 20241031 --aquí va el mes de emisión de las pólizas
		AND emi.IdTipoDocumento=21
		
		GROUP BY emi.IdOficina,
				emi.NumPoliza,
				emi.NumPolizaAnterior,
				age.NipPerfilAgente,
				age.NombreAgente,
				aseg.NombreAsegurado,
				aseg.IdRFCBase,
				paq.DescPaquete

) AS Prima

LEFT JOIN (

		SELECT DISTINCT doc.IdOficina,
		doc.NumPoliza,
		tdoc.DescTipoDocumento
		
		
		from HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS doc
			
			
		inner JOIN (
			
			SELECT emi.IdOficina,
					emi.NumPoliza,
					max(emi.FechaEmision) AS fecha
					
			from HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
			
			
			WHERE emi.FechaTransaccion >=20241001 --periodo en el que quiero buscar los movimientos
			AND emi.NumCertificado=1
			
			
			GROUP BY emi.IdOficina,
					emi.NumPoliza
					
			) AS base
		
		ON doc.numpoliza=base.NumPoliza
		AND doc.idoficina=base.idoficina
		AND doc.fechaemision=base.fecha
		
		LEFT JOIN TB_BI_DimTipoDocumento AS tdoc
		ON tdoc.IdTipoDocumento=doc.idtipodocumento
		
		WHERE doc.FechaTransaccion >=20241001 --periodo en el que quiero buscar los movimientos
		AND doc.numcertificado=1
		
	) AS movi
	
ON movi.Numpoliza=Prima.NumPoliza
AND movi.IdOficina=Prima.IdOficina