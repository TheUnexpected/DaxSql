
SELECT  DISTINCT sso_eje.*, sso_eje2.*, sso_eje3.*

FROM Cv360.Tbl_CatPathJerarquia AS jer


LEFT JOIN (
		SELECT cat_jer.SSOPerfil*1000+2 AS SSO, 
				cat_jer.Nombre, 
				jer_niv.Descripcion
		
		FROM Cv360.Tbl_CatJerarquia AS cat_jer
		
		LEFT JOIN  Cv360.Tbl_CatNivelesJerarquia AS jer_niv
		ON jer_niv.IdNivel=cat_jer.IdNivel
		
		WHERE cat_jer.IdNivel=2
	 	and cat_jer.SSOPerfil!=0
	 	
) AS sso_eje
ON sso_eje.SSO=jer.IdUsuarioN2

LEFT JOIN (
		SELECT cat_jer.SSOPerfil*1000+3 AS SSO, 
				cat_jer.Nombre, 
				jer_niv.Descripcion
		
		FROM Cv360.Tbl_CatJerarquia AS cat_jer
		
		LEFT JOIN  Cv360.Tbl_CatNivelesJerarquia AS jer_niv
		ON jer_niv.IdNivel=cat_jer.IdNivel
		
		WHERE cat_jer.IdNivel=3
	 	and cat_jer.SSOPerfil!=0
	 	
) AS sso_eje2
ON sso_eje2.SSO=jer.IdUsuarioN3


LEFT JOIN (
		SELECT cat_jer.SSOPerfil*1000+4 AS SSO, 
				cat_jer.Nombre, 
				jer_niv.Descripcion
		
		FROM Cv360.Tbl_CatJerarquia AS cat_jer
		
		LEFT JOIN  Cv360.Tbl_CatNivelesJerarquia AS jer_niv
		ON jer_niv.IdNivel=cat_jer.IdNivel
		
		WHERE cat_jer.IdNivel=4
	 	and cat_jer.SSOPerfil!=0
	 	
) AS sso_eje3
ON sso_eje3.SSO=jer.IdUsuarioN4

WHERE sso_eje.SSO IS NOT NULL
AND sso_eje2.SSO IS NOT null
