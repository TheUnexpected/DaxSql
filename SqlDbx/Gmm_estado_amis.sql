SELECT gmmN.FechaTransaccion,
		gmmN.IdOficina, 
		catII.Nombreestado AS Estado_asegurado, 
	   
		
	   	sum(gmmN.PrimaNeta) AS Prima_Emitida


FROM TB_DWH_GMMEmisionDoc AS gmmN

LEFT JOIN (

	SELECT DISTINCT gmm.NPoliza AS Poliza_HDI,
		gmm.PolSocioComercial AS NumPoliza,
		Cli_est.NombreAsegurado,
		cli_est.NombreEstado
		

	FROM TB_DWH_GMMEmitidoAcumulado_CargaDiaria AS gmm
	
	LEFT JOIN (
		
		SELECT cli.NipAgrupador,
			cli.IdEstado,
			cli.NombreEstado,
			cli.NombreAsegurado
			
		FROM TB_BI_DimAsegurado AS cli		
				
		
		INNER JOIN (
			
				SELECT aseg.NipAgrupador,
						max(aseg.IdAsegurado) AS Id
				
				FROM TB_BI_DimAsegurado AS aseg
				
				GROUP BY aseg.NipAgrupador
		
		) AS cat
		
		ON cat.NipAgrupador=cli.NipAgrupador
		AND cat.Id=cli.IdAsegurado
	
	) AS cli_est
	
	ON cli_est.NipAgrupador=gmm.Id_Cliente
	
) AS catII

ON gmmN.NumPoliza=catII.NumPoliza
AND gmmN.PolizaHDI=catII.Poliza_HDI

group BY gmmN.FechaTransaccion,
		gmmN.IdOficina, 
		catII.Nombreestado 