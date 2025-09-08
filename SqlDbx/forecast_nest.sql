SELECT 'Autos' AS Ramo,
    pmas.Periodo,
    agentes.Perfil,
    --agentes.Estatus,
    --agentes.FechaAlta,
    fpago.DescFrecuenciaPago,
   
   Generacion_Recluta=CASE
        WHEN year(agentes.FechaAlta)>=2021 THEN CAST(year(agentes.FechaAlta) AS VARCHAR)
        ELSE 'Otros_Casos' END,
       
       sum( pmas.Prima_Emitida) AS Emitida,
       sum( pmas.Prima_Pagada ) AS Pagada
       
FROM  (
 
    SELECT t1.Periodo,
            t2.NipPerfilAgente,
            t2.IdFrecuenciaPago,
           
            Prima_Emitida= SUM(t1.PrimaNetaPropiaEmitida),
            Prima_Pagada=SUM(t1.primanetapropiapagada)
 
    FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc  AS t2 with(nolock)
 
    inner JOIN HDI_DWH.dbo.TB_Bi_AutrBase2Tecnica AS t1 with(nolock)
    ON t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
    AND t2.NumDocumento = t1.NumDocumento
    and   t1.Periodo BETWEEN 202101 AND 202411  -->=202401 -->=202405 -->=202401 --
   
    WHERE t2.numpolizaanterior=0
    GROUP BY t1.Periodo,
            t2.NipPerfilAgente,
            t2.IdFrecuenciaPago
   
   
    ) AS pmas
    
LEFT JOIN (
 
	SELECT  
	   
	    t6.NipPerfilAgente AS Perfil,
	    t6.DescEstatusPerfil AS Estatus,
	    t6.FechaAlta,
	    t3.CanalVenta  
	   
	    FROM HDI_DWH.dbo.TB_BI_DimAgente AS t6
	 
	   
	    Left join TB_BI_DimProgramasAgentes t3
	    on t3.NipPerfilAgente  = t6.NipPerfilAgente
	 
) AS agentes
   
ON pmas.NipPerfilAgente=agentes.Perfil
 
LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS fpago
ON fpago.IdFrecuenciaPago=pmas.IdFrecuenciaPago
 
   
WHERE agentes.CanalVenta IN ('Promotorías Nest', 'Nueva Recluta', 'HDI Spot')
AND fpago.DescFrecuenciaPago IN ('SEMESTRAL', 'ANUAL', '12 MESES SIN IN','6 MESES SIN INT', '3 MESES SIN INT','CONTADO')

GROUP BY  pmas.Periodo,
    agentes.Perfil,
    --agentes.Estatus,
    --agentes.FechaAlta,
    fpago.DescFrecuenciaPago,
   
   CASE
        WHEN year(agentes.FechaAlta)>=2021 THEN CAST(year(agentes.FechaAlta) AS VARCHAR)
        ELSE 'Otros_Casos' END