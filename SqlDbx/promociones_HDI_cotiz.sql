SELECT year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Anio,
		month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) as Mes,
		datepart(wk,convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Semana, --para esta funcion la semana empieza en domingo y termina en sabado
        convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111) AS fecha,
        vc.nipperfilagente,
        CASE WHEN vc.Idtarifa=1 THEN 'Tradicional'
        ELSE 'Otro' END AS Tarifa,
        CASE WHEN paq.DescPaquete LIKE '%Ampli%' THEN 'Amplia'
        ELSE 'Otro' END AS Paquete,
        fp.DescFrecuenciaPago,
                
	count(DISTINCT(vc.NumCompletoCotizacion)) AS Cotizaciones,
    sum(vc.PLZ) AS Polizas,
    sum(vc.PrimaTarifa) AS Tarifa,
    sum(vc.Descuento) AS descuento

FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS vc

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vc.nipperfilagente

LEFT JOIN TB_BI_DimOficina AS ofi
ON ofi.IdOficina=vc.IdOficina


LEFT JOIN tb_bi_dimpaquete AS paq
ON paq.IdPaquete=vc.IdPaquete

LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS fp
ON fp.IdFrecuenciaPago=vc.IdFrecuenciaPago

WHERE vc.FechaCotizacion>= '20230101'
--AND vc.IdTarifa=1
--AND vc.IdPaquete IN (19,21,23,24,326,327,328,329,1300,1301,2458,2459,3211) 
AND vc.IdPaquete NOT IN (57, 58, 430, 431,432,447,448,449) 
--AND age.IdTipoAgente=19
--AND paq.DescPaquete LIKE '%AMPLI%'
AND age.NombreAgente NOT IN ('TRIGARANTE AGENTE DE SEGUROS Y DE FIANZAS SA DE CV','ASESORES DE RIESGO POR CANALES ALTERNOS AGENTE DE SEGUROS  SA DE CV')
AND ofi.IdOficina NOT IN (1,806,881,563)
AND vc.NumCompletoCotizacion NOT IN (40380000877243, 40380000876981, 40380000876982, 41760001230996, 41760001216843, 47360000005617,47360000005615, 40100001267513,41760001216844, 1760001121277, 41760001212948, 41760001127305, 40050001508447, 41390001279693,48260000003276, 40570001318953, 41950000980727, 41950000980494, 41950000976784, 41790000030565,41950000976322)
AND age.NipPerfilAgente NOT IN (68002, 90186,91681,96025, 105801, 105827)

GROUP BY year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) ,
		month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)),
		datepart(wk,convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) , --para esta funcion la semana empieza en domingo y termina en sabado
                convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111),
                vc.nipperfilagente,
  	    CASE WHEN vc.Idtarifa=1 THEN 'Tradicional'
        ELSE 'Otro' END,
        CASE WHEN paq.DescPaquete LIKE '%Ampli%' THEN 'Amplia'
        ELSE 'Otro' END,
        fp.DescFrecuenciaPago
        
        
UNION ALL

SELECT year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Anio,
	   month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) as Mes,
	   datepart(wk,convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) AS Semana, --para esta funcion la semana empieza en domingo y termina en sabado
       convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111) AS fecha,
        vc.nipperfilagente,
          CASE WHEN vc.Idtarifa=1 THEN 'Tradicional'
        ELSE 'Otro' END AS Tarifa,
        CASE WHEN paq.DescPaquete LIKE '%Ampli%' THEN 'Amplia'
        ELSE 'Otro' END AS Paquete,
        fp.DescFrecuenciaPago,
                

	count(DISTINCT(vc.NumCompletoCotizacion)) AS Cotizaciones,
    sum(vc.PLZ) AS Polizas,
    sum(vc.PrimaTarifa) AS Tarifa,
    sum(vc.Descuento) AS Descuento


FROM (

SELECT   
  
	ctz.TiempoCotizacion  
    , NumCompletoCotizacion = ctz.NumCompletoCotizacion  
    , IdOficina    = ctz.IdOficinaEmision  
    , PLZ     =  case when plz2.NumPoliza > 0 then 1 else 0 end   
    , NumPoliza    = isnull(plz2.NumPoliza, 0)  
    , PolizaAnterior  = cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint)  
    , NipPerfilAgente  = isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente)  
    , IdPaquete    = isnull(plz.IdPaquete, plz2.IdPaquete)    
    , IdVehiculoInterno  = isnull(plz.IdVehiculo , plz2.IdVehiculo)  
    , IdTarifa    = isnull(plz.IdTarifa, plz2.IdTarifa)  
    , IdFrecuenciaPago  = isnull(plz.IdFrecuenciaPago , plz2.IdFrecuenciaPago)   
    , PrimaTarifa   = isnull(plz2.PrimaTarifa , plz.PrimaTarifa)  
    , Descuento    = isnull( plz2.AjusteEspecial , plz.AjusteEspecial)  
 
from DWH.Tb_bi_AutrEmiCotiz ctz  
  
inner join TB_BI_DimOficina t4  
on t4.IdOficina = ctz.IdOficinaEmision    
 
left join DWH.Tb_bi_GrlEmiCotizado plz  
on plz.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and plz.NumDocumento = ctz.NumDocumento  
  --and plz.Eliminado = 0 -- #1  
   
left join TB_BI_AutrFactEmisionDoc plz2  
ON plz2.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and plz2.NumDocumento = ctz.NumDocumento  
 -- and isnull(plz2.IdTipoConservacion,0) = 0  
 
left join DWH.Tb_bi_GrlEmiAgenteCotizacion axc    
on axc.IdLineaNegocio = 4  
and ctz.NumCompletoCotizacion = axc.NumCompletoCotizacion  
and ctz.NumDocumento = axc.NumDocumento  
  
left join DWH.TB_BI_GrlFactOTSolicitud sol  
on sol.IdLineaNegocio = ctz.IdLineaNegocio  
and sol.NumCompletoCotizacion = ctz.NumCompletoCotizacion  
and sol.NumDocumento = ctz.NumDocumento  
and sol.Eliminado = 0  
and sol.IdEstatus = 3859   
  
left join VW_BI_DimVehiculo t2  
on t2.IdVehiculoInterno = isnull(plz.IdVehiculo , plz2.IdVehiculo)  
     
left join TB_BI_DimPaquete t3  
on t3.IdPaquete = isnull(plz.IdPaquete , plz2.IdPaquete)   
   
where  ctz.IdLineaNegocio = 4  
and ctz.TiempoCotizacion >= '20230101'
and ctz.Eliminado = 0  
and isnull(plz.IdTipoPoliza , plz2.IdTipoPoliza) = 4013  
and isnull(ctz.NumDocumento,0) = 0  
and isnull(sol.IdOrigenOT,3865) = 3865  -- DescAplicacion --> Web  
and t2.IdTipoVehiculo IN (4579, 3829)  
and cast(isnull(isnull(plz.NumPolizaAnterior,plz2.NumPolizaAnterior),0) as bigint) = 0  
and DescPaquete not like '%BASIC%'  
and DescPaquete not like '%RC%'  
and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) != 69982  
and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (69982, 55783 ,58997 ,61795 ,65627 ,66081 ,67197 ,90712 ,90713 ,90750 ,90751 ,90752, 58577 )  
--and isnull( axc.NipPerfilAgente, plz2.NipPerfilAgente) not in (Select NipPerfilAgente From TB_BI_DimAgente Where NombreAgente like '%HDI Seguros%' )  
--AND t4.IdDireccionComercial IN (31690, 26861, 26862)
 --and t4.DescDireccionComercial  in ( 'Bajio - Occidente','Mexico - Sur','Norte' )  
and ctz.IdOficinaEmision not in ( 11 ,18 ,21 ,25 ,26 ,31 ,42 )  
and isnull(plz2.IdTipoConservacion,0) = 0
--AND t4.IdOficina IN (074,434,722,720,382,290)
AND t4.IdOficina IN (74, 382)
AND t3.IdPaquete NOT IN (57, 58, 430, 431,432,447,448,449) 

) AS vc


LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vc.nipperfilagente

LEFT JOIN tb_bi_dimpaquete AS paq
ON paq.IdPaquete=vc.IdPaquete


LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS fp
ON fp.IdFrecuenciaPago=vc.IdFrecuenciaPago

--WHERE age.NombreAgente NOT IN ('TRIGARANTE AGENTE DE SEGUROS Y DE FIANZAS SA DE CV','ASESORES DE RIESGO POR CANALES ALTERNOS AGENTE DE SEGUROS  SA DE CV')
GROUP BY year(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) ,
		month(convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)),
		datepart(wk,convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111)) , --para esta funcion la semana empieza en domingo y termina en sabado
        convert(DATE,CAST(vc.TiempoCotizacion AS VARCHAR),111),
        vc.nipperfilagente,
          CASE WHEN vc.Idtarifa=1 THEN 'Tradicional'
        ELSE 'Otro' END,
        CASE WHEN paq.DescPaquete LIKE '%Ampli%' THEN 'Amplia'
        ELSE 'Otro' END,
        fp.DescFrecuenciaPago