SELECT
	vista.Anio,
   	vista.Semana,
	--CASE WHEN vista.Estado='CIUDAD DE MÉXICO' THEN vista.Estado
	--	WHEN vista.municipio IN ('LEON', 'MONTERREY', 'GUADALAJARA','TIJUANA') THEN vista.municipio
	--	ELSE 'Resto Pais' END AS Ciudad,
	vista.DescCanalComercial,

    --sum(vista.PLZ) AS Polizas,
    count(vista.NumCompletoCotizacion) AS Cotizaciones
   -- round(sum(vista.PrimaTarifa),0) AS Tarifa,
   --isnull(round(sum(vista.Prima_Neta),0),0) AS Emitida
 
FROM (
 
	SELECT   
    LEFT(cast ( convert ( char ( 8 ), ctz.TiempoCotizacion, 112 ) as int ),4) AS Anio
    , datepart(wk,ctz.TiempoCotizacion) AS Semana
	, NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , ctz.IdOficina 
    , ctz.PLZ
    --, cp.Estado
    --, cp.Municipio
    , ctz.NipPerfilAgente
    , age.DescCanalComercial

	
	FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS ctz
	
	--LEFT JOIN (SELECT DISTINCT CodigoPostal, Estado, Municipio FROM TB_BI_DimCodigoPostal) AS cp
	--ON cp.CodigoPostal=ctz.CodigoPostalPoliza
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=ctz.nipperfilagente

	LEFT JOIN TB_BI_DimOficina AS ofi
	ON ofi.IdOficina=ctz.IdOficina
	
	WHERE ctz.FechaCotizacion>= '20240101'  AND ctz.FechaCotizacion<='20241231'
	--AND vc.IdTarifa=1
	--AND vc.IdPaquete IN (19,21,23,24,326,327,328,329,1300,1301,2458,2459,3211) 
	AND ctz.IdPaquete NOT IN (57, 58, 430, 431,432,447,448,449) 
	--AND age.IdTipoAgente=19
	AND age.NombreAgente NOT IN ('TRIGARANTE AGENTE DE SEGUROS Y DE FIANZAS SA DE CV','ASESORES DE RIESGO POR CANALES ALTERNOS AGENTE DE SEGUROS  SA DE CV')
	AND ofi.NombreOficinaComercial NOT IN ('Turistas')
	AND ctz.NumCompletoCotizacion NOT IN (40380000877243, 40380000876981, 40380000876982, 41760001230996, 41760001216843, 47360000005617,47360000005615, 40100001267513,41760001216844, 1760001121277, 41760001212948, 41760001127305, 40050001508447, 41390001279693,48260000003276, 40570001318953, 41950000980727, 41950000980494, 41950000976784, 41790000030565,41950000976322)


	 
)AS vista

 
WHERE vista.Anio>=2024

GROUP BY 	vista.Anio,
   			vista.Semana,
			--CASE WHEN vista.Estado='CIUDAD DE MÉXICO' THEN vista.Estado
			--	WHEN vista.municipio IN ('LEON', 'MONTERREY', 'GUADALAJARA','TIJUANA') THEN vista.municipio
			--	ELSE 'Resto Pais' END,
	vista.DescCanalComercial

ORDER BY vista.Anio,
		vista.Semana