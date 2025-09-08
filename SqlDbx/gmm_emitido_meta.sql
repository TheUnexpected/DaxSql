

		SELECT ISNULL(pmas.Anio, ppto.Anio) AS Anio,
				isnull(pmas.Direccion,ppto.Direccion) AS Direccion,
				isnull(pmas.subdireccion, ppto.Subdireccion) AS Subdireccion,
				isnull(pmas.oficina,ppto.oficina) AS Oficina,
				pmas.Emitida,
				ppto.Meta
				
		
		FROM (
		
			SELECT  CAST(LEFT(gmm.Periodo,4) AS INTEGER) AS Anio,
					ofi.DescDireccionComercial AS Direccion,
					ofi.DescSubdireccionComercial AS Subdireccion,
					ofi.NombreOficinaComercial AS Oficina ,
					
					sum(gmm.Prima_Total) AS Emitida
			
			FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm
			
			LEFT JOIN TB_BI_DimAgente AS age
			ON age.nipperfilagente=gmm.NAgente
			
			LEFT JOIN tb_bi_dimoficina AS ofi
			ON ofi.idoficina=age.IdOficina
			
			WHERE (gmm.Periodo BETWEEN 202401 AND 202403  OR gmm.Periodo BETWEEN 202501 AND 202503)
			
			
			GROUP BY CAST(LEFT(gmm.Periodo,4) AS INTEGER),
					ofi.DescDireccionComercial,
					ofi.DescSubdireccionComercial,
					ofi.NombreOficinaComercial 
		) AS pmas
		
		FULL JOIN (
		
		SELECT  CAST(LEFT(ppto_gmm.Periodo,4) AS INTEGER) AS Anio,
				ofi.DescDireccionComercial AS Direccion,
				ofi.DescSubdireccionComercial AS Subdireccion,
				ofi.NombreOficinaComercial AS Oficina ,
				
				sum(ppto_gmm.PrimaNetaMetaEmision) AS Meta
		
		FROM dbo.TB_DWH_GMMPresupuestoMetaOficina AS ppto_gmm  
		
		LEFT JOIN tb_bi_dimoficina AS ofi
		ON ofi.IdOficina=ppto_gmm.IdOficina	
		
		WHERE (ppto_gmm.Periodo BETWEEN 202401 AND 202403  OR ppto_gmm.Periodo BETWEEN 202501 AND 202503)
		
		GROUP BY  CAST(LEFT(ppto_gmm.Periodo,4) AS INTEGER),
				ofi.DescDireccionComercial,
				ofi.DescSubdireccionComercial,
				ofi.NombreOficinaComercial
		) AS ppto
		
		ON ppto.Anio=pmas.Anio
		AND ppto.Oficina=pmas.Oficina
		AND ppto.subdireccion=pmas.subdireccion
