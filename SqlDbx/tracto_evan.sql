SELECT  'Curso' AS Uso,
		emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		emi_tec.DescTipoVehiculo,
		
		round(sum(emi_tec.PrimaNetaPropiaSinCoaseguro),0) AS PrimaSinC,
		sum(emi_tec.UnidadesEmitidasReales) AS Unidades


FROM (
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
	  		
	  		WHERE ag_cur.CursoId=30

				
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
			tv.DescTipoVehiculo,
			tec.PrimaNetaPropiaSinCoaseguro,
			tec.UnidadesEmitidasReales

		FROM HDI_DWH.dbo.TB_BI_autrFactEmisionDoc  AS emi	
		
		INNER JOIN HDI_DWH.dbo.TB_BI_autrBase2Tecnica AS tec
		ON emi.NumCompletoCotizacion = tec.NumCompletoCotizacion
		AND emi.NumDocumento = tec.NumDocumento 
		AND tec.Periodo >= 202001
					
		LEFT JOIN TB_BI_DimTipoVehiculo tv
		ON tv.IdTipoVehiculo=emi.idtipovehiculo
		
		WHERE emi.idtipovehiculo IN (5676, 22809)
		AND emi.NipPerfilAgente IN (	SELECT distinct 
			age.NipPerfilAgente


	   		FROM TB_BI_GrlCursoAgenteAdmon AS ag_cur

	  		LEFT JOIN  TB_BI_ACAGrlAdmonCurso AS cur
	  		ON cur.CursoId=ag_cur.CursoId


	  		left JOIN HDI_DWH.dbo.TB_BI_DimAgente AS age
	  		ON age.NipAgente=ag_cur.NipAgente
	  		
	  		WHERE ag_cur.CursoId=30)

			
			) AS emi_tec
			
ON agentes.NipPerfilAgente=emi_tec.NipPerfilAgente



GROUP BY emi_tec.Periodo,
		agentes.Primer_Curso,
		agentes.IdOficina,
		agentes.NipAgente,
		agentes.NipPerfilAgente,
		emi_tec.DescTipoVehiculo