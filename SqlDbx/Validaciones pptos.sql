SELECT sso, count(*)
FROM Dshd.VW_DWH_GmmMetaPrimaEmitidaxEjecutivo
--WHERE CAST(Periodo AS INTEGER)>=202401
GROUP BY SSO

SELECT met_aut.IdPerfilEjecutivo, count(*)
FROM VW_BI_AutrFactMeta AS met_aut
WHERE periodo>=202401
GROUP BY met_aut.IdPerfilEjecutivo


SELECT met_aut.IdPerfilEjecutivo, count(*)
FROM VW_BI_DanFactMeta AS met_aut
WHERE periodo>=202401
GROUP BY met_aut.IdPerfilEjecutivo


SELECT idoficina, count(*)
FROM Dshd.VW_DWH_GMMPptoxOficina
WHERE Periodo>=202401
GROUP BY idoficina


SELECT met_aut.IdOficina, count(*)
FROM VW_BI_AutrFactMetaOficina AS met_aut
WHERE periodo>=202401
GROUP BY met_aut.IdOficina


SELECT met_aut.IdOficina, count(*)
FROM VW_BI_DanFactMetaOficina AS met_aut
WHERE periodo>=202401
GROUP BY met_aut.IdOficina


SELECT sso, count(*)
FROM Dshd.VW_DWH_GmmMetaPagadoxEjecutivo
GROUP BY sso

SELECT sso, count(*)
FROM Dshd.VW_DWH_AutrMetaPagadoxEjecutivo
GROUP BY SSO

SELECT sso, count(*)
FROM Dshd.VW_DWH_DanMetaPagadoxEjecutivo
GROUP BY sso


select idoficina, count(*)
from [Dshd].[VW_DWH_AutrPresupuestoPrimaPagadaxOficina]
GROUP BY idoficina

SELECT idoficina, count(*)
from [Dshd].[VW_DWH_DanPresupuestoPrimaPagadaxOficina]
GROUP BY idoficina


select idoficina, count(*)
from [Dshd].[VW_DWH_GmmPresupuestoPrimaPagadaxOficina]
GROUP BY idoficina
