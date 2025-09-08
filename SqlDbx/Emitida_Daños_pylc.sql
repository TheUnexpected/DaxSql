	SELECT ofi.IdOficina,
			ofi.NombreOficina,
			pmas.NumPoliza,
			pmas.NumCertificado,
			--ramo.IdRamo,
			--ramo.IdSubRamo,
			--ramo.DescripcionRamo,
			prod.GrupoClasificacion,
			aseg.NombreAsegurado,
			age.NipPerfilAgente,
			age.NombreAgente,
			pmas.FechaEmision,
			pmas.FechaInicioVigencia,
			pmas.FechaFinVigencia,
			pmas.NumCotizacion,
			pmas.Numdocumento,
			pmas.NumEndoso,
			tdoc.DescTipoMovimiento AS TipoDocumento,
			tdoc.DescTipoDocumento ,
			paq.DescPaquete,
			fp.DescFrecuenciaPago,
			mon.DescMoneda,
			
			sum(pmas.PrimaNetaPropiaSinCoaseguro) AS Emitida_Pesos
			  
	
	FROM (
	
		SELECT emi.IdOficina,
				emi.NumPoliza,
				emi.NumCertificado,
				emi.FechaEmision,
				emi.IdPaquete,
				emi.FechaInicioVigencia,
				emi.FechaFinVigencia,
				emi.CveAsegurado,
				emi.NipPerfilAgente,
				emi.IdMoneda,
				tec.PrimaNetaPropiaSinCoaseguro,
				emi.NumCotizacion,
				emi.NumDocumento,
				emi.IdClasificacionProducto,
				emi.IdSubclasificacionProducto,
				emi.IdTipoDocumento,
				--emi.IdClasifContable,
				emi.NumEndoso,
				emi.IdFrecuenciaPago
				
	
		FROM HDI_DWH.dbo.TB_BI_danFactEmisionDoc AS emi
	
	
		INNER JOIN HDI_DWH.dbo.TB_BI_danBase2Tecnica AS tec
		ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
		AND tec.NumDocumento=emi.NumDocumento
		AND tec.Periodo BETWEEN 202301 AND 202308
		
	   
		
		WHERE emi.IdOficina IN (SELECT ofi2.IdOficina 
								FROM TB_BI_DimOficina AS ofi2 
								WHERE ofi2.NombreOficina LIKE '%PyLC%')
	
		) AS pmas
					
	
	LEFT JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=pmas.idoficina
	
	LEFT JOIN tb_bi_dimpaquete AS paq
	ON paq.IdPaquete=pmas.IdPaquete
	
	LEFT JOIN tb_bi_dimasegurado AS aseg
	ON aseg.CveAsegurado=pmas.CveAsegurado
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=pmas.NipPerfilAgente
	
	LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
	ON mon.IdMoneda=pmas.Idmoneda
	
	LEFT JOIN VW_Bi_DimCLasificacionProductos  AS prod
	ON prod.IdClasificacionProducto=pmas.IdClasificacionProducto
	AND prod.IdSubclasificacionProducto=pmas.IdSubclasificacionProducto
	
	LEFT JOIN TB_BI_DimTipoDocumento AS tdoc
	ON tdoc.IdTipoDocumento=pmas.IdTipoDocumento
	
	--LEFT JOIN (SELECT * FROM TB_BI_DimGrlRamos AS r WHERE r.LineaNegocio='DAN') AS ramo
	--ON ramo.IdClasifContable=pmas.IdClasifContable
	
	LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS fp
	ON fp.IdFrecuenciaPago=pmas.IdFrecuenciaPago
	
	GROUP BY ofi.IdOficina,
			ofi.NombreOficina,
			pmas.NumPoliza,
			pmas.NumCertificado,
			--ramo.IdRamo,
			--ramo.IdSubRamo,
			--ramo.DescripcionRamo,
			prod.GrupoClasificacion,
			aseg.NombreAsegurado,
			age.NipPerfilAgente,
			age.NombreAgente,
			pmas.FechaEmision,
			pmas.FechaInicioVigencia,
			pmas.FechaFinVigencia,
			pmas.NumCotizacion,
			pmas.Numdocumento,
			pmas.NumEndoso,
			tdoc.DescTipoMovimiento,
			tdoc.DescTipoDocumento ,
			paq.DescPaquete,
			fp.DescFrecuenciaPago,
			mon.DescMoneda