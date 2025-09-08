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
		FechaPago,	
		T_ENDOSO,	
		Moneda,
		PMATOT

FROM TB_DWH_GMMRecibosCobrados_CargaDiaria AS pag

WHERE fechaPago BETWEEN '2024-10-01' AND '2024-10-31'
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
		FechaPago,	
		T_ENDOSO,	
		Moneda,
		PMATOT

FROM dbo.TB_DWH_GmmcRecibosCobrados_CargaDiaria AS pag

WHERE fechaPago BETWEEN '2024-10-01' AND '2024-10-31'
AND oficina IN ( 433,553,575,675,684,736,860)