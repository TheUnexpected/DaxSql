SELECT base.Periodo, age.NipPerfilAgente, age.IdOficina,
		sum(base.Prima_Total) AS Emitida
 
FROM Dshd.VW_DWH_GMMPrimaNeta AS base 
left JOIN tb_bi_dimagente AS age
ON age.NipPerfilAgente=base.NAgente
where periodo >=202501 AND base.Periodo <= 202501
GROUP BY base. Periodo, age.NipPerfilAgente,age.IdOficina
