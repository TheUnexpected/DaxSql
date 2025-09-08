SELECT DISTINCT pjer.IdOficina,
		ofi.DescDireccionComercial AS Direccion,
		ofi.DescSubdireccionComercial AS Subdireccion,
		ofi.NombreOficinaComercial AS Oficina_Comercial,
		ofi.NombreOficina AS Oficina_Operativa,
		jer.SSOPerfil AS SSO_gerente,
		jer.Nombre
		



FROM Cv360.Tbl_CatPathJerarquia AS pjer 


left JOIN Cv360.Tbl_CatJerarquia AS jer
ON jer.IdUsuario=pjer.IdUsuarioN2
AND jer.IdNivel=2

LEFT JOIN tb_bi_dimoficina AS ofi
ON ofi.IdOficina=pjer.IdOficina

WHERE pjer.IdOficina !=0
AND jer.SSOPerfil!=0

ORDER BY pjer.IdOficina