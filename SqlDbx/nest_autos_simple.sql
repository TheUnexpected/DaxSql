 SELECT 'Autos' AS Ramo,
	pmas.Periodo,
  	agentes.IdOficina,	
  	agentes.Clave,
  	agentes.Perfil,
	agentes.Nombre,
	agentes.Estatus,
	agentes.FechaAlta,
    agentes.DescTipoAgente,
    agentes.IdPerfilEjecutivo,
	--t4.DescTipoVehiculo,
	poliz.DescGrupoTipoPoliza,
	--aseg.NombreAsegurado,
	--pmas.NumPoliza,
	
   Tipo_vehículoII=CASE 
  	WHEN t4.IdTipoVehiculo IN (5676, 22809) THEN 'Eq. Pesado'
  	ELSE 'Autos'
   	END ,
	
  	agentes.CanalVenta,

	
	
    Nueva_Recluta=	CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
	Generacion_Recluta=year(agentes.fechaalta),
		
	sum(pmas.Prima_Emitida) AS Prima_Emitida,
        sum(pmas.Prima_SinC) AS Prima_SinC,
        sum(pmas.Prima_Devengada) AS Prima_Devengada,
        sum(pmas.Ocurrido) AS Ocurrido,
        sum(pmas.Siniestros) AS Siniestros,
        sum(pmas.Unidades_Expuestas) AS Unidades_Expuestas,
        sum(pmas.Unidades_reales) AS Unidades_Reales


	   
FROM (

SELECT 	
  	
  	t7.IdOficina,	
  	t6.NipAgente AS Clave,
  	t6.NipPerfilAgente AS Perfil,
	t6.NombreAgente AS Nombre,
	t6.DescEstatusPerfil AS Estatus,
  	t6.FechaAlta,
	t6.NuevaRecluta,
	t3.CanalVenta,

    tipo.DescTipoAgente,
    t6.IdPerfilEjecutivo
	
	FROM HDI_DWH.dbo.TB_BI_DimAgente AS t6
	
	LEFT JOIN TB_BI_dimTipoAgente AS tipo
	ON tipo.idtipoAgente=t6.IdTipoAgente

	
	LEFT JOIN HDI_DWH.dbo.TB_BI_DimOficina AS t7
	ON t7.IdOficina=t6.IdOficina
	
	
	Left join TB_BI_DimProgramasAgentes t3
	on t3.NipPerfilAgente  = t6.NipPerfilAgente
	
	WHERE t3.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta', 'HDI Spot')
	
) AS agentes

LEFT JOIN (

	SELECT t1.Periodo,
			t2.IdTipoVehiculo,
			t2.IdTipoPoliza,
			t2.NipPerfilAgente,
			
			Prima_Emitida= SUM(t1.PrimaNetaPropiaEmitida),
	        Prima_SinC=SUM(t1.PrimaNetaPropiaSinCoaseguro),
	        Prima_Devengada=SUM(t1.PrimaNetaPropiaEmitidaDevengada),
	        Ocurrido=SUM(Ocurrido),
	        Siniestros=SUM(NumSiniestro),
	        Unidades_Expuestas = SUM(t1.UnidadesExpuestasMes),
	        Unidades_reales=sum(t1.UnidadesEmitidasReales)

	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc  AS t2 with(nolock)

	inner JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS t1 with(nolock) 
	ON t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
	AND t2.NumDocumento = t1.NumDocumento
	and   Periodo >=202301
	
	
	GROUP BY t1.Periodo,
			t2.IdTipoVehiculo,
			t2.IdTipoPoliza,
			t2.NipPerfilAgente
	  
	
	) AS pmas
	
ON pmas.NipPerfilAgente=agentes.Perfil
	
left JOIN HDI_DWH.dbo.TB_BI_DimTipoVehiculo  t4 with(nolock)
ON t4.IdTipoVehiculo= pmas.IdTipoVehiculo
	
left JOIN HDI_DWH.dbo.TB_BI_DimTipoPoliza poliz
ON poliz.IdTipoPoliza= pmas.IdTipoPoliza
	
	

--OR agentes.FechaAlta>'2022-01-01'
	
	
GROUP BY
	pmas.Periodo,
  	agentes.IdOficina,	
  	agentes.Clave,
  	agentes.Perfil,
	agentes.Nombre,
	agentes.Estatus,
	agentes.FechaAlta,
    agentes.DescTipoAgente,
    agentes.IdPerfilEjecutivo,
	poliz.DescGrupoTipoPoliza,

	
   CASE 
  	WHEN t4.IdTipoVehiculo IN (5676, 22809) THEN 'Eq. Pesado'
  	ELSE 'Autos'
   	END ,
	
  	agentes.CanalVenta,
	
	
    CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
	year(agentes.fechaalta)