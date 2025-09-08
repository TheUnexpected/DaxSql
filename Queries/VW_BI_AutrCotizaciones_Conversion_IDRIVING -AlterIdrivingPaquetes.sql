SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view [Ventas].[VW_BI_AutrCotizaciones_Conversion_IDRIVING]
as
/****************************************************************  
Servidor: DWH.HDI.COM.MX  
Base de datos: HDI_DWH  
Proceso de Negocio: Inteligencia de Ventas/Comercial	 
Proceso consume: Emision, Cotizacion
  
  
NOMBRE : VW_Cotizaciones_Conversion_IDRIVING
LineaNegocio: Autos
FUNCION : Dashboard IDRIVING 
CREADO : 20220923 
AUTOR : Ernesto Barrientos Rodríguez  
  
 Modificaciones >            
   Núm.   Fecha           ID Autor       Descripción             
   ----   -------------   ------------  --------------------------------------------------------------------------------------------------------             
  >  1    23 Sep 2022     EBarrientos   Creación.     
****************************************************************/  

SELECT 
    FechaCotizacion			=  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) 
	, ctz.TiempoCotizacion
	, FechaEmision			= case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end                  
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion
    , IdOficina				= ctz.IdOficinaEmision
    , PLZ					=  case when plz2.NumPoliza > 0 then 1 else 0 end 
    , NumPoliza				= isnull(plz2.NumPoliza, 0)
    , PolizaAnterior		= cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)
    , NipPerfilAgente		= isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)
    , IdPaquete				= isnull(plz.IdPaquete, plz2.IdPaquete)
    , IdTipoPoliza			= isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza)
    , IdCanalVenta			= isnull(plz.IdCanalVenta , plz2.IdCanalVenta)
    , DTFechaCotizacion		= ctz.TiempoCotizacion
	, DTFechaEmision		= plz2.FechaEmision
    , PrimaTarifa			= isnull(plz2.PrimaTarifa , plz.PrimaTarifa)
    , Descuento				= isnull( plz2.AjusteEspecial , plz.AjusteEspecial)
	, CesionComision		= isnull( plz.CesionComision , plz2.CesionComision)
	, DerechoPoliza			= isnull( plz.DerechoPoliza , plz2.DerechoPoliza)
	, RecargoPagoFraccionado = isnull( plz.RecargoPagoFraccionado , plz2.RecargoPagoFraccionado)
    , FechaInicioVigencia   = isnull(plz.FechaInicioVigencia , plz2.FechaInicioVigencia)
    , FechaFinVigencia		= isnull(plz.FechaFinVigencia , plz2.FechaFinVigencia)
  from
	DWH.Tb_bi_AutrEmiCotiz ctz
	left join
		DWH.Tb_bi_GrlEmiCotizado plz
	on
		plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and plz.NumDocumento = ctz.NumDocumento	
	left join
		TB_BI_AutrFactEmisionDoc plz2
	on
		plz2.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and plz2.NumDocumento = ctz.NumDocumento
	left join
		DWH.Tb_bi_GrlEmiAgenteCotizacion axc  
	on
		axc.IdLineaNegocio = 4
		and ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion
		and ctz.NumDocumento = axc.NumDocumento

	left join
		DWH.TB_BI_GrlFactOTSolicitud sol
	on
		sol.IdLineaNegocio = ctz.IdLineaNegocio
		and sol.NumCompletoCotizacion = ctz.NumCompletoCotizacion
		and sol.NumDocumento = ctz.NumDocumento
		and sol.IdEstatus = 3859 			
	inner join 
		TB_BI_DimPaquete t3
	on 
		t3.IdPaquete = isnull(plz.IdPaquete , plz2.IdPaquete) 
  where
    ctz.IdLineaNegocio = 4
    and ctz.TiempoCotizacion >= '20210401'
    and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013
    and isnull(ctz.NumDocumento,0) = 0
    and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0
    and t3.IdPaquete in (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610, 4034, 4035) -- Modificacion Moncada 13/02/2025 -Agregan paquetes restantes Idriving
    and isnull(plz2.IdTipoConservacion,0) = 0
GO
