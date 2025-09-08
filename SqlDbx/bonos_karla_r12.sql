SELECT aca.Periodo, aca.NipAgente, aca.NipPerfilAgente, aca.IdDespacho, aca.idgpobono, aca.PrimaNetaPagadaRolling, aca.PrimaNetaProduccionRolling,*
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca
WHERE aca.Periodo = 202308
AND aca.IdGpoBono IN (199)
AND aca.NipPerfilAgente=92549


---------------------------------

SELECT aca.periodo, 
		aca.NipAgente, 
		aca.idgpobono, 
		aca.IdDespacho,
		bono.DescGpoBono,
		sum(aca.PrimaNetaPagada) AS PrimaNetaPagada, 
		sum(aca.PrimaNetaProduccion) AS PrimaNetaProduccion
		
FROM dbo.VW_Bi_grlACAPrimaBonoxAgente aca

inner JOIN dbo.TB_BI_DimGpoBono AS bono
ON bono.IdGpoBono=aca.IdGpoBono
AND bono.IdGpoBono IN (199)--,201,608,609,933


WHERE aca.Periodo BETWEEN 202209 AND 202308

AND aca.NipPerfilAgente=92549


GROUP BY aca.Periodo, 
			aca.NipAgente, 
			aca.idgpobono,
			aca.IdDespacho,
			bono.DescGpoBono
			
ORDER BY aca.IdGpoBono, aca.NipAgente, aca.Periodo