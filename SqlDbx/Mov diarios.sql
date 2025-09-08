
SELECT Emi.IdOficina,
		Emi.NumPoliza,
		Emi.NipPerfilAgente,
		doc.DescTipoDocumento,
		doc.DescGrupoDocumento,
		doc.DescTipoMovimiento,
		emi.FechaTransaccion,
		aseg.NombreAsegurado,
		
		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Prima
		
		



FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS Emi

INNER JOIN hdi_dwh.dbo.Tb_Bi_AutrBase2Tecnica AS Tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento

LEFT JOIN TB_BI_DimTipoDocumento AS doc
ON doc.IdTipoDocumento=Emi.IdTipoDocumento

LEFT JOIN tb_bi_dimasegurado AS aseg
ON aseg.CveAsegurado=emi.CveAsegurado

WHERE Emi.FechaTransaccion=(SELECT concat(LEFT(sysdatetime(),4),substring(cast(sysdatetime() AS VARCHAR),6,2),substring(cast(sysdatetime() AS VARCHAR),9,2))-2)


GROUP BY Emi.IdOficina,
		Emi.NumPoliza,
		Emi.NipPerfilAgente,
		doc.DescTipoDocumento,
		doc.DescGrupoDocumento,
		doc.DescTipoMovimiento,
		emi.FechaTransaccion,
		aseg.NombreAsegurado