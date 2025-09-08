    SELECT CASE WHEN tecnica.Periodo BETWEEN 202401 AND 202406 THEN 'Primer'
    			WHEN tecnica.Periodo BETWEEN 202407 AND 202412 THEN 'Segundo'
    			ELSE 'Otros' END AS Periodo,
		concat(autos.IdOficina, ' - ', autos.NumPoliza) AS Poliza,
		autos.NipPerfilAgente,
		tip.DescGrupoTipoPoliza,
		con.DescGrupoConservacion,
		
		sum(tecnica.UnidadesEmitidasReales) AS Unidades,
		sum(tecnica.primanetapropiasincoaseguro) AS prima
		 
 
FROM
    TB_BI_AutrFactEmisionDoc autos
    
INNER JOIN TB_BI_AutrBase2Tecnica tecnica  
ON autos.NumCompletoCotizacion = tecnica.NumCompletoCotizacion
AND autos.NumDocumento = tecnica.NumDocumento
AND tecnica.Periodo BETWEEN 202401 AND 202412

LEFT JOIN tb_bi_dimtipopoliza AS tip
ON tip.IdTipoPoliza=autos.idtipopoliza

LEFT JOIN TB_Bi_DimTipoConservacion AS con
ON con.IdTipoConservacion=autos.IdTipoConservacion

WHERE autos.IdTipoVehiculo in (22809,5676)
AND autos.NipPerfilAgente IN (10108,10161,101739,101810,101821,102834,103066,104499,
                                    105073,105154,105521,21208,21224,21252,5152,5164,
                                    51737,52189,5227,52753,52983,53250,53353,53630,
                                    54724,54776,54892,55101,55101,55468,56292,56310,
                                    58232,58255,58538,58747,5975,63207,63367,65026,
                                    65214,66008,66139,66334,67196,67362,67413,67419,
                                    67465,67712,67944,68314,68544,69576,69995,70243,
                                    70313,70391,91849,92047,92276,93512,93655,94401,
                                    95429,95538,96021,96880,97078)
GROUP BY
    CASE WHEN tecnica.Periodo BETWEEN 202401 AND 202406 THEN 'Primer'
    			WHEN tecnica.Periodo BETWEEN 202407 AND 202412 THEN 'Segundo'
    			ELSE 'Otros' END,
		autos.IdOficina,
		autos.NumPoliza,
		autos.NipPerfilAgente,
		tip.DescGrupoTipoPoliza,
		con.DescGrupoConservacion
		
--HAVING sum(tecnica.UnidadesEmitidasReales)>0