SELECT age.NipPerfilAgente, 
		age.NipAgente, 
		age.NumPerfil, 
		age.NombreAgente, 
		age.IdOficina, 
		age.FechaAlta,
		age.DescTipoPersona,  
		age.DescEstatusAgente,  
		age.RFC, age.Cambio,   
		age.DescCanalComercial, 
		ta.DescTipoAgente,
		isnull((SELECT min(agd.IdDespacho) FROM TB_BI_DimAgenteDespacho agd WHERE agd.NipAgente=age.NipAgente),0)  AS Min_Despacho


FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimtipoagente AS ta
ON ta.IdTipoAgente=age.IdTipoAgente


