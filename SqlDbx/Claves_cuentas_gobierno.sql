SELECT base.Anio,
		base.Direccion,
		base.Subdireccion,
		base.NombreOficinaComercial,
		base.nombreasegurado, 
		base.nipPerfilagente, 
		base.nombreagente,
		base. Giro,
		round(base.Emitida_Autos,0) AS Emitida,
		
		rank() OVER (PARTITION BY nipperfilagente ORDER BY Emitida_Autos desc) AS Rank

FROM  (	
	
	SELECT --CAST(LEFT(emicob.FechaTransaccion,4) AS INTEGER) AS Anio,
			FORMAT(CAST(emi.FechaFinVigencia AS DATE), 'yyyy-MM') AS Mes_Vencimiento,
			ase.NombreAsegurado,
			ase.DescOcupacionOGiro AS Giro,
			--ase.EntidadGubernamental,
			emi.NipPerfilAgente,
			age.NombreAgente,
			ofi.DescDireccionComercial AS Direccion,
			ofi.DescSubdireccionComercial AS Subdireccion,
			ofi.NombreOficinaComercial,
			
		     sum(emicob.PrimaNeta) AS Emitida_Autos
		   
	FROM TB_BI_AutrFactEmisionCob AS emicob
	
	
	INNER JOIN TB_BI_DimCobertura AS cob
	ON cob.IdCobertura=emicob.IdCobertura
	AND cob.DescTipoCobertura='Cobertura Propia'
	AND cob.IdLineaNegocio=4
	
	LEFT JOIN HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi
	ON emi.NumCompletoCotizacion=emicob.NumCompletoCotizacion
	AND emi.NumDocumento=emicob.NumDocumento	
	
	LEFT JOIN tb_bi_dimasegurado AS ase
	ON ase.CveAsegurado=emi.CveAsegurado
	
	
	LEFT JOIN tb_bi_dimagente AS age
	ON age.NipPerfilAgente=emi.NipPerfilAgente
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=age.IdOficina
	
	--WHERE emicob.FechaTransaccion BETWEEN 20220101 AND 20231231 --aquí mueven el día
	--where age.NombreAgente LIKE '%HDI%'
	WHERE  ase.EntidadGubernamental=1
	AND CAST(emi.FechaFinVigencia AS DATE) BETWEEN '2025-04-01' AND '2025-07-31'
	
	
	GROUP BY --CAST(LEFT(emicob.FechaTransaccion,4) AS INTEGER),
			FORMAT(CAST(emi.FechaFinVigencia AS DATE), 'yyyy-MM'),
			ase.NombreAsegurado,
			--ase.EntidadGubernamental,
			emi.NipPerfilAgente,
			age.NombreAgente,
			ase.DescOcupacionOGiro,
			ofi.DescDireccionComercial,
			ofi.DescSubdireccionComercial,
			ofi.NombreOficinaComercial
		
) AS base


ORDER BY NipPerfilAgente, rank