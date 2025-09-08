SELECT 
		LEFT (cast(emicob.FechaTransaccion AS INT),4) AS Anio,
		
		'Daños'AS Ramo,
		ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial AS Oficina_Comercial,
		ofi.NombreOficina,
		emi.NipPerfilAgente,
		prod.ClasificacionProducto,
		
		sum(emicob.PrimaNeta) AS Prima_Neta



FROM TB_BI_DanFactEmisionCob AS emicob


INNER JOIN TB_BI_DimCobertura AS cob
ON cob.IdCobertura=emicob.IdCobertura
AND cob.DescTipoCobertura='Cobertura Propia'
AND cob.IdLineaNegocio=1

LEFT JOIN HDI_DWH.dbo.TB_BI_DanFactEmisionDoc AS emi
ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
AND emi.NumDocumento=emicob.NumDocumento

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.Idoficina=emi.idOficina

INNER JOIN VW_Bi_DimCLasificacionProductos AS prod
ON prod.IdClasificacionProducto=emi.IdClasificacionProducto
AND prod.IdSubclasificacionProducto=emi.IdSubclasificacionProducto
AND prod.IdLineaNegocio=1


WHERE emicob.FechaTransaccion BETWEEN 20060101 AND 20131231

GROUP BY 
			LEFT (cast(emicob.FechaTransaccion AS INT),4),
		
		ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		emi.NipPerfilAgente,
		prod.ClasificacionProducto