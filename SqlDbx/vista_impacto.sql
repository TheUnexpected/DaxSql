select
  -- Maestro Negocio
  ots.IdOTCotizacion
  , ots.NombreNegocio
  , ots.RFC
  , ots.FechaAltaMaestroNegocio
  -- Cis Maestro
  , ots.IdCisMaestro
  , ots.VersionCisMaestro
  , ots.FechaAlta
  -- Cis Maestro Cotizacion
  , ots.MCNumCompletoCotizacion
  , ots.MCNumDocumento
  , ots.FolioOt
  , ots.UsuarioAlta
  , ots.UsuarioCambio
  -- Datos Póliza emitida
  , ots.NumCompletoCotizacion
  , ots.NumDocumento
  , ots.NumPoliza
  , ots.NumCertificado
  , ots.NumOrdenTrabajo
  , PrimaNeta = sum(ec.PrimaNeta)
  , PrimaNetaPropiaEmitida =                              
      sum(
        case                              
          when cb.IdTipoCobertura = 3892 then ec.PrimaNeta                             
          else 0                              
        end
      )
  , PrimaTotal = sum(ec.PrimaTotal)
from
  (
    select 
      -- Maestro Negocio
      mn.IdOTCotizacion
      , mn.NombreNegocio
      , mn.RFC
      , FechaAltaMaestroNegocio = mn.FechaAlta
      -- Cis Maestro
      , cm.IdCisMaestro
      , cm.VersionCisMaestro
      , cm.FechaAlta
      -- Cis Maestro Cotizacion
      , MCNumCompletoCotizacion = cmc.NumCompletoCotizacion
      , MCNumDocumento = cmc.NumDocumento
      , cmc.FolioOt
      , cmc.UsuarioAlta
      , cmc.UsuarioCambio
      -- Datos Póliza emitida
      , ed.NumCompletoCotizacion
      , ed.NumDocumento
      , ed.NumPoliza
      , ed.NumCertificado
      , ed.NumOrdenTrabajo
    from 
      (
        select
           IdOTCotizacion = cast(substring(NombreNegocio,1,6)as int)
           , *
        --into #TB_BI_AutrCisMaestroNegocio 
        from
          TB_BI_AutrCisMaestroNegocio with(nolock)   
        where
          FechaAlta >= '20231001'
          and NombreNegocio not like '%.%'
          and isnumeric(substring(NombreNegocio, 1,6)) = 1
          and IdEstatus = 171 
      ) mn
        left join
          dbo.TB_DWH_AutrCisMaestro cm with(nolock) 
        on
          cm.IdCisMaestro = mn.IdCisMaestro
          --and cm.VersionCisMaestro = mn.VersionCisMaestro
        left join
          dbo.TB_BI_AutrCisMaestroCotizacion cmc with(nolock) 
        on  
          cmc.IdCisMaestro = mn.IdCisMaestro
          --and cmc.VersionCisMaestro = mn.VersionCisMaestro
        left join
          dbo.TB_BI_AutrFactEmisionDoc ed with(nolock)  
        on
          ed.NumCompletoCotizacion = cmc.NumCompletoCotizacion
          and ed.NumDocumento =
            (
              select
                NumDocumento = max(NumDocumento)
              from
                dbo.TB_BI_AutrFactEmisionDoc with(nolock) 
              where
                NumCompletoCotizacion = cmc.NumCompletoCotizacion
            )
        left join
          dbo.TB_BI_DimTipoDocumento td with(nolock)
        on
          td.IdTipoDocumento = ed.IdTipoDocumento
        
    where 
      td.IdGrupoDocumento != 2 -- Todo lo que no este cancelado
  ) ots
    left join
      dbo.TB_BI_AutrFactEmisionCob ec with(nolock)  
    on
      ec.NumCompletoCotizacion = ots.NumCompletoCotizacion 
    left join
      dbo.TB_BI_DimCobertura cb with(nolock)  
    on
      cb.IdCobertura = ec.IdCobertura
group by
  ots.IdOTCotizacion
  , ots.NombreNegocio
  , ots.RFC
  , ots.FechaAltaMaestroNegocio
  , ots.IdCisMaestro
  , ots.VersionCisMaestro
  , ots.FechaAlta
  , ots.MCNumCompletoCotizacion
  , ots.MCNumDocumento
  , ots.FolioOt
  , ots.UsuarioAlta
  , ots.UsuarioCambio
  , ots.NumCompletoCotizacion
  , ots.NumDocumento
  , ots.NumPoliza
  , ots.NumCertificado
  , ots.NumOrdenTrabajo
 