Select
    CASE        
        WHEN DescPaquete like '%idri%' THEN 'Idriving'
        WHEN paq.IdPaquete = 3211 THEN 'Elite'
        WHEN DescPaquete like '%Premium%' THEN 'Premium'
        WHEN TipoPropuesto like 'RC' THEN 'RC'
        WHEN TipoPropuesto like '%Amplia%' THEN 'Amplia'
        WHEN TipoPropuesto like '%Limitada%' THEN 'Limitada'
        ELSE 'Otro' 
    END as Paquete,
    SUM(tec.PrimaNetaPropiaSinCoaseguro) 'prima',
    SUM(tec.unidadesemitidasreales) 'Unidades'
    --SUM(tec.PrimaNetaPropiaSinCoaseguro) / sum(tec.unidadesemitidasreales) Promedio
   -- DescPaquete
FROM TB_BI_AutrFactEmisionDoc aut
    INNER JOIN TB_BI_AutrBase2Tecnica tec
      ON tec.NumCompletoCotizacion=aut.NumCompletoCotizacion
      AND tec.NumDocumento=aut.NumDocumento
    INNER JOIN TB_BI_DimPaquete paq 
        ON aut.idpaquete = paq.IdPaquete
    /*LEFT JOIN TB_BI_DimOficina ofi
        ON ofi.IdOficina = aut.IdOficina*/
WHERE aut.IdTipoVehiculo in (4579, 3829) 
    and tec.Periodo BETWEEN 202501 and 202505
    and aut.idtipopoliza = 4013
--and ofi.IdDireccionComercial in (31690,26861,26862) 
GROUP BY
   CASE        
        WHEN DescPaquete like '%idri%' THEN 'Idriving'
        WHEN paq.IdPaquete = 3211 THEN 'Elite'
        WHEN DescPaquete like '%Premium%' THEN 'Premium'
        WHEN TipoPropuesto like 'RC' THEN 'RC'
        WHEN TipoPropuesto like '%Amplia%' THEN 'Amplia'
        WHEN TipoPropuesto like '%Limitada%' THEN 'Limitada'
        ELSE 'Otro' 
    END

/*
SELECT * FROM TB_BI_DimPaquete where idtipovehiculo in (4579, 3829) and DescPaquete like '%idriving%'
-- example elite 123 correct output, elite amplia 123 incorrect output

SELECT TOP (1000) *
  FROM Tb_Bi_AutrFactEmisionCob
*/