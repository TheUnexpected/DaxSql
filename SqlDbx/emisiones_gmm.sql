SELECT gmm.RamoSubramol, 
		gmm.Oficina,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina, 
		gmm.NPoliza,
		gmm.Contrat,
		gmm.FMaPago,
		gmm.FemiRbo, 
		gmm.Finivig, 
		gmm.Ftervig, 
		--gmm.Fecha AS Fecha_Cancelacion,
		gmm.Pma1 AS Prima,
		gmm.NAgente,
		age.NombreAgente,
		gmm.Renueva,
		gmm.PolSocioComercial
		
FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=gmm.NAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE ofi.DescSubdireccionComercial='Sur'
AND femirbo BETWEEN 20240101 AND 20241231

UNION ALL

SELECT gmm.RamoSubramol, 
		gmm.Oficina,
		ofi.DescSubdireccionComercial,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina, 
		gmm.NPoliza,
		gmm.Contrat,
		gmm.FMaPago,
		gmm.FemiRbo, 
		gmm.Finivig, 
		gmm.Ftervig,
		--gmm.Fecha AS Fecha_Cancelacion ,
		gmm.Pma1 AS Prima,
		gmm.NAgente,
		age.NombreAgente,
		gmm.Renueva,
		gmm.PolSocioComercial
		
FROM  dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS gmm

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=gmm.NAgente

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=age.IdOficina

WHERE ofi.DescSubdireccionComercial='Sur'
AND femirbo BETWEEN 20240101 AND 20241231