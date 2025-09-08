
SELECT tec.Periodo,
		tpol.DescGrupoTipoPoliza,
		clas.SubclasificacionProducto,
		uso.DescUsoCNSF,
		tv.DescTipoVehiculo,

		sum(tec.PrimaNetaPropiaSinCoaseguro) AS Emitida,
		sum(tec.Ocurrido) AS Ocurrido,
		--sum(tec.CostoSiniestroOcurrido) AS costo_sin,
		sum(tec.PrimaNetaPropiaEmitidaDevengada) AS Devengada,
		--sum(tec.Ocurrido)/sum(tec.PrimaNetaPropiaEmitidaDevengada) AS sin_tec,
		--sum(tec.CostoSiniestroOcurrido)/sum(tec.PrimaNetaPropiaEmitidaDevengada) AS sin_tot,
		sum(tec.RiesgoVigente) AS PV
		--sum(tec.UnidadesExpuestasMes) AS Unidades_Expuestas,
		--sum(tec.UnidadesEmitidasReales) AS Unidades


FROM HDI_DWH.dbo.TB_BI_AutrFactEmisionDoc AS emi


INNER join HDI_DWH.dbo.TB_BI_AutrBase2Tecnica AS tec
ON tec.NumCompletoCotizacion=emi.NumCompletoCotizacion
AND tec.NumDocumento=emi.NumDocumento
AND tec.Periodo BETWEEN 202101 AND 202112

--inner JOIN TB_BI_DimAsegurado AS aseg
--ON aseg.CveAsegurado=emi.CveAsegurado
--AND aseg.IdEstado=31

LEFT JOIN TB_BI_DimTipoPoliza AS tpol
ON tpol.IdTipoPoliza=emi.IdTipoPoliza

LEFT JOIN VW_Bi_DimCLasificacionProductos AS clas
ON clas.IdClasificacionProducto=emi.IdClasificacionProducto
AND clas.IdSubclasificacionProducto=emi.IdSubclasificacionProducto

LEFT JOIN TB_BI_DimUsoVehiculo AS uso
ON uso.IdUsoVehiculo=emi.IdUsoVehiculo

LEFT JOIN TB_BI_DimTipoVehiculo AS tv
ON tv.IdTipoVehiculo=emi.IdTipoVehiculo

WHERE emi.IdEstadoCliente=31
--AND clas.IdClasificacionProductoUnico!=202


GROUP BY  tec.Periodo,
			tpol.DescGrupoTipoPoliza,
			clas.SubclasificacionProducto,
			uso.DescUsoCNSF,
			tv.DescTipoVehiculo
