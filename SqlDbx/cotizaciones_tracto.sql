SELECT     FechaCotizacion			=  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) 
		, ctz.TiempoCotizacion
		, FechaEmision			= case when plz2.FechaEmision > ctz.TiempoCotizacion then cast ( convert ( char ( 8 ), plz2.FechaEmision, 112 ) as int )  else  cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ) end 
	    , NumCompletoCotizacion = ctz.NumCompletoCotizacion
	    , IdOficina				= ctz.IdOficinaEmision
	    , PLZ					=  case when plz2.NumPoliza > 0 then 1 else 0 end 
	    , NumPoliza				= isnull(plz2.NumPoliza, 0)
	    , PolizaAnterior		= cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)
	    , NipPerfilAgente		= isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)
	    , TipoPoliza			= tpol.DescTipoPoliza
	    , tcon.DescTipoConservacion
	    , tv.DescTipoVehiculo

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
	
	
	inner JOIN TB_BI_DimTipoPoliza AS tpol
	ON tpol.IdTipoPoliza=isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza)
	AND tpol.IdTipoPoliza=4013
	
	LEFT JOIN TB_Bi_DimTipoConservacion AS tcon
	ON tcon.IdTipoConservacion=isnull(plz2.IdTipoConservacion,0)
	
		
	LEFT JOIN VW_BI_DimVehiculo AS vehi
	ON vehi.IdVehiculoInterno=isnull(plz.IdVehiculo,plz2.IdVehiculo)
	
	left JOIN TB_BI_DimTipoVehiculo AS tv
	ON tv.IdTipoVehiculo=vehi.IdTipoVehiculo
	
	
	
	WHERE ctz.IdLineaNegocio = 4
	and ctz.TiempoCotizacion >= '20230101'
	--and ctz.Eliminado = 0
	and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013
	and isnull(ctz.NumDocumento,0) = 0
	AND vehi.IdTipoVehiculo IN (22809)
	and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0
	and isnull(plz2.IdTipoConservacion,0) = 0