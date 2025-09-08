----------- TOP 20 -------------------
WITH Datos AS (
    SELECT    

        CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) AS Agente,
        ofi.DescSubdireccionComercial,
        ofi.nombreoficinacomercial,
        SUM(tec.PrimaNetaPropiaSinCoaseguro) AS TotalPrima
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoNuevo
        ,SUM(tec.PrimaNetaPropiaPagada) AS PagadaPrima
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaNuevo
        ,sum(tec.unidadesemitidasreales) 'unidades'
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaNuevo
        ,sum(tec.primanetapropiaemitidadevengada) 'Devengado'
        ,sum(tec.ocurrido) 'Ocurrido'
    FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
        ON tec.NumCompletoCotizacion = aut.NumCompletoCotizacion
        AND tec.NumDocumento = aut.NumDocumento 
    LEFT JOIN TB_BI_DimAgente age
        ON age.NipPerfilAgente = aut.NipPerfilAgente
    LEFT JOIN TB_BI_DimOficina ofi
        ON ofi.IdOficina = age.IdOficina
    WHERE
        tec.Periodo between 202401 and 202412
        AND ofi.IdDireccionComercial in (31690,26861,26862) 
        --and ofi.idoficina = 20
        --and aut.idtipopoliza = 4013
        AND year(age.FechaAlta) <= 2020
    GROUP BY
        CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
        ofi.DescSubdireccionComercial,
        ofi.nombreoficinacomercial
),
Top20 AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY DescSubdireccionComercial
               ORDER BY TotalPrima DESC
           ) AS rn
    FROM Datos
)
SELECT Agente, DescSubdireccionComercial, nombreoficinacomercial, TotalPrima, EmitidoRenovada, EmitidoNuevo, PagadaPrima, PagadaRenovada, PagadaNuevo, unidades, PolizaRenovada, PolizaNuevo, Devengado, Ocurrido
FROM Top20
WHERE rn <= 20
ORDER BY DescSubdireccionComercial, TotalPrima DESC;

---------- Demás años por top 20 -----------

SELECT    

        CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) AS Agente,
        ofi.DescSubdireccionComercial,
        SUM(tec.PrimaNetaPropiaSinCoaseguro) AS TotalPrima
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoNuevo
        ,SUM(tec.PrimaNetaPropiaPagada) AS PagadaPrima
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaNuevo
        ,sum(tec.unidadesemitidasreales) 'unidades'
        ,SUM(CASE WHEN aut.numpolizaanterior <> 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaRenovada
        ,SUM(CASE WHEN aut.numpolizaanterior = 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaNuevo
        ,sum(tec.primanetapropiaemitidadevengada) 'Devengado'
        ,sum(tec.ocurrido) 'Ocurrido'
    FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
        ON tec.NumCompletoCotizacion = aut.NumCompletoCotizacion
        AND tec.NumDocumento = aut.NumDocumento 
    LEFT JOIN TB_BI_DimAgente age
        ON age.NipPerfilAgente = aut.NipPerfilAgente
    LEFT JOIN TB_BI_DimOficina ofi
        ON ofi.IdOficina = age.IdOficina
    WHERE
        tec.Periodo between 202301 and 202312
        AND ofi.IdDireccionComercial in (31690,26861,26862) 
        --and aut.idtipopoliza = 4013
        AND year(age.FechaAlta) <= 2020
        and aut.NipPerfilAgente in (103029)
    GROUP BY
        CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
        ofi.DescSubdireccionComercial

--------------- EDAD por RFC --------------
SELECT 
    RFC,
    CASE
        WHEN LEN(RFC) = 13 THEN
    DATEDIFF(YEAR, 
        TRY_CAST(
          IIF(SUBSTRING(RFC,5,2) > RIGHT(YEAR(GETDATE()),2), '19', '20') + SUBSTRING(RFC,5,6) 
          AS DATE
        ), 
        GETDATE()
      )
      - IIF(
          FORMAT(GETDATE(),'MMdd') < SUBSTRING(RFC,7,4), 
          1, 
          0
        )
    ELSE NULL
    END as 'Edad Persona',
      CASE 
    WHEN LEN(RFC) = 12 THEN 
      TRY_CAST(
        IIF(SUBSTRING(RFC,4,2) > RIGHT(YEAR(GETDATE()),2), '19', '20') + SUBSTRING(RFC,4,6) 
        AS DATE
      )
    ELSE NULL
  END AS 'FechaConstitucion PMoral'
    
 FROM TB_BI_DimAgente 
where year(FechaAlta) >= year(2020)

----------------------------- Daños ---------------------------------------
Select 
        CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente) AS Agente,
        ofi.DescSubdireccionComercial,
        SUM(tec.PrimaNetaPropiaSinCoaseguro) AS TotalPrima
        ,SUM(CASE WHEN dan.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoRenovada
        ,SUM(CASE WHEN dan.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaSinCoaseguro ELSE 0 END) EmitidoNuevo
        ,SUM(tec.PrimaNetaPropiaPagada) AS PagadaPrima
        ,SUM(CASE WHEN dan.numpolizaanterior <> 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaRenovada
        ,SUM(CASE WHEN dan.numpolizaanterior = 0 THEN tec.PrimaNetaPropiaPagada ELSE 0 END) PagadaNuevo
        ,sum(tec.unidadesemitidasreales) 'unidades'
        ,SUM(CASE WHEN dan.numpolizaanterior <> 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaRenovada
        ,SUM(CASE WHEN dan.numpolizaanterior = 0 THEN tec.unidadesemitidasreales ELSE 0 END) PolizaNuevo
        ,sum(tec.primanetapropiaemitidadevengada) 'Devengado'
        ,sum(tec.ocurrido) 'Ocurrido'
FROM TB_BI_DanFactEmisionDoc dan
 INNER JOIN TB_DWH_DanBaseTecnica tec
   ON tec.NumCompletoCotizacion=dan.NumCompletoCotizacion
   AND tec.NumDocumento=dan.NumDocumento
 LEFT JOIN TB_BI_DimAgente age
   ON age.NipPerfilAgente = dan.NipPerfilAgente
 LEFT JOIN TB_BI_DimOficina ofi
   ON ofi.IdOficina = age.IdOficina
 LEFT JOIN TB_BI_DimEjecutivo eje
   ON eje.idEjecutivo = age.IdPerfilEjecutivo
WHERE
    tec.Periodo between 202301 and 202312
    AND ofi.IdDireccionComercial in (31690,26861,26862) 
    --and aut.idtipopoliza = 4013
    AND year(age.FechaAlta) <= 2020
    and dan.NipPerfilAgente in (103029)
GROUP BY
    CONCAT(age.NipPerfilAgente, ' ', age.NombreAgente),
        ofi.DescSubdireccionComercial
   