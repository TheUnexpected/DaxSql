SELECT 	cobr.Periodo,
	ofi.NombreOficinaComercial,
	ofi.NombreOficina,
	cobr.NumPoliza,
	CAST(CAST(cobr.FechaPago AS VARCHAR) AS DATE) AS Fecha_Pago,
	concat(age.NipPerfilAgente, ' - ', age.NombreAgente) AS Agente,
	mon.DescMoneda, 
	
	
	sum(cobr.PrimaNetaPropiaPagada) AS Pagada_propia,
   	sum(cobr.PrimaNPPagadaConsolidada) AS Pagada_propia_Consolidada,
   	sum(cobr.PrimaNeta) AS Pagada_neta,
   	sum(cobr.PrimaNetaConsolidada) AS Pagada_neta_consolidada
  
FROM dbo.VW_BI_DanFactCobrado AS cobr

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=cobr.IdOficina

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=cobr.NipPerfilAgente

LEFT JOIN DMSin.Tb_BI_CatMoneda AS mon
ON mon.IdMoneda=cobr.IdMoneda


WHERE cobr.fechapago BETWEEN 20250101 AND 20250115 --aquí se cambia la fecha
AND ofi.IdOficina=782
	
GROUP BY cobr.Periodo,
	ofi.NombreOficinaComercial,
	ofi.NombreOficina,
	cobr.NumPoliza,	
	CAST(CAST(cobr.FechaPago AS VARCHAR) AS DATE),
	concat(age.NipPerfilAgente, ' - ', age.NombreAgente),
	mon.DescMoneda