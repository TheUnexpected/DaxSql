SELECT base.NipperfilAgente, 
		base.IdOficina,
	  	tv.DescTipoVehiculo,
	  	aseg.NombreAsegurado,
	  	pol.DescGrupoTipoPoliza,
	  	uso.DescUsoVehiculo,
	  	est.DescEstado,
	  	paq.DescPaquete,
	  	paq.DescGrupoPaquete,
	  	paq.DescTipoCoberturaPaquete,
	  	base.Periodo,
	  	
	  	sum(base.PrimaNeta) AS Emitida
	  		  	

FROM (

	SELECT emi.NipPerfilAgente, 
			emi.IdOficina, 
			emi.IdTipoPoliza, 
			emi.IdTipoVehiculo, 
			emi.IdUsoVehiculo,
			emi.CveAsegurado,
			emi.IdEstadoCliente,
			emi.IdPaquete,
			emicob.PrimaNeta,
			CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo
	
	
  FROM TB_BI_AutrFactEmisionCob AS emicob


	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento
	
	
	WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20231231
	AND  emi.IdOficina IN (SELECT idoficina
								
								FROM TB_BI_DimOficina AS ofi
								
								WHERE ofi.NombreOficinaComercial IN ('León Despachos','Chihuahua', 'Mazatlán', 'Pachuca', 'Tuxpan', 'Guasave', 'Reynosa', 'Campeche', 'Tijuana', 'Queretaro Promotorias')
	
							)
	--HAVING 	sum(tec.PrimaNetaPropiaSinCoaseguro)!=0
	
	) AS base

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente= base.NipPerfilAgente

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON base.CveAsegurado=aseg.CveAsegurado

LEFT JOIN tb_bi_dimtipopoliza AS pol
ON pol.IdTipoPoliza=base.idtipopoliza

LEFT JOIN tb_bi_dimusovehiculo AS uso
ON uso.IdUsoVehiculo=base.Idusovehiculo

LEFT JOIN VW_BI_DimEstados AS est
ON est.IdEstado=base.IdEstadocliente

LEFT JOIN TB_BI_DimTipoVehiculo AS tv
ON tv.IdTipoVehiculo=base.Idtipovehiculo

LEFT JOIN tb_bi_dimpaquete AS paq
ON paq.IdPaquete=base.idpaquete



GROUP BY base.NipperfilAgente, 
		base.IdOficina,
	  	tv.DescTipoVehiculo,
	  	aseg.NombreAsegurado,
	  	pol.DescGrupoTipoPoliza,
	  	uso.DescUsoVehiculo,
	  	est.DescEstado,
	  	paq.DescPaquete,
	  	paq.DescGrupoPaquete,
	  	paq.DescTipoCoberturaPaquete,
	  	base.periodo
		
