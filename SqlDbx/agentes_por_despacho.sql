
SELECT age.NipAgente,
		age.NipPerfilAgente,
		age.NombreAgente,
		age.IdOficina,
		ofi.NombreOficinaComercial,
		ofi.NombreOficina,
		age.DescEstatusAgente,
		agdesp.NombreDespacho,
		agdesp.IdDespacho,
		agdesp.TipoDespacho
		

FROM TB_BI_DimAgente AS age

LEFT JOIN tb_bi_dimOficina AS ofi
ON ofi.IdOficina=age.IdOficina

LEFT JOIN  TB_BI_DimAgenteDespacho AS agdesp 
ON agdesp.NipAgente=age.NipPerfilAgente

WHERE agdesp.IdDespacho=915
--OR age.IdOficina=818


		