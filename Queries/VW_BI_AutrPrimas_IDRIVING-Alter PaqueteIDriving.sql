SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view [Ventas].[VW_BI_AutrPrimas_IDRIVING]
as

SELECT
	FechaTransaccion = pmas.Periodo*100+1
	, e.NumCompletoCotizacion
	, e.IdOficina
	, e.NumPoliza
	, e.NumCertificado
	, FechaEmisionCis = e.FechaEmisionCis
	, e.FechaFinVigencia
	, e.FechaInicioVigencia
	, PrimaNetaPropiaTotal = sum(pmas.PrimaNetaPropiaSinCoaseguro)
	, PrimaTotal = sum(pmas.PrimaNeta)
	, PrimaPagada = SUM(PrimaNetaPropiaPagada)
	, PrimaDevengada = SUM(PrimaNetaPropiaEmitidaDevengada)
	, Ocurrido = SUM(Ocurrido)
	, Unidades = SUM(UnidadesEmitidasReales)
	, Expuesto = SUM(UnidadesExpuestasMes)
	, Siniestros = SUM(NumSiniestro)
	, e.NipPerfilAgente
	
	, rbos.EstatusRecibo
	, FechaUltimoRecibo = rbos.MaximoDocumento
	, FechaEmision = e.FechaEmision
	, d.DescTipoMovimiento
	, d.DescTipoDocumento
	, d.DescGrupoDocumento
	, Conservada=
		CASE
		 WHEN e.IdTipoConservacion <= 0 THEN 'Nueva' ELSE 'Conservada'
		END	
	
	, ee.IdCliente
	, ee.TiempoCarga
	, LlaveCTM= ee.CustomerKey
	, Vinculado=
		CASE
			WHEN isnull(ee.TagUsuario,0) = 0 THEN 0 ELSE 1
			
		end
	, CKCalculado = RIGHT('00000' + ltrim(rtrim(e.IdOficina)),5) + '-'+ RIGHT('0000000000' + ltrim(rtrim(e.IdOficina)),10) + '-' + CAST(e.NumCertificado AS VARCHAR)
	, t4.NombreAsegurado
			
	, IdVehiculo
	, coalesce(causa.DescCausaCancelacion, 'POR OTRAS CAUSAS') AS Causa_Canc
	
	
	FROM TB_BI_AutrFactEmisionDoc e
		
	   	LEFT JOIN TB_BI_DimTipoDocumento d
	   	ON d.IdTipoDocumento  = e.IdTipoDocumento
		
		--LEFT JOIN TB_BI_DimCausaCancelacion canc
		--ON canc.IdCausaCancelacion = e.IdCausaCancelacion
		
		
	   	LEFT JOIN -- este JOIN ES PARA SABER SI LA POLIZA ESTA PAGADA O NO
		(
		  SELECT rec.NumCompletoCotizacion,
				rec.NumDocumento,
				esta.DescEstatus AS EstatusRecibo,
				
				MaximoDocumento=max(rechis.FechaMovimiento)
		
		
		
		FROM DWH.Tb_BI_GrlFacRecibosMae AS rec

		
		LEFT JOIN DWH.Tb_BI_GrlFacRecibosHistorico AS rechis
		ON rechis.IdRecibo=rec.IdRecibo
		
		INNER JOIN tb_bi_dimreciboestatus AS esta
		ON esta.IdEstatus=rechis.IdEstatus
		AND esta.DescEstatus='PAGADO'

		
		GROUP BY rec.NumCompletoCotizacion,
				rec.NumDocumento,
				esta.DescEstatus
			
		) AS rbos	
		
		ON rbos.NumCompletoCotizacion = e.NumCompletoCotizacion
		and rbos.NumDocumento = e.NumDocumento
		
		
		INNER JOIN TB_BI_AutrBase2Tecnica pmas 

		ON pmas.NumCompletoCotizacion = e.NumCompletoCotizacion
		AND pmas.NumDocumento = e.NumDocumento 
		--AND pmas.FechaTransaccion = e.FechaTransaccion 


		--LEFT JOIN TB_BI_DimCausaCancelacion cancel
		--ON cancel.IdCausaCancelacion = e.IdCausaCancelacion
		
		
		/* JOIN PARA IDENTIFICAR LAS PÓLIZAS EMITIDAS TOTALES Y VALIDAR SI EL TAG ESTÁ VINCULADO */
	   LEFT JOIN 
	   	(
	   		SELECT
	   		Minimo= min(tags.IdClienteUsuario)
	   		, tags.CustomerKey
	   		, tags.IdCliente
			, tags.TagUsuario
			, tags.TiempoCarga
	   		FROM DWH.Tb_Bi_AutrIDrivingUsuarioCliente tags 
	   		WHERE tags.EsCuentaPrincipal = 1
	   		GROUP BY
	   			 tags.IdCliente
	   			 , tags.CustomerKey
				 , tags.TagUsuario
				 , tags.TiempoCarga
	   	
	   	) AS ee
	   	
	  	ON substring(ee.CustomerKey,1,18) = RIGHT('00000' + ltrim(rtrim(e.IdOficina)),5) + '-'+ RIGHT('0000000000' + ltrim(rtrim(e.NumPoliza)),10) + '-' + CAST(e.NumCertificado AS VARCHAR)
	/* Estadística */
	  Left Join TB_BI_DimAsegurado t4
	 	on t4.CveAsegurado = e.CveAsegurado 
	 	
	LEFT JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=e.IdOficina
	
	LEFT JOIN TB_BI_DimCausaCancelacion AS causa
	ON causa.IdCausaCancelacion=e.idcausaCancelacion

		
WHERE pmas.Periodo >= 202104     
--AND ofi.IdDireccionComercial in (31690,26861,26862)
--and e.IdClasificacionProducto = 15 and e.IdSubclasificacionProducto = 2   -- HDI iDriving
AND e.IdPaquete in (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610, 4034, 4035)  -- PRODUCTOS IDRIVING


GROUP BY 
	pmas.Periodo*100+1
	--e.FechaTransaccion
	, e.FechaEmision
	, e.FechaInicioVigencia
	, e.FechaFinVigencia
	, e.NumCompletoCotizacion
	, e.IdOficina
	, e.NumPoliza
	, e.NumCertificado
	, rbos.EstatusRecibo
	, e.FechaEmisionCis
	, d.DescTipoMovimiento
	, d.DescTipoDocumento
	, d.DescGrupoDocumento
	, 	CASE
		 WHEN e.IdTipoConservacion <= 0 THEN 'Nueva' ELSE 'Conservada'
		END	
	
	, ee.IdCliente
	, t4.NombreAsegurado
	, ee.CustomerKey
	, ee.TiempoCarga
	, rbos.MaximoDocumento
	, e.NipPerfilAgente
	, TagUsuario

	, IdVehiculo
	, coalesce(causa.DescCausaCancelacion, 'POR OTRAS CAUSAS') 
GO
