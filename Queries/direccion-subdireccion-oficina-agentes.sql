/*
SELECT * FROM TB_BI_DimOficina WHERE IdOficina = 988
SELECT distinct IdDireccionComercial, DescDireccionComercial FROM TB_BI_DimOficina
SELECT * FROM TB_BI_DimEjecutivo
SELECT TOP 20* FROM TB_BI_DimAgente;
*/
--agentes
SELECT 
       oficina.DescDireccionComercial Dirección,
       oficina.DescSubdireccionComercial Subdirección,
       oficina.NombreOficinaComercial 'Oficina Comercia',
       CONCAT(ejecutivo.IdEjecutivo, ' ',ejecutivo.NombreEjecutivo) Ejecutivo,       
       DescEstatusPerfil,
       COUNT(DISTINCT CONCAT(NipPerfilAgente, '-', NipAgente)) 'No. Agentes'
  FROM TB_BI_DimAgente agente
    INNER JOIN TB_BI_DimOficina oficina 
        ON oficina.IdOficina = agente.IdOficina
    INNER JOIN TB_BI_DimEjecutivo ejecutivo
        ON agente.IdPerfilEjecutivo = ejecutivo.IdEjecutivo
    WHERE Not IdPerfilEjecutivo = 0 and not agente.IdOficina in (0,2) 
         and oficina.IdDireccionComercial in (26861, 26862, 31690) --Mexico norte, bajio y sur
GROUP BY
    oficina.DescDireccionComercial,
    oficina.DescSubdireccionComercial,
    oficina.NombreOficinaComercial,
    CONCAT(ejecutivo.IdEjecutivo, ' ',ejecutivo.NombreEjecutivo),    
    DescEstatusPerfil
ORDER BY 
    oficina.DescDireccionComercial,
    oficina.DescSubdireccionComercial,
    oficina.NombreOficinaComercial

---------------------- Agentes Cancelados -----------------------------

SELECT 
       oficina.DescDireccionComercial Dirección,
       oficina.DescSubdireccionComercial Subdirección,
       oficina.NombreOficinaComercial 'Oficina Comercia',
       CONCAT(ejecutivo.IdEjecutivo, ' ',ejecutivo.NombreEjecutivo) Ejecutivo,       
       DescEstatusPerfil,
       CONCAT(NipPerfilAgente, '-', NombreAgente) 'Agentes'
  FROM TB_BI_DimAgente agente
    INNER JOIN TB_BI_DimOficina oficina 
        ON oficina.IdOficina = agente.IdOficina
    INNER JOIN TB_BI_DimEjecutivo ejecutivo
        ON agente.IdPerfilEjecutivo = ejecutivo.IdEjecutivo
    WHERE Not IdPerfilEjecutivo = 0 and not agente.IdOficina in (0,2) 
         and oficina.IdDireccionComercial in (26861, 26862, 31690) --Mexico norte, bajio y sur
         and agente.DescEstatusAgente like '%CANCELADO%' and agente.DescEstatusPerfil like '%CANCELADO%'
  ORDER BY 
    oficina.DescDireccionComercial, oficina.DescSubdireccionComercial, oficina.NombreOficinaComercial

--------------------------------- Agentes Desglosados (con 1 asignado y no laborando) -----------------------------------------------

WITH AgentesAgrupados AS (
        SELECT 
            oficina.DescDireccionComercial Dirección,
            oficina.DescSubdireccionComercial Subdirección,
            oficina.NombreOficinaComercial Oficina,
            ejecutivo.IdEjecutivo,  
            COUNT(DISTINCT CONCAT(NipPerfilAgente, '-', NipAgente)) 'No. Agentes'
        FROM TB_BI_DimAgente agente
            INNER JOIN TB_BI_DimOficina oficina 
                ON oficina.IdOficina = agente.IdOficina
            INNER JOIN TB_BI_DimEjecutivo ejecutivo
                ON agente.IdPerfilEjecutivo = ejecutivo.IdEjecutivo
            WHERE Not IdPerfilEjecutivo = 0 and not agente.IdOficina in (0,2) 
                and oficina.IdDireccionComercial in (26861, 26862, 31690) --Mexico norte, bajio y sur
        GROUP BY
            oficina.DescDireccionComercial,
            oficina.DescSubdireccionComercial,
            oficina.NombreOficinaComercial,
            ejecutivo.IdEjecutivo    
        HAVING COUNT(DISTINCT CONCAT(NipPerfilAgente, '-', NipAgente)) <= 3
)

-- Ahora se une con la tabla original para obtener los detalles
SELECT 
    oficina.DescDireccionComercial AS Dirección,
    oficina.DescSubdireccionComercial AS Subdirección,
    oficina.NombreOficinaComercial AS 'Oficina Comercial',
    oficina.NombreOficina 'Oficina Operativa',
    CONCAT(agente.NipPerfilAgente, ' ', agente.NombreAgente) AS Agente,
    CONCAT(ejecutivo.IdEjecutivo, ' ', ejecutivo.NombreEjecutivo) AS Ejecutivo,       
    DescEstatusPerfil
FROM TB_BI_DimAgente agente
INNER JOIN TB_BI_DimOficina oficina 
    ON oficina.IdOficina = agente.IdOficina
INNER JOIN TB_BI_DimEjecutivo ejecutivo
    ON agente.IdPerfilEjecutivo = ejecutivo.IdEjecutivo
INNER JOIN AgentesAgrupados agrupados
    ON oficina.NombreOficinaComercial = agrupados.Oficina
    AND ejecutivo.IdEjecutivo = agrupados.IdEjecutivo
LEFT JOIN TB_BI_Reportes_SegSSO_ListaAD compañia
    ON compañia.SSO = agente.IdPerfilEjecutivo
WHERE 
    compañia.SSO is null
ORDER BY 
    oficina.DescDireccionComercial,
    oficina.DescSubdireccionComercial,
    oficina.NombreOficinaComercial