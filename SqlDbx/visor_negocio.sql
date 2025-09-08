SELECT  sol.IdOT,
	tipo_sol.DescTipoSolicitudOT,
	sol.TiempoAltaOt,
	esta.DescripcionEstatusCotiz AS Estatus,
	otmas.IdOficina,
	--sol.IdOficinaEmision,
	ofi.NombreOficinaComercial,
	cat.DescTipoDocumentoOT AS Documento,
	otmas.RfcMasivo,
	otmas.UnidadesCotizadas,
	prog.DescripcionPrograma,
	--sol.NumPoliza,
	otmas.EstatusValidacion, 
	otmas.FechaValidacion,
	otmas.EstatusClaveteo,
	otmas.FechaClaveteo,
	--sol.IdEstatusSuscripcionManual,
	st_sus.DescripcionEstatusSuscripcion,
	sol.TiempoSuscripcion,
	rech.DescripcionCausaRechazo,
	sol.ComentarioOT,
	--sol.UsusarioSuscripcion AS Suscriptor,

	concat(eje.NombreEjecutivo,' ',eje.IdEjecutivo) AS Ejecutivo, 
	sol.NipCliente AS NipPerfilAgente,
	concat(age.NombreAgente, ' ',age.NipPerfilAgente) AS Agente,
	otmas.PrimaNetaOtorgada, 
	otmas.PrimaNetaObjetivo,
	otmas.Prima_Neta_Revire,
	--cot.DescripcionEstatusCotiz,
	otmas.NumPoliza,
	otmas.POLIZAS,
   	--aux.Agente_emision,
	--aux.IdPerfilEjecutivo,
   	--aux.Conservacion,
   	otmas.Suscriptor, 
   	otmas.Numero_Revire, 
   	otmas.Fecha_Solicitud_Revire, 
   	otmas.Fecha_revire, 
   	otmas.Usuario_Revire,
   	sol.TiempoEmision,
   	aux.Fecha_emision,
	aux.Emitida,
   	otmas.CausaPerdida,
   	otmas.FechaRegistroPerdida,
   	--otmas.CIA,
   	cia.DescripcionCIA,
   	otmas.PrimaOtraCia,
   	otmas.Comentario_Validacion, 
   	--otmas.Causa_Rechazo_Validacion,
   	rech2.DescripcionCausaRechazo AS Causa_Rechazo_Validacion,
   	ori.DescOrigenOT,
   	--otmas.IdEstatus,
   	--st_sus.DescripcionEstatusSuscripcion,
   	com_sus.DescripcionComentarioSusc
   	--otmas.IdEstatusSuscripcion,
   	--ofi.DescSubdireccionComercial,
   	--sol.IdCausaRechazo

From DWH.TB_BI_GrlFactOTSolicitud AS sol

LEFT JOIN dbo.Tb_BI_DimTipoDocumentoOT AS cat
ON cat.IdTipoDocumentoOT  = sol.IdTipoDocumento
	
LEFT JOIN TB_dwh_CatEstatusCotizOt AS esta
ON esta.IdEstatusCotizacion=sol.IdEstatus
	
LEFT JOIN TB_BI_DimOrigenOT AS origot
ON origot.IdOrigenOt=sol.IdOrigenOT
	

LEFT JOIN DWH.Tb_bi_GrlOTComplementoMasivo AS otmas
ON otmas.IdOT=sol.IdOT

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=sol.IdOficinaEmision


LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=sol.NipCliente


LEFT JOIN tb_bi_dimejecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo

LEFT JOIN TB_BI_DimOrigenOT AS ori
ON ori.IdOrigenOT=sol.IdOrigenOT

LEFT JOIN TB_DWH_CatProgramaOt AS prog
ON prog.IdPrograma=otmas.Programa

LEFT JOIN TB_dwh_CatEstatusSuscripcionOt AS st_sus
ON st_sus.IdEstatusSuscripcion=otmas.IdEstatusSuscripcion

LEFT JOIN TB_dwh_CatCausaRechazoOt AS rech
ON rech.IdCausaRechazo=sol.IdCausaRechazo

--LEFT JOIN TB_dwh_CatEstatusCotizOt AS cot
--ON cot.IdEstatusCotizacion=otmas.Estatus_Cotizacion

LEFT JOIN TB_dwh_CatCIAOt AS cia
ON cia.IdCIA=otmas.CIA

LEFT JOIN TB_dwh_CatEstatusNegocio AS st
ON st.IdEstatus=otmas.IdEstatus

LEFT JOIN TB_dwh_CatCausaRechazoOt AS rech2
ON rech2.IdCausaRechazo=otmas.Causa_Rechazo_Validacion

LEFT JOIN TB_dwh_CatComentarioSucripcion AS com_sus
ON com_sus.IdComentarioSuscripcion=otmas.IdComentarioSuscripcion

LEFT JOIN Tb_BI_DimTipoSolicitudOT AS tipo_sol
ON tipo_sol.IdTipoSolicitudOT=sol.idtiposolicitud

LEFT JOIN 
	(SELECT emi.IdOficina,
			emi.NumPoliza,
			emi.NipPerfilAgente AS Agente_emision,
			CAST(emi.FechaEmision AS DATE) AS Fecha_emision,
			emi.IdPerfilEjecutivo,
			--isnull(con.DescGrupoConservacion,'Nueva') AS Conservacion,
			
			sum(tec.PrimaNeta) AS Emitida

	FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	
	INNER JOIN HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec 
	ON emi.NumCompletoCotizacion=tec.NumCompletoCotizacion
	AND emi.NumDocumento=tec.NumDocumento
	AND tec.Periodo>=202401

	--LEFT JOIN TB_Bi_DimTipoConservacion AS con
	--ON con.IdTipoConservacion=emi.IdTipoConservacion
	
	WHERE emi.IdTipoDocumento=21
	
	GROUP BY emi.IdOficina,
			emi.NumPoliza,
			emi.NipPerfilAgente,
			CAST(emi.FechaEmision AS DATE),
			emi.IdPerfilEjecutivo
			--isnull(con.DescGrupoConservacion,'Nueva') 
			
  
				
	) AS aux
	
ON concat(aux.Idoficina,aux.NumPoliza)=concat(otmas.IdOficina,otmas.NumPoliza)
	

WHERE  sol.IdLineaNegocio=6
AND sol.TiempoAltaOt>='2024-10-01'
AND sol.IdOt NOT IN (531783)
--AND otmas.EstatusValidacion IS NOT null
--AND sol.eliminado=0

--AND sol.IdOT IN (284970)
--AND sol.NumPoliza= 200058