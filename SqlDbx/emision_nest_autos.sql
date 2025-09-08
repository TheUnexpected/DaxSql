
SELECT 'Autos' AS Ramo,
		pmas.Periodo,
		agentes.Direccion,
		agentes.Subdireccion, 
		agentes.Oficina,
		agentes.IdOficina,	
		Generacion_Recluta=CASE WHEN agentes.FechaAlta>'2023-12-31' AND agentes.FechaAlta<'2025-01-01' THEN '2024'
								WHEN agentes.FechaAlta>'2022-12-31' AND agentes.FechaAlta<'2024-01-01' THEN '2023'
								WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
								WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
								else 'Otros casos' END,
		Tipo_vehiculo=CASE WHEN t4.IdTipoVehiculo IN (5676, 22809) THEN 'Vehiculo Pesado'
    						ELSE 'Otros' END ,
    	agentes.CanalVenta,

		sum(pmas.Prima_Emitida) AS Emitida
	   

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

    tipo.DescTipoAgente,

    t6.IdPerfilEjecutivo

	FROM HDI_DWH.dbo.TB_BI_DimAgente AS t6

	LEFT JOIN TB_BI_dimTipoAgente AS tipo

	ON tipo.idtipoAgente=t6.IdTipoAgente
 
	

	LEFT JOIN HDI_DWH.dbo.TB_BI_DimOficina AS t7

	ON t7.IdOficina=t6.IdOficina


	Left join TB_BI_DimProgramasAgentes t3

	on t3.NipPerfilAgente  = t6.NipPerfilAgente

) AS agentes
 
LEFT JOIN (	SELECT 	CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER) AS Periodo,
			emi.NipPerfilAgente,
			emi.IdTipoVehiculo,

		  	sum(emicob.PrimaNeta) AS Prima_Emitida
 
   FROM TB_BI_AutrFactEmisionCob AS emicob


	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento


	WHERE emicob.FechaTransaccion >=20240101

	GROUP BY CAST (LEFT(emicob.FechaTransaccion,6) AS INTEGER),
				emi.NipPerfilAgente,
				emi.IdTipoVehiculo

	) AS pmas

ON pmas.NipPerfilAgente=agentes.Perfil

left JOIN HDI_DWH.dbo.TB_BI_DimTipoVehiculo  t4 with(nolock)
ON t4.IdTipoVehiculo= pmas.IdTipoVehiculo

WHERE agentes.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta', 'HDI Spot')
OR agentes.FechaAlta>'2021-01-01'
AND pmas.periodo>=202401


GROUP BY pmas.Periodo,
		agentes.Direccion,
		agentes.Subdireccion, 
		agentes.Oficina,
		agentes.IdOficina,	
		CASE WHEN agentes.FechaAlta>'2023-12-31' AND agentes.FechaAlta<'2025-01-01' THEN '2024'
								WHEN agentes.FechaAlta>'2022-12-31' AND agentes.FechaAlta<'2024-01-01' THEN '2023'
								WHEN agentes.FechaAlta>'2021-12-31' AND agentes.FechaAlta<'2023-01-01' THEN '2022'
								WHEN agentes.FechaAlta>'2020-12-31' AND agentes.FechaAlta<'2022-01-01' THEN '2021'
								else 'Otros casos' END,
		CASE WHEN t4.IdTipoVehiculo IN (5676, 22809) THEN 'Vehiculo Pesado'
    						ELSE 'Otros' END,
    	agentes.CanalVenta