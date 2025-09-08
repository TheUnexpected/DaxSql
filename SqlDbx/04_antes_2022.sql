select
  sin.IdOficina
  --, sin.NipPerfilAgente   Esta se descomenta si necesito el agente
  --sin.NumReclamo
  , Ocurrido = sum(sin.Ocurrido)
  , GastosDirectos =  sum(sin.GastosDirectos)
  , GastosIndirectos = sum(sin.GastosIndirectos)
  , Salvamentos = sum(sin.Salvamentos)
  , Rec3Ros = sum(sin.RecuperacionesTercerosResponsables + isnull(sc.Monto, 0))
  , SinTotal = 
      (
        sum(sin.Ocurrido)
        + sum(sin.GastosDirectos)
        + sum(sin.GastosIndirectos)
        - sum(sin.Salvamentos)
        - sum(sin.RecuperacionesTercerosResponsables + isnull(sc.Monto, 0))
      )
from
  (
    select
      IdOficina = sin.IdOficinaEmision
      , sin.NipPerfilAgente
      , NumReclamo
      , Ocurrido = sum(sin.Ocurrido)
      , GastosDirectos = sum(sin.GastosAjuste)
      , GastosIndirectos = sum(sin.GastosIndirectos)
      , Salvamentos = sum(sin.EstimadoSalvamentos + sin.AjustesSalvamentos)
      , RecuperacionesTercerosResponsables = sum(RecuperacionesTercerosResponsables)
    from
      DMSin.Tb_BI_AutSinDatosEconomicosCob sin
    WHERE
    
    -- aquí hay que poner los filtros que queramos de fechas, oficinas o agente
    
      sin.IdOficinaEmision in (369,238,239,742,743,744,498,499,724,652,653,647,797,107,492,538,474,589,755,772,776,777,778,699,667,77,90,164,166,170,230,231,232,343,344,345,346,347,348,349,350,351,425,515,700,227,204)
      and sin.FechaMovimiento >= 20200101
      and sin.FechaMovimiento <= 20211231
    group by
      sin.IdOficinaEmision
      , sin.NipPerfilAgente
      , NumReclamo
  ) sin
    left join
      (
        select 
          sc.IdOficina
          , sc.NumReclamo
          , Monto = sum(sc.Monto)
        from
          dbo.TB_BI_AutrRecupCompSipacCopac sc
        where
          sc.IdOficina in (139)
          and sc.FechaMovimiento >= 20200101
          and sc.FechaMovimiento <= 20211231
        group by
          sc.IdOficina
          , sc.NumReclamo
      ) sc
    on
      sc.IdOficina = sin.IdOficina
      and sc.NumReclamo = sin.NumReclamo
group by
  sin.IdOficina
--  , sin.NipPerfilAgente  igual esta se descomenta si se quiere el agente