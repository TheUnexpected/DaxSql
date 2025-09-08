
SELECT  'Curso' AS Uso,
		emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		'HDI EN MI AUTO' AS DescPaquete,
		
		round(sum(emi_tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(emi_tec.UnidadesEmitidasReales) AS Unidades


FROM  (
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
	  		
	  		WHERE ag_cur.CursoId=8

				
			GROUP BY ag_cur.CursoId,
			ag_cur.NipAgente,
			age.NipPerfilAgente,
			cur.Nombre,
			age.IdOficina
		
		) AS agentes


LEFT JOIN (
		
		SELECT tec.Periodo,
		emi.IdOficina,
		emi.NipPerfilAgente,
		tec.PrimaNetaPropiaSinCoaseguro,
		tec.UnidadesEmitidasReales

		FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc  AS emi
		
		INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
		ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
		AND emi.NumDocumento = tec.NumDocumento
		AND tec.Periodo>=202001
		
		WHERE emi.idpaquete NOT IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610)
		AND emi.idtipovehiculo IN (3829, 4579)
		AND emi.idtipopoliza = 4013
		AND emi.NipPerfilAgente IN (SELECT distinct 
		   
			age.NipPerfilAgente

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=8

				
		)
		
		) AS emi_tec

ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente
	


	

GROUP BY emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente


UNION all

SELECT  'Curso' AS Uso,
		emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		'IDRIVING' AS DescPaquete,
		
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
	  		
	  		WHERE ag_cur.CursoId=15

				
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

		FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc  AS emi
		
		INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
		ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
		AND emi.NumDocumento = tec.NumDocumento
		AND tec.Periodo>=202001
	 
	 	WHERE emi.idpaquete IN (2458, 2459, 2529, 2530, 2607, 2608, 2609, 2610)
	 	AND emi.NipPerfilAgente IN (	SELECT distinct 
		   age.NipPerfilAgente
	 

	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=15

			)
	
		) AS emi_tec

	   
ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente
	


GROUP BY emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente
		
