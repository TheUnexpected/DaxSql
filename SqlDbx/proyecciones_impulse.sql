SELECT cot.*, 
		FORMAT(TiempoAltaOt, 'yyyy-MM') AS Mes,
		CASE WHEN emisiones.ot_cotizacion IS NULL THEN 0
				ELSE 1 END AS PLZ
	   		 	
	   		 	
FROM (

  select  
    IdLineaNegocio = ot.IdLineaNegocio
    , IdOT = ot.IdOT
    , IdOficinaEmision = ot.IdOficinaEmision
    , Oficina = ofi.NombreOficina
    , TiempoAltaOt = ot.TiempoAltaOt
    , TipoDocumento = tdoc.DescTipoDocumentoOT
    , ComentarioOT = ot.ComentarioOT
    , RfcMasivo = cotm.RfcMasivo
    , Giro = cotm.Giro
    , Uso = cotm.Uso 
    , NumUnidades = cotm.NumUnidades
	, EstatusSuscripcion = eSus.DescEstatusSuscripcionManualOT
    , CausaSuscripcion = cotm.CausaSuscripcion            
    , EstatusCotizacion = cast(ot.ComentarioSuscripcion as int) -- cotm.Estatus_Cotizacion -- #002
    , CIA = cotm.CIA
    , PrimaOtraCia = cotm.PrimaOtraCia
    , PropuestasSalidaEnviada = cotm.PropuestasSalidaEnviadas
    , UnidadesCotizadas = cotm.UnidadesCotizadas
    , Autos = cotm.TotalAutos
    , PickUP = cotm.TotalPickUp
    , CamionesHasta = cotm.TotalCamionesHasta
    , CamionesMas = cotm.TotalCamionesMas
    , Tractocamiones = cotm.TotalTractocamiones
    , Remolques = cotm.TotalRemolques
    , Autobuses = cotm.TotalAutobuses
    , Motos = cotm.TotalMotos
    , PrimaNetaOtorgada = cotm.PrimaNetaOtorgada
    , PrimaNetaObjetivo = cotm.PrimaNetaObjetivo
    , PrimaNetaAnualizada = cotm.PrimaNetaAnualizada
    , PrimaTotal = cotm.PrimaTotal
    , NumeroMovimientos = cotm.NumMovimientos
    , NumeroRevire = cotm.Numero_Revire
    , FechaSolicitudRevire = cotm.Fecha_revire
    , PrimaNetaRevire = cotm.Prima_Neta_Revire
    , UsuarioRevire = cotm.Usuario_Revire
    , Poliza = cotm.NumPoliza
    , FechaEmitida = cotm.FechaEmitidaCIS
    , PrimaEmitida = cotm.PrimaEmitida
 	, NipPerfilAgente = ot.NipCliente
    , OficinaComercial = ofi.OficinaComercialCustomerView
    , SubdireccionComercial = ofi.DescSubdireccionComercial
    , Direccion = ofi.DescDireccionComercial      
  from
    DWH.TB_BI_GrlFactOTSolicitud ot with (nolock)  
      left join
        DWH.Tb_bi_GrlOTComplementoMasivo cotm with (nolock)  
      on  
        cotm.IdLineaNegocio = ot.IdLineaNegocio
        and cotm.IdOT = ot.IdOT
        and cotm.Eliminado = 0
      left join
        dbo.TB_BI_DimOficina ofi with (nolock) 
      on
        ofi.IdOficina = ot.IdOficinaEmision
      left join
        dbo.Tb_BI_DimTipoDocumentoOT tdoc with (nolock)  
      on
        tdoc.IdTipoDocumentoOT = ot.IdTipoDocumento
     
      left join
        dbo.Tb_BI_DimEstatusSuscripcionManualOT eSus with (nolock) 
      on
       eSus.IdEstatusSuscripcionManualOT = ot.IdEstatusSuscripcionManual --cotm.IdEstatusSuscripcion #002
  where
    ot.IdLineaNegocio = 6
    and ot.IdTipoSolicitud = 5112 -- Masivos a Suscripción
    and year(ot.TiempoAltaOt) >= 2022 -- #001
    and ot.Eliminado = 0

)
 AS cot
		
LEFT join 
			
(	SELECT DISTINCT OT_Cotizacion
				
				FROM (
				select
				    Periodo
				    , FechaTransaccion
				    , FechaEmision
				    , IdOficina
				    , NumPoliza
				    , NumCertificado
				    , OT_Emision
				    , NumCompletoCotizacion
				    , NumDocumento
				    , TipoDocumento
				    , GrupoDocumento
				    , PrimaNetaPropiaEmitida
				    , PrimaTotal
				    , IdCisMaestro
				    , VersionCisMaestro
				    , OT_Cotizacion
				    , NombreNegocio
				    , IdTipoConservacion
				    , UnidadesEmitidasReales
				    , PrimaNeta
				  from
				    Dshd.TB_DWH_AutrEmisionFlotillasImpacto e with(nolock)  
				  where 
				    Periodo >= 202201	
				)
				 AS Emi
					
				WHERE Emi.FechaEmision >= '2022-01-01'
					
) AS emisiones
				  
ON emisiones.OT_cotizacion=cot.IdOT	
	
WHERE cot.TipoDocumento IN (
			        'Recotización',
			        'Claveteo y Cotización',
			        'Claveteo y Cotización MODA'
			    )
			    -- Filtro por estatus de suscripción
AND cot.EstatusSuscripcion IN ('Terminado')
			   
AND CAST(cot.tiempoaltaot AS DATE) BETWEEN '2022/01/01' AND '2025/02/28'
AND cot.SubdireccionComercial IN (
	        'Occidente',
	        'Mexico Promotorias',
	        'Noroeste',
	        'Noreste',
	        'Bajio',
	        'Sur',
	        'Mexico Despachos'
	        )