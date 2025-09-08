SELECT ap.Periodo,
		ofi.NombreOficina,
		ap.NipAgente,
		age.NombreAgente,
		ap.NumPoliza,
		aseg.NombreAsegurado,
		
		
		sum(ap.PrimaNetaVigencia) AS emitida
		 
FROM TB_BI_VgcaFactEmisionDoc AS ap

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=ap.NipAgente

LEFT JOIN tb_bi_dimoficina AS ofi 
on ofi.IdOficina=age.IdOficina

LEFT JOIN TB_BI_DimAsegurado AS aseg
ON aseg.CveAsegurado=ap.CveAsegurado

WHERE ap.Periodo BETWEEN 202401 AND 202505
AND ofi.NombreOficinaComercial='Pachuca'

GROUP BY ap.Periodo,
		ap.NipAgente,
		age.NombreAgente,
		ofi.NombreOficina,
		ap.NumPoliza,
		aseg.NombreAsegurado
		
		
HAVING sum(ap.PrimaNetaVigencia)!=0