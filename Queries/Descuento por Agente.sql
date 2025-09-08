Select
    --tec.periodo,    
    ofi.DescSubdireccionComercial,
    CASE
        WHEN NULLIF(sum(tec.PrimaNetaPropiaTarifa), 0) IS NULL THEN 'tarifa cero'
        WHEN (sum(tec.PrimaNeta)/NULLIF(sum(tec.PrimaNetaPropiaTarifa),0)) - 1 BETWEEN 0 and 0.3 THEN '0% - 30%'
        WHEN (sum(tec.PrimaNeta)/NULLIF(sum(tec.PrimaNetaPropiaTarifa),0)) - 1 BETWEEN 0.31 and 0.35 THEN '31% - 35%'
        WHEN (sum(tec.PrimaNeta)/NULLIF(sum(tec.PrimaNetaPropiaTarifa),0)) - 1 BETWEEN 0.36 and 0.4 THEN '36% - 40%'
        WHEN (sum(tec.PrimaNeta)/NULLIF(sum(tec.PrimaNetaPropiaTarifa),0)) - 1 >= 0.41 THEN '>40%'
    END 'ClasificacionDecuento',
    COUNT(distinct aut.nipperfilagente) 'Num Agentes',
    --ofi.NombreOficinaComercial,
    --ofi.NombreOficina,
    --age.nipperfilagente,
    --aut.NumPoliza,
    --aut.NumeroSerie,
    --aut.FechaFinVigencia,
    --sum(tec.PrimaNeta) 'Neta',
    --sum(tec.PrimaNetaPropiaTarifa) 'Tarifa',
    sum(tec.PrimaNetaPropiaSinCoaseguro) 'Emitida',
    AVG(tec.PrimaNetaPropiaSinCoaseguro) 'Emitido Promedio'
    --,SUM(tec.PrimaNetaPropiaPagada) 'Pagada'    
    --sum(tec.primanetapropiaemitidadevengada) 'Devengado',
    --sum(tec.ocurrido) 'Ocurrido'
    ,sum(tec.unidadesemitidasreales) 'unidades'
FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
      ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
      AND tec.NumDocumento=aut.NumDocumento 
 LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = aut.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo

WHERE
    tec.Periodo BETWEEN 202501 and 202508
    AND ofi.IdDireccionComercial in (31690,26861,26862) --Tradicional
    and aut.idtipopoliza = 4013 --individual
    and aut.numpolizaanterior = 0 --nuevo
    and aut.IdTipoVehiculo in (4579, 3829) --autos y pickup

GROUP BY
    ofi.DescSubdireccionComercial;

--------------------------------------------------

WITH AggregatedData AS (
    SELECT
        ofi.DescSubdireccionComercial,
        aut.NipPerfilAgente,
        SUM(tec.PrimaNetaPropiaEmitida) AS TotalPrimaNeta,
        SUM(tec.PrimaNetaPropiaTarifa) AS TotalPrimaTarifa,
        SUM(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida,
        AVG(tec.PrimaNetaPropiaSinCoaseguro) AS Emitido_Promedio,
        SUM(tec.unidadesemitidasreales) AS unidades
        --COUNT(DISTINCT aut.NipPerfilAgente) AS Num_Agentes
    FROM TB_BI_AutrFactEmisionDoc aut
        INNER JOIN TB_BI_AutrBase2Tecnica tec
            ON tec.NumCompletoCotizacion = aut.NumCompletoCotizacion
            AND tec.NumDocumento = aut.NumDocumento 
        LEFT JOIN TB_BI_DimAgente age
            ON age.NipPerfilAgente = aut.NipPerfilAgente
        LEFT JOIN TB_BI_DimOficina ofi
            ON ofi.IdOficina = age.IdOficina
        LEFT JOIN TB_BI_DimEjecutivo eje
            ON eje.idEjecutivo = age.IdPerfilEjecutivo
    WHERE
        tec.Periodo BETWEEN 202501 AND 202508
        and ofi.IdDireccionComercial in (31690,26861,26862) --Tradicional
        AND aut.idtipopoliza = 4013 -- individual
        AND aut.numpolizaanterior = 0 -- nuevo
        AND aut.IdTipoVehiculo IN (4579, 3829) -- autos y pickup
    GROUP BY
        ofi.DescSubdireccionComercial
        ,aut.NipPerfilAgente
)
SELECT
    --DescSubdireccionComercial,
    CASE
        WHEN NULLIF(TotalPrimaTarifa, 0) IS NULL THEN 'tarifa cero'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.3 AND 0 THEN '0% - 30%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.35 AND -0.31 THEN '31% - 35%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.4 AND -0.36 THEN '36% - 40%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 <= -0.41 THEN '>40%'
        ELSE 'Sin Descuento'
    END AS ClasificacionDescuento,
    COUNT(DISTINCT NipPerfilAgente) AS Num_Agentes,
    SUM(Emitida) AS Emitida,
    AVG(Emitido_Promedio) AS Emitido_Promedio,
    SUM(unidades) AS unidades
FROM AggregatedData
GROUP BY
    --DescSubdireccionComercial,
    CASE
        WHEN NULLIF(TotalPrimaTarifa, 0) IS NULL THEN 'tarifa cero'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.3 AND 0 THEN '0% - 30%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.35 AND -0.31 THEN '31% - 35%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 BETWEEN -0.4 AND -0.36 THEN '36% - 40%'
        WHEN (TotalPrimaNeta / NULLIF(TotalPrimaTarifa, 0)) - 1 <= -0.41 THEN '>40%'
        ELSE 'Sin Descuento'
    END

    