SELECT aux.Periodo
	, aux.NipPerfilAgente
	, aux.IdOficina
	
	
	, aux.PrimaPagada
	, aux.PrimaEmitida
	, aux.UnidadesEmitidas
	, aux.PrimaDevengada
	, aux.UnidadesExpuestas
	, aux.Ocurrido
	, aux.Siniestro 
	, aux.RiesgoVigente
	
	

	, t3.DescGrupoConservacion
	, t4.DescTipoVehiculo
	, t5.DescGrupoTipoPoliza
    , t8.CanalVenta


FROM ( SELECT t1.Periodo
	, t2.NipPerfilAgente
	, t2.IdOficina
	, t2.IdTipoConservacion
	, t2.IdtipoVehiculo
	, t2.IdTipoPoliza
	
	, PrimaPagada = SUM(t1.PrimaNetaPropiaPagada)
	, PrimaEmitida = SUM(t1.PrimaNetaPropiaSinCoaseguro)
	, UnidadesEmitidas = SUM(t1.UnidadesEmitidasReales)
	, PrimaDevengada = SUM(t1.PrimaNetaPropiaEmitidaDevengada)
	, UnidadesExpuestas = SUM(t1.UnidadesExpuestasMes)
	, Ocurrido = SUM(t1.Ocurrido)
	, Siniestro = SUM(t1.NumSiniestro)
	, RiesgoVigente = SUM(t1.RiesgoVigente)


	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc  AS t2 with(nolock)
	
	INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS t1 with(nolock)
	ON t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
	AND t2.NumDocumento = t1.NumDocumento
	
	WHERE t1.Periodo>=202004
	
	GROUP BY t1.Periodo
	, t2.NipPerfilAgente
	, t2.IdOficina
	, t2.IdTipoConservacion
	, t2.IdtipoVehiculo
	, t2.IdTipoPoliza
	) AS aux
	

	
	left JOIN HDI_DWH.dbo.tb_bi_dimtipoconservacion  t3 with(nolock)
	ON t3.IdTipoConservacion= aux.IdTipoConservacion
	
	left JOIN HDI_DWH.dbo.TB_BI_DimTipoVehiculo  t4 with(nolock)
	ON t4.IdTipoVehiculo= aux.IdTipoVehiculo
	
	left JOIN HDI_DWH.dbo.TB_BI_DimTipoPoliza t5 with(nolock)
	ON t5.IdTipoPoliza= aux.IdTipoPoliza
	
	--LEFT JOIN HDI_DWH.dbo.TB_BI_DimAgente AS t6
	--ON t6.NipPerfilAgente=t2.NipPerfilAgente
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=aux.IdOficina
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DimProgramasAgentes AS t8
	ON t8.NipPerfilAgente=aux.NipPerfilAgente 
	
WHERE  ofi.IdDireccionComercial IN (31690, 26861, 26862)
	AND ofi.NombreOficinaComercial NOT IN ('Bancaseguros Bajío', 'Virtuales Expansión')

