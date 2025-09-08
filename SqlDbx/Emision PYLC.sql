SELECT Oficina,
		NPOLIZA,
		Ramosubramo,	
		Ramosubramol,	
		CONTRAT,	
		FMAPAGO,	
		FEMIRBO,	
		FINIVIG,	
		FTERVIG,	
		NAGENTE,	
		FESTATUS,	
		--T_ENDOSO,	
		Moneda,
		PMATOT

FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS pag

WHERE femirbo BETWEEN '2024-10-01' AND '2024-10-31'
AND oficina IN ( 433,553,575,675,684,736,860)

UNION ALL

SELECT Oficina,
		NPOLIZA,
		Ramosubramo,	
		Ramosubramol,	
		CONTRAT,	
		FMAPAGO,	
		FEMIRBO,	
		FINIVIG,	
		FTERVIG,	
		NAGENTE,	
		FESTATUS,	
		--T_ENDOSO,	
		Moneda,
		PMATOT

FROM  dbo.TB_DWH_GMMCEmitidoAcumulado_CargaDiaria AS pag

WHERE femirbo BETWEEN '2024-10-01' AND '2024-10-31'
AND oficina IN ( 433,553,575,675,684,736,860)

UNION ALL

SELECT Oficina,
		NPOLIZA,
		Ramosubramo,	
		Ramosubramol,	
		CONTRAT,	
		FMAPAGO,	
		FEMIRBO,	
		FINIVIG,	
		FTERVIG,	
		NAGENTE,	
		FECHA,	
		--T_ENDOSO,	
		Moneda,
		-PMATOT

FROM  TB_DWH_GMMEmitidoCancelaciones_CargaDiaria AS pag

WHERE fecha BETWEEN '2024-10-01' AND '2024-10-31'
AND oficina IN ( 433,553,575,675,684,736,860)

UNION ALL

SELECT Oficina,
		NPOLIZA,
		Ramosubramo,	
		Ramosubramol,	
		CONTRAT,	
		FMAPAGO,	
		FEMIRBO,	
		FINIVIG,	
		FTERVIG,	
		NAGENTE,	
		FECHA,	
		--T_ENDOSO,	
		Moneda,
		-PMATOT

FROM  TB_DWH_GMMcEmitidoCancelaciones_CargaDiaria AS pag

WHERE fecha BETWEEN '2024-10-01' AND '2024-10-31'
AND oficina IN ( 433,553,575,675,684,736,860)