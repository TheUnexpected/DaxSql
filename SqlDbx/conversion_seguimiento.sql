SELECT
	LEFT(vista.FechaCotizacion,6) AS Periodo,
	cv.descmarcavehiculo,
    cp.Estado,
    cp.Municipio,
    ofi.DescDireccionComercial,
    ofi.DescSubdireccionComercial,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    age.NipPerfilAgente,
    age.NombreAgente,
    
    sum(vista.PLZ) AS Polizas,
    count(vista.NumCompletoCotizacion) AS Cotizaciones,
    sum(vista.PrimaTarifa) AS Tarifa
    
FROM Dshd.Vw_bi_GrlEmiCotizaciones_Estadistica AS vista

inner join VW_BI_DimVehiculo as cv 
on cv.IdVehiculoInterno = vista.IdVehiculoInterno

left join  TB_BI_CatCodigoPostal AS cp
ON cp.CodigoPostal=vista.CodigoPostalPoliza

inner join TB_BI_DimOficina AS ofi 
ON ofi.IdOficina = vista.IdOficina 

LEFT JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=vista.NipPerfilAgente

WHERE LEFT(vista.FechaCotizacion,6)>= 202201

GROUP BY LEFT(vista.FechaCotizacion,6),
	cv.descmarcavehiculo,
    cp.Estado,
    cp.Municipio,
    ofi.DescDireccionComercial,
    ofi.DescSubdireccionComercial,
    ofi.NombreOficinaComercial,
    ofi.NombreOficina,
    age.NipPerfilAgente,
    age.NombreAgente