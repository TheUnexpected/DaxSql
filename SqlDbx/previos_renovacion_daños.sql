SELECT DISTINCT	IdOficina, 
				NumPoliza 
--NumCertificado
FROM TB_BI_DanFactEmisionDoc t1

where exists(
	Select 1 
	
	from TB_BI_DanFactCisVigentes t2 

	where t2.NumCompletoCotizacion = t1.NumCompletoCotizacion
	and t2.NumDocumento = t1.NumDocumento
	and t2.Periodo between convert(char(6),dateadd(month,-1,FechaFinVigencia),112) and convert(char(6),FechaFinVigencia,112))
	and fechafinvigencia BETWEEN '2025-01-01' and '2025-01-31' --periodo 
	and NumDocumento = 0
	and IdPaquete not in (
	1--PÓLIZA ESPECÍFICA
	,226--PÓLIZA DE HOYO EN UNO
	,3797--Seguro Montaje de Maquinaria
	,3798--Seguro de Obra Civil
	,512--KIPO
	)
	and (
	(IdPaquete in 
	(	
	10--POLIZA DE RESPONSABILIDAD CIVIL
	,514--RESPONSABILIDAD CIVIL CONSTRUCTORES Y SERVICIOS
	) and IdMesesVigenciaCis >= 11) or (IdPaquete not in (10,514))
) 