
SELECT 
	gmm.FemiRbo AS Fecha,
	gmm.RamoSubramol,
	gmm.PolSocioComercial,
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
	
	
    Nueva_Recluta=	CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
	Generacion_Recluta=CASE
	 	WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
		WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
		END,
		
	sum(gmm.Pma1) AS Emitida

	   
FROM (

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

INNER JOIN TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm
ON agentes.perfil=gmm.NAgente
   	
	
WHERE agentes.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta')
OR agentes.FechaAlta>'2022-01-01'
	
	
GROUP BY gmm.FemiRbo,
	gmm.RamoSubramol,
	gmm.PolSocioComercial,
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
	
    CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
    CASE
	 	WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
		WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
		END


UNION

SELECT 
	gmm_c.Fecha AS Fecha,
	gmm_c.RamoSubramol,
	gmm_c.PolSocioComercial,
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
	
	
    Nueva_Recluta=	CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
	Generacion_Recluta=CASE
	 	WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
		WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
		END,
		
	-sum(gmm_c.Pma1) AS Emitida

	   
FROM (

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

INNER JOIN TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS gmm_c
ON agentes.perfil=gmm_c.NAgente
   	
	
WHERE agentes.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta')
OR agentes.FechaAlta>'2022-01-01'
	
	
GROUP BY gmm_c.Fecha,
	gmm_c.RamoSubramol,
	gmm_c.PolSocioComercial,
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
	
    CASE 
		WHEN agentes.NuevaRecluta=1 THEN 'SI'
		when agentes.NuevaRecluta=0 then 'NO'
		else 'Null'
	END,
	
    CASE
	 	WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
		WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
		END

