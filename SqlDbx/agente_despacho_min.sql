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
		isnull(ad.IdDespacho,0) AS IdDespacho, 
		isnull(desp.NombreDespacho,'SinDespacho') AS NombreDespacho ,
		isnull(ad.TipoDespacho,'Agente Individual') AS TipoDespacho,
		CASE WHEN desp.IdEstatusDespacho=216 THEN 'Vigor'
				WHEN desp.IdEstatusDespacho=215 THEN 'Cancelado'
				ELSE  'Sin Despacho' END AS Estatus_Despacho
		

FROM TB_BI_DimAgente AS age

LEFT JOIN (
				SELECT agde.IdDespacho,
						agde.NipAgente,
						agde.TipoDespacho
				
				FROM TB_BI_DimAgenteDespacho agde
				
				INNER JOIN (
				
					SELECT   agd.NipAgente,
								min(agd.IdDespacho) AS Min_Desp
					
					FROM TB_BI_DimAgenteDespacho agd
					
					GROUP BY agd.NipAgente
					
					) AS aux
				ON aux.NipAgente=agde.NipAgente
				AND aux.Min_Desp=agde.IdDespacho
			
		   ) AS ad	
ON ad.NipAgente=age.NipAgente

LEFT JOIN TB_BI_DimDespacho AS desp
ON desp.IdDespacho=ad.IdDespacho

LEFT JOIN tb_bi_dimtipoagente AS ta
ON ta.IdTipoAgente=age.IdTipoAgente

