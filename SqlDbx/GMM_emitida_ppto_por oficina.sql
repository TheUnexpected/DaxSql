SELECT isnull(base.Periodo,ppto2.periodo) AS Periodo,
		isnull(base.Subdireccion,ppto2.DescSubdireccionComercial) AS Subdireccion,
	isnull(base.OficinaComercial, ppto2.NombreOficinaComercial) AS Oficina_Comercial,
		
		
--SELECT ppto2.Periodo,
  --		ppto2.Descsubdireccioncomercial,
	--	ppto2.NombreOficinaComercial,
			
		sum(base.Emitida_Total) AS Emitida,
		sum(ppto2.Presupuesto) AS PPto

FROM 
(	
	SELECT ppto.Periodo,
			ofi.NombreOficinaComercial,
			ofi.DescSubdireccionComercial,
			
			sum(ppto.PrimaNetaMetaEmision) AS Presupuesto

	FROM tb_bi_dimoficina AS ofi

	LEFT JOIN  Dshd.VW_DWH_GMMPptoxOficina AS ppto
	ON ofi.IdOficina=ppto.IdOficina
	
	WHERE ppto.Periodo >= 202401
	
	
	GROUP BY ppto.Periodo,
			ofi.NombreOficinacomercial,
			ofi.DescSubdireccionComercial
			
	
	
) AS ppto2



full JOIN 

(
		
	SELECT gmm.Periodo,
		   	ofi.DescSubdireccionComercial AS Subdireccion,
			ofi.NombreOficinaComercial AS OficinaComercial,
			
			sum(gmm.Prima_Total) AS Emitida_Total
	
	FROM Dshd.VW_DWH_GMMPrimaNeta AS gmm
	
	LEFT JOIN tb_bi_dimoficina AS ofi
	ON ofi.IdOficina=gmm.IdOficina
	
	
	WHERE gmm.periodo>=202401
	
	GROUP BY gmm.Periodo,
		   	ofi.DescSubdireccionComercial,
			ofi.NombreOficinaComercial
) AS base




ON ppto2.NombreOficinacomercial=base.oficinacomercial
AND ppto2.Periodo=base.Periodo
AND ppto2.Descsubdireccioncomercial=base.Subdireccion


GROUP BY  isnull(base.Periodo,ppto2.periodo),
		isnull(base.Subdireccion,ppto2.DescSubdireccionComercial) ,
	isnull(base.OficinaComercial, ppto2.NombreOficinaComercial)


HAVING sum(base.Emitida_Total)!=0 OR sum(ppto2.Presupuesto) !=0