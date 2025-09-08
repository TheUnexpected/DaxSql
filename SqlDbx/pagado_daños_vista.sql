SELECT 	'Daños' AS Ramo,
	LEFT (cobr.FechaPago,6) AS Periodo,
	--cobr.NumCompletoCotizacion,
	cobr.IdOficina,
   	isnull(emi.NipPerfilAgente,emi2.NipPerfilAgente) AS NipPerfilAgente,
   	--concat(cobr.IdOficina,'-',cobr.NumCotizacion,'-',cobr.NumCertificado,'-',cobr.NumPoliza),
   	--cobr.NumDocumento,
   	--concat(emi2.IdOficina,'-',emi2.NumCotizacionMaestra,'-',emi2.NumCertificado,'-',emi2.NumPoliza),
   	--emi2.NumDocumento,
   	prod.ClasificacionProducto,
	prod.SubclasificacionProducto,
	paq.DescPaquete,
	
   sum(cobr.PrimaNeta*tc.TipoCambio) AS PagadaMX,
   sum(cobr.PrimaNeta) AS PagadaMON
  
FROM dbo.TB_BI_DanFactCobrado AS cobr 
	
left JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi
ON cobr.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND cobr.NumDocumento=emi.NumDocumento

left JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi2
ON concat(cobr.IdOficina,'-',cobr.NumCotizacion,'-',cobr.NumCertificado,'-',cobr.NumPoliza)=concat(emi2.IdOficina,'-',emi2.NumCotizacionMaestra,'-',emi2.NumCertificado,'-',emi2.NumPoliza)
AND cobr.NumDocumento=emi2.NumDocumento

INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=cobr.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1


LEFT JOIN dbo.VW_BI_DimTipoCambio AS tc
ON tc.IdMoneda=cobr.IdMoneda
AND tc.Periodo = left(cobr.FechaPago,6)


LEFT JOIN  VW_Bi_DimCLasificacionProductos  AS prod
ON  prod.IdClasificacionProducto=isnull(emi.IdClasificacionProducto,emi2.IdClasificacionProducto)
AND prod.IdSubclasificacionProducto=isnull(emi.IdSubclasificacionProducto,emi2.IdSubclasificacionProducto)

LEFT JOIN TB_BI_DimPaquete AS paq
ON paq.IdPaquete=isnull(emi.IdPaquete,emi2.IdPaquete)

WHERE cobr.FechaPago between 20230101 AND 20231231
	
GROUP BY 	 
	LEFT (cobr.FechaPago,6),
	cobr.IdOficina,
   	isnull(emi.NipPerfilAgente,emi2.NipPerfilAgente),
   	prod.ClasificacionProducto,
	prod.SubclasificacionProducto,
	paq.DescPaquete
	--cobr.NumCompletoCotizacion,
	--concat(cobr.IdOficina,'-',cobr.NumCotizacion,'-',cobr.NumCertificado,'-',cobr.NumPoliza), 	
	--cobr.NumDocumento,
   	--concat(emi2.IdOficina,'-',emi2.NumCotizacionMaestra,'-',emi2.NumCertificado,'-',emi2.NumPoliza),
   	--emi2.NumDocumento