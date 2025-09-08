SELECT flot.*,

		CASE WHEN renov.NumPolizaAnterior > 0 THEN 'Si'
			ELSE 'No' END AS renovacion		
	
FROM (	
	SELECT base.IdOficina,
			base.numPoliza,
			base.NumCertificado,
			CAST(concat(LEFT(base.FechaFinVigencia,4),substring(CONVERT(char(8), base.FechaFinVigencia, 112),5,2)) AS INTEGER) AS periodo_a_renovar,
			base.NipPerfilagente,
			base.NumeroSerie,
			base.idantiguedadAgente,
			arm.descArmadora,
			frec.DescFrecuenciaPago,
			paq.DescPaquete,
			tv.DescTipoVehiculo,
			ton.descTonelaje,
			uso.DescUsoCNSF,
			vehi.DescMarcaVehiculo,
			zona.DescZonaCirculacion,
			base.modelovehiculo,
			riesgo.DescRiesgoCarga,
			aseg.TipoPersona AS T_Persona_Aseg,
			aseg.NombreEstado AS Estado_Aseg,
			--aseg.NipAgrupador,
			cis.NombreNegocio,
			cis.RFC,
			--aseg.NivelRiesgoCliente,
			conserv.DescGrupoConservacion,
			base.Antiguedad,
			tp.DescTipoPoliza,
			ts.DescTipoServicio,
			--base.AñoPoliza,
			mod.DescModeloNegocio,
			neg.DescTipoNegocio,
			cd.DescCanaldeDistribucion,	
				
			sum(tec.UnidadesEmitidasReales) AS Unidades,
			sum(tec.Primanetapropiasincoaseguro) AS Emitida,
			sum(tec.Ocurrido) AS Ocurrido,
			sum(tec.PrimaNetapropiaemitidadevengada) AS devengada,
			sum(tec.PrimaTarifa) AS Tarifa,
			sum(tec.NumSiniestro) AS Siniestros
		
	FROM  ( 
			
			SELECT doc.NumCompletoCotizacion,
					doc.NumDocumento,
					doc.IdOficina,
					doc.numPoliza,
					doc.NumCertificado,
					doc.FechaFinVigencia,
					doc.NipPerfilagente,
					doc.idantiguedadAgente,
					doc.idarmadoravehiculo,
					doc.idfrecuenciapago,
					doc.idpaquete,
					doc.idtipovehiculo,
					doc.IdTonelaje,
					doc.IdUsovehiculo,
					doc.idvehiculo,
					doc.idzonacirculacion,
					doc.modelovehiculo,
					doc.idriesgocarga,
					(SELECT doc2.cveasegurado FROM TB_BI_AutrFactEmisionDoc AS doc2 WHERE doc2.Numcompletocotizacion=doc.Numcompletocotizacion AND doc2.Numdocumento=0)  AS CveAsegurado,
					doc.Idtipoconservacion,
					doc.Antiguedad,
					doc.NumeroSerie	,
					doc.IdTipoPoliza,
					doc.IdCanalVenta,
					doc.IdTipoServicio,
					doc.IdModeloNegocio,
					doc.IdTipoNegocio,
					doc.IdCanalDistribucion
					--doc.AñoPoliza
					
			FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS doc
			WHERE doc.IdTipoPoliza != 4013
			AND CONVERT(DATE, doc.FechaFinVigencia, 23)>='2023-01-01'
			AND CONVERT(DATE, doc.FechaFinVigencia, 23)<='2024-08-31'
			
			) AS base
						
	INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
	ON base.NumCompletoCotizacion=tec.NumCompletoCotizacion
	AND base.NumDocumento=tec.NumDocumento
	--and tec.Periodo>=202401
	
	LEFT JOIN TB_BI_DimCatArmadora AS arm
	ON arm.IdArmadora=base.IdArmadoravehiculo
	
	LEFT JOIN DMSin.Tb_BI_CatFrecuenciaPago AS frec
	ON frec.IdFrecuenciaPago=base.Idfrecuenciapago
	
	LEFT JOIN tb_bi_dimpaquete AS paq
	ON paq.IdPaquete=base.Idpaquete
	
	LEFT JOIN TB_BI_DimTipoVehiculo AS tv
	ON tv.IdTipoVehiculo=base.idtipovehiculo
	
	LEFT JOIN TB_BI_DimCatTonelaje AS ton
	ON ton.IdTonelaje=base.idtonelaje
	
	LEFT JOIN TB_BI_DimUsoVehiculo AS uso
	ON uso.idusovehiculo=base.idUsovehiculo
	
	LEFT JOIN VW_BI_DimVehiculo AS vehi
	ON vehi.IdVehiculoInterno=base.idvehiculo
	
	LEFT JOIN TB_BI_DimZonaCirculacion AS zona
	ON zona.IdZonaCirculacion=base.Idzonacirculacion
	
	LEFT JOIN tb_bi_dimriesgocarga AS riesgo
	ON riesgo.IdRiesgoCarga=base.idriesgocarga
	
	LEFT JOIN TB_BI_AutrCisMaestroCotizacion AS cm
	ON cm.NumCompletoCotizacion=base.numcompletocotizacion
	
	LEFT JOIN TB_BI_AutrCisMaestroNegocio AS cis
	ON cis.IdCisMaestro=cm.IdCisMaestro
	AND cis.VersionCisMaestro=cm.VersionCisMaestro

	LEFT JOIN TB_BI_DimAsegurado AS aseg
	ON aseg.CveAsegurado=base.Cveasegurado
	
	
	LEFT JOIN TB_Bi_DimTipoConservacion AS conserv
	ON conserv.IdTipoConservacion=base.Idtipoconservacion
	
	LEFT JOIN tb_bi_dimtipopoliza AS tp
	ON tp.IdTipoPoliza=base.Idtipopoliza
	
	LEFT JOIN tb_bi_dimtiposervicio AS ts
	ON ts.IdTipoServicio=base.idtiposervicio
	
	LEFT JOIN tb_bi_dimmodelonegocio AS mod
	ON mod.IdModeloNegocio=base.idmodelonegocio
	
	LEFT JOIN tb_bi_dimtiponegocio AS neg
	ON neg.IdTipoNegocio=base.Idtiponegocio
	
	LEFT JOIN tb_bi_dimcanaldedistribucion AS cd
	ON cd.IdCanalDeDistribucion=base.IdcanalDistribucion
	
	GROUP BY base.IdOficina,
			base.numPoliza,
			base.NumCertificado,
		   	CAST(concat(LEFT(base.FechaFinVigencia,4),substring(CONVERT(char(8), base.FechaFinVigencia, 112),5,2)) AS INTEGER),
			base.NipPerfilagente,
			base.NumeroSerie,
			base.idantiguedadAgente,
			arm.descArmadora,
			frec.DescFrecuenciaPago,
			paq.DescPaquete,
			tv.DescTipoVehiculo,
			ton.descTonelaje,
			uso.DescUsoCNSF,
			vehi.DescMarcaVehiculo,
			zona.DescZonaCirculacion,
			base.modelovehiculo,
			riesgo.DescRiesgoCarga,
			aseg.TipoPersona,
			aseg.NombreEstado,
			--aseg.NipAgrupador,
			cis.NombreNegocio,
			cis.RFC,
			--aseg.NivelRiesgoCliente,
			conserv.DescGrupoConservacion,
			base.Antiguedad,
			tp.DescTipoPoliza,
			ts.DescTipoServicio,
			--base.AñoPoliza,
			mod.DescModeloNegocio,
			neg.DescTipoNegocio,
			cd.DescCanaldeDistribucion
			
	HAVING sum(tec.UnidadesEmitidasReales)>0

) AS flot

LEFT JOIN 
(


	SELECT base.NumPolizaAnterior,
			base.IdOficina,

		sum(tec.UnidadesEmitidasReales) AS Unidades
	
	
	FROM  ( SELECT *
			FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS doc
			WHERE doc.IdTipoPoliza != 4013
			AND doc.FechaTransaccion>=20220101
			) AS base
						
	INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
	ON base.NumCompletoCotizacion=tec.NumCompletoCotizacion
	AND base.NumDocumento=tec.NumDocumento
	and tec.Periodo>=202201
	
	
	
	GROUP BY base.NumPolizaAnterior,
				base.idoficina

	HAVING sum(tec.UnidadesEmitidasReales)>0
	
) AS renov

ON renov.NumPolizaAnterior=flot.numPoliza
AND renov.IdOficina=flot.IdOficina