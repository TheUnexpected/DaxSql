SELECT 	'Daños' AS Ramo,
	LEFT(cobr.Periodo,4) AS Anio,
	cobr.Periodo,
	--cobr.IdOficina,
	--ofi.NombreOficinaComercial,
   	--cobr.NipPerfilAgente,
   	--prod.ClasificacionProducto,
	--prod.SubclasificacionProducto,


   round(sum(cobr.PrimaNPPagadaConsolidada),0) AS Pagada
  
FROM dbo.VW_BI_DanFactCobrado AS cobr

LEFT JOIN  VW_Bi_DimCLasificacionProductos  AS prod
ON  prod.IdClasificacionProducto=cobr.IdClasificacionProducto
AND prod.IdSubclasificacionProducto=cobr.IdSubclasificacionProducto

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=cobr.IdOficina


WHERE cobr.Periodo BETWEEN 202301 AND 202412
	
GROUP BY LEFT(cobr.Periodo,4),
	cobr.Periodo
	--cobr.IdOficina,	
	--ofi.NombreOficinaComercial
   	--cobr.NipPerfilAgente,
   	--prod.ClasificacionProducto,
	--prod.SubclasificacionProducto