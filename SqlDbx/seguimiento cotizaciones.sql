SELECT year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Anio,
		month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) as Mes,
	--LEFT(vc.FechaCotizacion,6) AS Periodo,
	--datepart(wk,vc.TiempoCotizacion) AS Semana,
	--ofi.DescDireccionComercial AS Direccion,
	--ofi.DescSubdireccionComercial AS Subdireccion,
  	--ofi.NombreOficinaComercial AS Oficina,
  	--ofi.IdOficina,
  	--vc.NipPerfilAgente,
  	--age.NombreAgente,
	
	--count(DISTINCT(age.nombreagente)) AS Agentes,
	count(DISTINCT(vc.NumCompletoCotizacion)) AS Cotizaciones,
    sum(vc.PLZ) AS Polizas

FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS vc

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vc.nipperfilagente

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=vc.IdOficina


WHERE vc.FechaCotizacion>= '20240301'  AND vc.FechaCotizacion<='20240331'
--AND vc.IdTarifa=1
--AND vc.IdPaquete IN (19,21,23,24,326,327,328,329,1300,1301,2458,2459,3211) 
AND vc.IdPaquete NOT IN (57, 58, 430, 431,432,447,448,449) 
--AND age.IdTipoAgente=19
AND age.NombreAgente not  IN ('TRIGARANTE AGENTE DE SEGUROS Y DE FIANZAS SA DE CV','ASESORES DE RIESGO POR CANALES ALTERNOS AGENTE DE SEGUROS  SA DE CV')
AND ofi.IdOficina NOT IN (1,806,881,563)
AND vc.NumCompletoCotizacion NOT IN (40380000877243, 40380000876981, 40380000876982, 41760001230996, 41760001216843, 47360000005617,47360000005615, 40100001267513,41760001216844, 1760001121277, 41760001212948, 41760001127305, 40050001508447, 41390001279693,48260000003276, 40570001318953, 41950000980727, 41950000980494, 41950000976784, 41790000030565,41950000976322)


GROUP BY year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)),
		month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111))
	--LEFT(vc.FechaCotizacion,6),
	--datepart(wk,vc.TiempoCotizacion)
  	--ofi.DescDireccionComercial,
  	--ofi.DescSubdireccionComercial,
  	--ofi.NombreOficinaComercial,
  	--ofi.IdOficina,
   	--vc.NipPerfilAgente,
  	--age.NombreAgente
	
ORDER BY anio, mes