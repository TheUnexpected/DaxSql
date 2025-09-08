SELECT 
        NipPerfilAgente,
        NipAgente,
        NumPerfil,
        NombreAgente,
        IdOficina IDOFICINAAGENTE,
        FechaAlta,
        IdPerfilEjecutivo,
        NombreEjecutivo,
        DescEstatusPerfil,
        IdTipoAgente,
        TRY_CAST(
           CONCAT(
              CASE WHEN CAST(substring(RFC, 5, 2) AS INT) > 20 THEN '19' ELSE '20' END,
               SUBSTRING(RFC, 5, 2), '-',
               SUBSTRING(RFC, 7, 2), '-',
               SUBSTRING(RFC, 9, 2)
        ) AS DATE) FechaNacimiento
FROM TB_BI_DimAgente age
LEFT JOIN TB_BI_DimEjecutivo eje
        on age.IdPerfilEjecutivo = eje.IdEjecutivo