
SELECT  DISTINCT ofi.DescDireccionComercial,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		--ofi.NombreOficina,
		--concat(age.NipPerfilAgente,' ',age.NombreAgente) AS Perfil_Agente,
		concat(eje.IdEjecutivo,' - ',eje.NombreEjecutivo) AS Ejecutivo


FROM TB_BI_DimAgente AS age


inner JOIN  TB_BI_DimEjecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo
AND eje.IdEjecutivo IS NOT NULL

inner JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=age.IdOficina
AND ofi.IdDireccionComercial IN (26862,31690,26861)


--WHERE age.NipPerfilAgente IN (94523,94533,53520,90469,95747,50305,95354,95646,5194,61234,56912,98357,66960,63423,68260,51759,51351,91680,5891,101728,103687,98596,64220,102719,58090,101877,102766,91992,58352,99130,101202,102010,104002,68248,52158,69140,61575,51684,50671,5852,91014,69163,5949,52981,56431,55240,5992,61749,91354)
