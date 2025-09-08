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
	  	
	  	sum(base.PrimaNetaPropiaSinCoaseguro) AS Emitida
	  		  	

FROM (

	SELECT emi.NipPerfilAgente, 
			emi.IdOficina, 
			emi.IdTipoPoliza, 
			emi.IdTipoVehiculo, 
			emi.IdUsoVehiculo,
			emi.CveAsegurado,
			emi.IdEstadoCliente,
			emi.IdPaquete,
			tec.PrimaNetaPropiaSinCoaseguro,
			tec.Periodo
	
	
	FROM  HDI_DWH.dbo.TB_BI_autrFactEmisionDoc AS emi
	
	inner JOIN TB_BI_autrBase2Tecnica AS tec
	ON tec.NumCompletoCotizacion = emi.NumCompletoCotizacion
	AND tec.NumDocumento = emi.NumDocumento 
	AND tec.Periodo BETWEEN 202201 AND 202311
	
	WHERE emi.IdOficina IN (SELECT idoficina
								
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
		
