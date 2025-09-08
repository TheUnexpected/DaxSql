SELECT 
    oficina.NombreOficina,
    CONCAT(NipPerfilAgente, '-', agente.NombreAgente) agente,
    agente.DescEstatusPerfil,

    CONCAT(ejecutivo.IdEjecutivo, ' ',ejecutivo.NombreEjecutivo) Ejecutivo
 
FROM TB_BI_DimAgente agente
    INNER JOIN TB_BI_DimOficina oficina 
        ON oficina.IdOficina = agente.IdOficina
    INNER JOIN TB_BI_DimEjecutivo ejecutivo
        ON agente.IdPerfilEjecutivo = ejecutivo.IdEjecutivo
    WHERE ejecutivo.NombreEjecutivo like '%Franco%'

-----------------------------------------------------------------------------------
    SELECT 
		ofi.NombreOficinaComercial 'Oficina Comercial',
		ofi.NombreOficina 'Oficina Operativa',
		CONCAT(NipPerfilAgente, '-', age.NombreAgente) 'Perfil Agente',		
		'SIN EJECUTIVO' as 'Ejecutivo'
 
FROM TB_BI_DimAgente AS age
 
left JOIN TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo
 
LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina
 
WHERE age.DescEstatusAgente IN ('CANCELADO','FALLECIDO')
AND eje.IdEjecutivo IS NOT NULL
 
ORDER BY ofi.IdOficina DESC