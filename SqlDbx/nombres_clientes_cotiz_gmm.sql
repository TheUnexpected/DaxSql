SELECT *

FROM(
	
	
	SELECT aux.Cliente,
				charindex(' ',aux.Cliente) AS primer_espacio,
				substring(aux.Cliente,1,charindex(' ',aux.Cliente)-1) AS nombre,
			   	substring(aux.Cliente,charindex(' ',aux.Cliente)+1,len(aux.Cliente)) AS apellido
	
	FROM (
	
	
		
		SELECT cotiz.Cliente AS Cliente
		
		FROM dbo.TB_DWH_GMMCotizaciones AS cotiz
	
	
	) AS aux
	
	WHERE len(nombre)>3
	OR len(apellido)>3
	
) aux2

WHERE

