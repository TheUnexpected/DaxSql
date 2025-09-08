SELECT  'Curso' AS Uso,
		emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		isnull(emi_tec.DescPaquete, agentes.Nombre_Curso) AS DescPaquete,
		
		round(sum(emi_tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(emi_tec.UnidadesEmitidasReales) AS Unidades


FROM (
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre AS Nombre_Curso,
			paque.IdPaquete,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		left JOIN  TB_BI_DimPaquete AS paque
			ON paque.DescPaquete collate Modern_Spanish_CI_AS = cur.Nombre collate Modern_Spanish_CI_AS

	  		WHERE cur.Nombre collate Modern_Spanish_CI_AS IN 

		   		(	
		   			SELECT DISTINCT paq.DescPaquete

			   		FROM  TB_BI_ACAGrlAdmonCurso AS curso

					INNER JOIN  TB_BI_DimPaquete AS paq
					ON paq.DescPaquete collate Modern_Spanish_CI_AS = curso.Nombre collate Modern_Spanish_CI_AS

				)
				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre,
			paque.idPaquete
		
		
		) AS agentes
	

LEFT JOIN ( 
			SELECT tec.Periodo,
				emi.IdOficina,
				emi.NipPerfilAgente,
				tec.PrimaNetaPropiaSinCoaseguro,
				tec.UnidadesEmitidasReales,
				paq.idPaquete,
				paq.DescPaquete
		
			FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi
		
		
			INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
			ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
			AND emi.NumDocumento = tec.NumDocumento
			and tec.Periodo>=202001
			
			LEFT  JOIN  TB_BI_DimPaquete AS paq
			ON paq.IdPaquete=emi.IdPaquete
	
	
		) AS emi_tec
		
	ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente
	AND agentes.Idpaquete=emi_tec.IdPaquete

WHERE agentes.Cursoid NOT IN (15)	

GROUP BY emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		isnull(emi_tec.DescPaquete, agentes.Nombre_Curso)
		
UNION

SELECT  'Sin Curso' AS Uso,
		tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente,
		paq.DescPaquete,
		
		round(sum(tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(tec.UnidadesEmitidasReales) AS Unidades


FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi


INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
AND emi.NumDocumento = tec.NumDocumento
and tec.Periodo>=202001
	
LEFT JOIN 
		(
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre AS Nombre_Curso,
			paque.IdPaquete,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		left JOIN  TB_BI_DimPaquete AS paque
			ON paque.DescPaquete collate Modern_Spanish_CI_AS = cur.Nombre collate Modern_Spanish_CI_AS

	  		WHERE cur.Nombre collate Modern_Spanish_CI_AS IN 

		   		(	
		   			SELECT DISTINCT paq.DescPaquete

			   		FROM  TB_BI_ACAGrlAdmonCurso AS curso

					INNER JOIN  TB_BI_DimPaquete AS paq

					ON paq.DescPaquete collate Modern_Spanish_CI_AS = curso.Nombre collate Modern_Spanish_CI_AS
				)
				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre,
			paque.idPaquete
		
		
		) AS agentes
	
ON agentes.NipPerfilAgente=emi.NipPerfilAgente
AND agentes.Idpaquete=emi.IdPaquete

LEFT  JOIN  TB_BI_DimPaquete AS paq
ON paq.IdPaquete=emi.IdPaquete

LEFT JOIN TB_BI_DimAgente AS ageII
ON ageII.NipPerfilAgente=emi.NipPerfilAgente
	
WHERE emi.idpaquete IN (258,726)

AND agentes.Primer_Curso IS NULL

GROUP BY tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente,
		paq.DescPaquete
				
UNION

SELECT  'Curso' AS Uso,
		emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		'Multiple Empresarial' AS DescPaquete,
		
		round(sum(emi_tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(emi_tec.UnidadesEmitidasReales) AS Unidades


FROM 	(
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre AS Nombre_Curso,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=37

				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre
		
		) AS agentes


LEFT JOIN (
			SELECT tec.Periodo,
				emi.IdOficina,
				emi.NipPerfilAgente,
				tec.PrimaNetaPropiaSinCoaseguro,
				tec.UnidadesEmitidasReales

			FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi
			
			INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
			ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
			AND emi.NumDocumento = tec.NumDocumento
			and tec.Periodo>=202001
			
			WHERE emi.idpaquete IN (5,7,9,18)
			
		) AS emi_tec
	   
	
ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente
	

GROUP BY 	emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente
		
UNION


SELECT  'Sin Curso' AS Uso,
		tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente,
		'Multiple Empresarial' AS DescPaquete,
		
		round(sum(tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(tec.UnidadesEmitidasReales) AS Unidades


FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
AND emi.NumDocumento = tec.NumDocumento
and tec.Periodo>=202001
	
left JOIN 
		(
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre AS Nombre_Curso,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=37

				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre
		
		) AS agentes
	
ON agentes.NipPerfilAgente=emi.NipPerfilAgente

LEFT JOIN TB_BI_DimAgente AS ageII
ON ageII.NipPerfilAgente=emi.NipPerfilAgente
	
	
WHERE emi.idpaquete IN (5,7,9,18)


AND agentes.Primer_Curso IS NULL

GROUP BY tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente
		
UNION

SELECT  'Curso' AS Uso,
			emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		'Equipo Contratistas' AS DescPaquete,
		
		round(sum(emi_tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(emi_tec.UnidadesEmitidasReales) AS Unidades


FROM 	(
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre AS Nombre_Curso,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=14

				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			age.IdOficina,
			cur.Nombre
		
		) AS agentes


LEFT JOIN (
			SELECT tec.Periodo,
				emi.IdOficina,
				emi.NipPerfilAgente,
				tec.PrimaNetaPropiaSinCoaseguro,
				tec.UnidadesEmitidasReales

			FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi
			
			INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
			ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
			AND emi.NumDocumento = tec.NumDocumento
			and tec.Periodo>=202001
			
			WHERE emi.idpaquete IN (59)
			
		) AS emi_tec
	   
	
ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente
	

GROUP BY 	emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente

UNION


SELECT  'Sin Curso' AS Uso,
	   tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente,
		'Equipo Contratistas' AS DescPaquete,
		
		round(sum(tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(tec.UnidadesEmitidasReales) AS Unidades


FROM HDI_DWH.dbo.TB_BI_DanFactEmisionDoc  AS emi

INNER JOIN HDI_DWH.dbo.TB_BI_DanBase2Tecnica AS tec
ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
AND emi.NumDocumento = tec.NumDocumento
and tec.Periodo>=202001
	
left JOIN 
		(
			SELECT distinct ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre AS Nombre_Curso,

	   		min(ag_cur.FechaInicio) AS Primer_Curso

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=14

				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre
		
		) AS agentes
	
ON agentes.NipPerfilAgente=emi.NipPerfilAgente
		
LEFT JOIN TB_BI_DimAgente AS ageII
ON ageII.NipPerfilAgente=emi.NipPerfilAgente
	
	
WHERE emi.idpaquete IN (59)

AND agentes.Primer_Curso IS NULL

GROUP BY tec.Periodo,
		agentes.Primer_Curso,
		emi.IdOficina,
		ageII.NipAgente,
		emi.NipPerfilAgente