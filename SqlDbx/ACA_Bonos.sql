SELECT Pmas.Periodo,
	 	Pmas.NipAgente,
		Pmas.IdDespacho,
		Pmas.IdLineaNegocio,
		Pmas.DescGpoBono,
		Pmas.NombreDespacho,
		Pmas.TipoDespacho,
		Pmas.NombreOficina,
		Pmas.Pagada,
		Pmas.Produccion,
		Pmas.Devengada,
		Pmas.Siniestros,
		Modulos.Pagada_Modulos,
		Modulos.Devengada_Modulos,
		Modulos.Siniestros_Modulos


FROM (

		SELECT aca.Periodo,
				aca.NipAgente,
				--aca.NipPerfilAgente,
				aca.IdDespacho,
				aca.IdLineaNegocio,
				aca.IdGpoBono,
				bono.DescGpoBono,
				desp.NombreDespacho,
				desp.TipoDespacho,
				ofi.NombreOficina,
		
				sum(aca.PrimaNetaPagada) AS Pagada,
				sum(aca.PrimaNetaProduccion) AS Produccion,
				sum(aca.PrimaNetaDevengada) AS Devengada,
				sum(aca.Siniestros) AS Siniestros
				
		FROM dbo.VW_Bi_grlACAPrimaBonoxAgente as aca
		
		LEFT JOIN dbo.TB_BI_DimGpoBono AS bono
		ON bono.IdGpoBono=aca.IdGpoBono
		
		LEFT JOIN TB_BI_DimAgenteDespacho AS desp
		ON desp.NipAgente=aca.NipAgente
		AND desp.IdDespacho=aca.IdDespacho
		
		LEFT JOIN tb_bi_dimoficina AS ofi
		ON ofi.IdOficina=aca.IdOficina

		
		
		WHERE aca.Periodo BETWEEN 202011 AND 202210
		--AND aca.IdGpoBono = 199 -- este es autos residentes
		--AND aca.IdGpoBono = 201 -- este es daños
		--AND aca.IdGpoBono = 204 -- este es transportes
		AND aca.IdGpoBono IN (199,201,204)
		
		
		GROUP BY aca.Periodo,
				aca.NipAgente,
				--aca.NipPerfilAgente,
				aca.IdDespacho,
				aca.IdLineaNegocio,
				aca.IdGpoBono,
		  		bono.DescGpoBono,
				desp.NombreDespacho,
				desp.TipoDespacho,
			    ofi.NombreOficina
		  		
) AS Pmas
		
LEFT JOIN (

		SELECT aca.Periodo,
		aca.NipAgente,
		--aca.NipPerfilAgente,
		aca.IdDespacho,
		aca.IdLineaNegocio,
		aca.IdGpoBono,
		--bono.DescGpoBono,

		sum(aca.PrimaNetaPagada) AS Pagada_Modulos,
		--sum(aca.PrimaNetaProduccion) AS Produccion_Modulos,
		sum(aca.PrimaNetaDevengada) AS Devengada_Modulos,
		sum(aca.Siniestros) AS Siniestros_Modulos
		
		FROM dbo.VW_BI_GrlInfoModuloxAgente as aca
		
		LEFT JOIN dbo.TB_BI_DimGpoBono AS bono
		ON bono.IdGpoBono=aca.IdGpoBono
		
		
		WHERE aca.Periodo BETWEEN 202011 AND 202210
		--AND aca.IdGpoBono = 199 -- este es autos residentes
		--AND aca.IdGpoBono = 201 -- este es daños
		--AND aca.IdGpoBono = 204 -- este es transportes
		AND aca.IdGpoBono IN (199,201,204)
		
		
		GROUP BY aca.Periodo,
				aca.NipAgente,
				--aca.NipPerfilAgente,
				aca.IdDespacho,
				aca.IdLineaNegocio,
				aca.IdGpoBono
		  		--bono.DescGpoBono
		  		
) AS modulos 

ON modulos.Periodo=Pmas.Periodo
AND modulos.NipAgente=Pmas.NipAgente
		--aca.NipPerfilAgente,
and	modulos.IdDespacho=Pmas.IdDespacho
AND modulos.IdLineaNegocio=Pmas.IdLineaNegocio
and	modulos.IdGpoBono=Pmas.IdGpoBono
				