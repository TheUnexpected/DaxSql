SELECT age.NipPerfilAgente, 
		age.NipAgente, 
		age.NumPerfil, 
		age.NombreAgente, 
		age.IdOficina, 
		age.FechaAlta, 
		age.IdTipoPersona, 
		age.DescTipoPersona, 
		age.IdPerfilEjecutivo,
		eje.NombreEjecutivo, 
		age.IdEstatusAgente, 
		age.DescEstatusAgente, 
		age.IdEstatusPerfil, 
		age.DescEstatusPerfil, 
		age.ParticipaBono, 
		age.NuevaRecluta, 
		age.IdCanalComercial, 
		age.DescCanalComercial, 
		age.DescripcionPerfil, 
		age.IdTipoAgente, 
		tage.DescTipoAgente,
		age.IdEstado, 
		age.PorcentajeUDI,
		nest.CanalVenta AS Nest

FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimejecutivo AS eje
ON eje.IdEjecutivo=age.IdPerfilEjecutivo

LEFT JOIN TB_BI_DimTipoAgente AS tage
ON tage.IdTipoAgente=age.IdTipoAgente

LEFT JOIN TB_BI_DimProgramasAgentes AS nest
ON nest.NipPerfilAgente=age.NipPerfilAgente



