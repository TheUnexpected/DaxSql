SELECT 	*

FROM(
	
	SELECT emi.NipAgente,
	
	
			round(sum(emicob.PrimaNeta),0) AS Prima_Neta_autos
	
	
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	WHERE emicob.FechaTransaccion BETWEEN 20230901 AND 20240831 --aquí mueven el día
	AND emi.NipAgente IN (106087,91858,110018,56109,68595,56109,108657,106055,108692,91212,111722,56406,91858,55271,99545,102036)
	
	GROUP BY emi.NipAgente
	
	) AS autos
	
FULL JOIN 

( SELECT emi.NipAgente,
		
		round(sum(emicob.PrimaNeta*tc.TipoCambio),0) AS Prima_Neta_Daños


FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
ON mon.IdMoneda=emi.IdMoneda

LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=emi.IdMoneda
AND tc.Periodo = left(emi.FechaTransaccion,6)


WHERE emicob.FechaTransaccion BETWEEN 20230901 AND 20240831 --aquí mueven el día
AND emi.NipAgente IN (106087,91858,110018,56109,68595,56109,108657,106055,108692,91212,111722,56406,91858,55271,99545,102036)


GROUP BY emi.NipAgente
) AS danos

ON danos.NipAgente=autos.Nipagente


FULL JOIN (

	SELECT gmm.NAgente, sum(gmm.Prima_Total) AS Prima_GMM
	
	FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm
	
	WHERE Periodo BETWEEN 202309 AND 202408
	AND gmm.NAgente IN (106087,91858,110018,56109,68595,56109,108657,106055,108692,91212,111722,56406,91858,55271,99545,102036)

	
	GROUP BY gmm.NAgente
	
	) AS gmm

ON gmm.NAgente=autos.NipAgente


			
				