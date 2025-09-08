SELECT 
	agentes.Direccion,
  	agentes.Subdireccion, 
  	agentes.Oficina,
  	agentes.IdOficina,	
  	agentes.Clave,
  	agentes.Perfil,
	agentes.Nombre,
	agentes.Estatus,
	agentes.FechaAlta,
    agentes.DescTipoAgente,
	agentes.Canal_Comercial,
  	agentes.CanalVenta,
  	agentes.Promotoria,
  	agentes.Programa,
  	cotiz.FechaCotizacion,		
	cotiz.TiempoCotizacion,
	cotiz.FechaEmision,			
	cotiz.NumCompletoCotizacion, 
	cotiz.PLZ,				   
	cotiz.NumPoliza,				
	cotiz.PolizaAnterior,		
	cotiz.Paquete,			
	cotiz.TipoPoliza,			
	cotiz.DescTipoConservacion,
	cotiz.DescMarcaVehiculo,
	cotiz.DescCarroceriaVehiculo,
	cotiz.DescUsoVehiculo,
	
	
    Nueva_Recluta=	CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
	Generacion_Recluta=CASE
	  WHEN agentes.FechaAlta>'2022-12-31' AND agentes.FechaAlta<'2024-01-01' THEN '2023'
	 	WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
		WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
		else 'Otros casos'
		END
		

FROM (

	SELECT     FechaCotizacion			=  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) 
		, ctz.TiempoCotizacion
		, FechaEmision			= case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end 
	    , NumCompletoCotizacion = ctz.NumCompletoCotizacion
	    , IdOficina				= ctz.IdOficinaEmision
	    , PLZ					=  case when plz2.NumPoliza > 0 then 1 else 0 end 
	    , NumPoliza				= isnull(plz2.NumPoliza, 0)
	    , PolizaAnterior		= cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)
	    , NipPerfilAgente		= isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)
	    , Paquete 				= paq.DescPaquete
	    , TipoPoliza			= tpol.DescTipoPoliza
	    , tcon.DescTipoConservacion
	    , vehi.DescMarcaVehiculo
	    , vehi.DescCarroceriaVehiculo
	    , uso.DescUsoVehiculo
	    --, FechaInicioVigencia   = isnull(plz.FechaInicioVigencia , plz2.FechaInicioVigencia)
	    --, FechaFinVigencia		= isnull(plz.FechaFinVigencia , plz2.FechaFinVigencia)
	
	FROM DWH.Tb_bi_AutrEmiCotiz as ctz
		
	LEFT JOIN DWH.Tb_bi_GrlEmiCotizado AS plz
	ON plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion
	AND plz.NumDocumento = ctz.NumDocumento
	--and plz.Eliminado = 0 -- #1
		
	LEFT JOIN TB_BI_AutrFactEmisionDoc AS plz2
	ON plz2.NumCompletoCotizacion = ctz.NumCompletoCotizacion
	AND plz2.NumDocumento = ctz.NumDocumento
	--and isnull(plz2.IdTipoConservacion,0) = 0
	
	LEFT JOIN DWH.Tb_bi_GrlEmiAgenteCotizacion AS axc  
	ON  ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion
	AND ctz.NumDocumento = axc.NumDocumento
	AND axc.IdLineaNegocio = 4
	
	
	LEFT  join TB_BI_DimPaquete AS paq
	ON paq.IdPaquete = isnull(plz.IdPaquete, plz2.IdPaquete) 
	
	inner JOIN TB_BI_DimTipoPoliza AS tpol
	ON tpol.IdTipoPoliza=isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza)
	AND tpol.IdTipoPoliza=4013
	
	LEFT JOIN TB_Bi_DimTipoConservacion AS tcon
	ON tcon.IdTipoConservacion=isnull(plz2.IdTipoConservacion,0)
	
	LEFT JOIN VW_BI_DimVehiculo AS vehi
	ON vehi.IdVehiculoInterno=isnull(plz.IdVehiculo,plz2.IdVehiculo)
	
	LEFT JOIN TB_BI_DimUsoVehiculo AS uso
	ON uso.IdUsoVehiculo=isnull(plz.IdUsoVehiculo, plz2.IdUsoVehiculo)
	
	WHERE ctz.IdLineaNegocio = 4
	and ctz.TiempoCotizacion >= '20210101'
	--and ctz.Eliminado = 0
	--and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013
	and isnull(ctz.NumDocumento,0) = 0
	--and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0
	--and isnull(plz2.IdTipoConservacion,0) = 0
	) AS cotiz


INNER JOIN (
	SELECT 	
  	t7.DescDireccionComercial AS Direccion,
  	t7.DescSubdireccionComercial AS Subdireccion, 
  	t7.NombreOficinaComercial AS Oficina,
  	t7.IdOficina,	
  	t6.NipAgente AS Clave,
  	t6.NipPerfilAgente AS Perfil,
	t6.NombreAgente AS Nombre,
	t6.DescEstatusPerfil AS Estatus,
  	t6.DescCanalComercial AS Canal_Comercial,
  	t6.FechaAlta,
	t6.NuevaRecluta,
	IdPromo= (SELECT min(t0.IdDespacho) 
				From TB_BI_DimAgenteDespacho t0 
				LEFT JOIN TB_BI_DimDespacho t4 
				ON t4.IdDespacho= t0.IdDespacho 
				Where t4.IdEstatusDespacho=216
				AND t0.NipAgente = t6.NipAgente),
	Programa=t3.Prorgama,
	t3.CanalVenta,
	t3.Promotoria,
    tipo.DescTipoAgente
	
	FROM HDI_DWH.dbo.TB_BI_DimAgente AS t6
	
	LEFT JOIN TB_BI_dimTipoAgente AS tipo
	ON tipo.idtipoAgente=t6.IdTipoAgente

	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DimOficina AS t7
	ON t7.IdOficina=t6.IdOficina
	
	
	Left join TB_BI_DimProgramasAgentes t3
	on t3.NipPerfilAgente  = t6.NipPerfilAgente
) AS agentes

ON agentes.Perfil=cotiz.NipPerfilAgente

WHERE agentes.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta')
OR agentes.FechaAlta>'2022-01-01'

