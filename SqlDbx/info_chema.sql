select * --1
from --1
	( select --2  --p1
  IdAseguradoUnico = vig.IdAseguradoUnicoCompuesto  
  , NipAgrupador = ase.NipAgrupador  
  , Nombre = norm.RazonSocial  
  , Correo = norm.DireccionEmail  
  , Sexo = norm.Sexo 
  , Edad = datediff(YEAR, FechaNacimiento, GETDATE())
  , EstadoCliente = isnull(Dest.DescEstado,'n/a')
  , FechaNacimiento = ase.FechaNacimiento  
  , PolizasVigentes = vig.NumPolizasAutosResidentes + vig.NumPolizasDanios + vig.NumPolizasTuristas + vig.NumPolizasAp  
  , PolizasCanceladas = count(can.NumCompletoCotizacion)  
  , PolizasAutosVigentes = vig.NumPolizasAutosResidentes  
  , PolizasDañosVigentes = vig.NumPolizasDanios      
  , OficinaIngreso = (   --p2 
        SELECT  --3 
            MIN(IdOficina) AS IdOficina
        FROM --3  
            dbo.Tb_Bi_ClientesVigentesDeyde dey WITH (NOLOCK)
        WHERE   
            dey.IdAseguradoUnicoCompuesto = vig.IdAseguradoUnicoCompuesto
  
   		)  --p2
  , IdOficinaUltMov = vig.IdOficina   
  , FechaIngreso = ase.FechaIngreso  
  , PrimaNeta = isnull(vxp.PrimaNeta,0)  
  , CantidadSiniestros = isnull(vxp.CantidadSiniestros,0)  
  , Ocurrido = isnull(vxp.Ocurrido,0)  
  ,TipoVehiculo = can.DescTipoVehiculo
  ,can.TipoPago
  ,can.paquete
  ,can.Uso_Vehiculo
  ,can.MarcaVehiculo
  ,can.ModeloVehiculo
  ,can.descviacotizacion

  ,ROW_NUMBER() over (partition  by idaseguradounico order by min(fechaingreso)  ) as numeracion
 
	 from  --2
	  (  --p3
	   select  --4 
	    IdAseguradoUnicoCompuesto  
	    , IdTipoPersona  
	    , Periodo  
	    , IdOficina  
	    , NumPolizasAutosResidentes  
	    , NumPolizasDanios   
	    , NumPolizasTuristas   
	    , NumPolizasAP   
	   from  --4 
	    dbo.Tb_Bi_ClientesVigentesDeyde with (nolock)    
	   where   
	    Periodo = cast( convert ( char ( 6 ), getdate(), 112 ) as int )  
	   group by  
	    IdAseguradoUnicoCompuesto  
	    , IdTipoPersona  
	    , Periodo  
	    , IdOficina  
	    , NumPolizasAutosResidentes  
	    , NumPolizasDanios   
	    , NumPolizasTuristas   
	    , NumPolizasAP  
	  ) vig  --p3
	  
     left join    
        dbo.Vw_Deyde_ResultadoNormalizacion Norm with(nolock)     
     on    
        Norm.IdAseguradoUnicoCompuesto = vig.IdAseguradoUnicoCompuesto    
        and Norm.CveAsegurado = -- #002    
          ( select   --5 --p4
              min(cgr.CveAsegurado)    
            from    
              dbo.Vw_Deyde_ResultadoNormalizacion cgr    
            where    --5
              cgr.IdAseguradoUnicoCompuesto = vig.IdAseguradoUnicoCompuesto    
          )  --p4
   left join   
    dbo.TB_BI_DimAsegurado ase with (index(PK_BI_DimAsegurado)nolock)  
   on   
    ase.CveAsegurado = norm.CveAsegurado 
	left join 
	TB_BI_DimEstados Dest
	on Dest.IdEstado = ase.IdEstado

   left join  
    (  --p5
         select --6  
           IdDeydeAgrupadorCompleto  
           , Periodo = Periodo  
           , PrimaNeta = sum(PrimaNeta)  
           , CantidadSiniestros = sum(NumSiniestros)  
          , Ocurrido = sum(Ocurrido)   
         from  --6
      ClienteUnico.TB_BI_VariablesXPeriodo with (nolock)    
         where  
      Periodo = cast ( convert ( char ( 6 ), getdate(), 112 ) as int )  
         group by   
      IdDeydeAgrupadorCompleto  
      , Periodo  
    ) vxp   --p5
   on  
       vxp.IdDeydeAgrupadorCompleto = vig.IdAseguradoUnicoCompuesto  
       and vxp.Periodo = vig.Periodo  
   inner join 
    (  --p6
     select  --7 
      CveAsegurado  
      , NumCompletoCotizacion  
      , IdOficina  
	  ,vehi.DescTipoVehiculo
	  ,MarcaVehiculo = marv.DescMarcaVehiculo
	  ,TipoPago = frecp.DescFrecuenciaPago
	  ,ViaCotizacion = DescViaCotizacion
	  ,paquete = Dpaq.DescPaquete
	  ,Uso_Vehiculo = Usveh.DescUsoCNSF
	  ,ed.ModeloVehiculo
	  ,vcot.descviacotizacion

     from  --7
      dbo.TB_BI_AutrFactEmisionDoc ed with (nolock)  
       left join   
        dbo.VW_BI_DimTipoDocumento doc with (nolock)   
        ON doc.IdTipoDocumento = ed.IdTipoDocumento 

		left join 
		TB_BI_DimUsoVehiculo Usveh with (nolock)  
		on
		Usveh.IdUsoVehiculo = ed.IdUsoVehiculo
		left join 
		dbo. TB_BI_DimTipoVehiculo vehi with (nolock)  
		on
		vehi.IdTipoVehiculo = ed.IdTipoVehiculo
		left join 
		dbo.TB_BI_DimMarcaVehiculo marv
		on marv.IdMarcaVehiculo = ed.IdMarcaVehiculo
		left join
		dmsin.Tb_BI_CatFrecuenciaPago frecp
		on
		frecp.IdFrecuenciaPago	= ed.IdFrecuenciaPago
		left join
		dbo.TB_BI_DimViaCotizacion Vcot
		on 
		Vcot.IdViaCotizacion = ed.IdViaCotizacion
		left join 
		dbo.TB_BI_DimPaquete Dpaq
		on
		Dpaq.IdPaquete = ed.IdPaquete
     where   
      left(FechaTransaccion, 4) >= (year(getdate())-2)  
      and (doc.IdGrupoDocumento = 24 or doc.IdTipoDocumento in (194,434,694))  
     group by   
      CveAsegurado  
      , NumCompletoCotizacion  
      , IdOficina  
	  ,vehi.DescTipoVehiculo
	  ,marv.DescMarcaVehiculo
	  ,frecp.DescFrecuenciaPago
	  ,DescViaCotizacion
	  ,Dpaq.DescPaquete
	  , Usveh.DescUsoCNSF
	  ,ed.ModeloVehiculo
	  ,vcot.descviacotizacion


     union  
       
     select  --8
      CveAsegurado  
      , NumCompletoCotizacion  
      , IdOficina  
	  ,TipoVehiculo = 'N/A' 
	  ,MarcaVehiculo = 'N/A'
	  ,FrecuenciaPago = frecp.DescFrecuenciaPago
	  ,ViaCotizacion = DescViaCotizacion
	  ,paquete = Dpaq.DescPaquete
	  ,usoVehiculo = null
	  ,ModeloVehiculo = null
	  ,vcot.descviacotizacion

     from  --8
      dbo.TB_BI_DanFactEmisionDoc ed with (nolock)  
       left join  
        dbo.VW_BI_DimTipoDocumento doc with (nolock)  
       on  
        doc.IdTipoDocumento = ed.IdTipoDocumento  

		left join
		dmsin.Tb_BI_CatFrecuenciaPago frecp
		on
		frecp.IdFrecuenciaPago	= ed.IdFrecuenciaPago
		left join
		dbo.TB_BI_DimViaCotizacion Vcot
		on 
		Vcot.IdViaCotizacion = ed.IdViaCotizacion
		left join 
		dbo.TB_BI_DimPaquete Dpaq
		on
		Dpaq.IdPaquete = ed.IdPaquete
		
     where   
      left(FechaTransaccion, 4) >= (year(getdate())-2)  
      and (doc.IdGrupoDocumento = 24 or doc.IdTipoDocumento in (194,434,694))  
     group by   
     CveAsegurado  
      , NumCompletoCotizacion  
      , IdOficina  
	  ,frecp.DescFrecuenciaPago
	  ,DescViaCotizacion
	  ,Dpaq.DescPaquete
	  ,vcot.descviacotizacion


    ) can  --p6
   on   
    can.CveAsegurado = norm.CveAsegurado  
 where  
  vig.IdOficina in (74,290,382,434,637,689,720,722,815)  
 group by    
  vig.IdAseguradoUnicoCompuesto  
  , ase.NipAgrupador  
  , norm.RazonSocial  
  , norm.DireccionEmail  
  , norm.Sexo  
  , ase.FechaNacimiento  
  , vig.NumPolizasAutosResidentes  
  , vig.NumPolizasDanios  
  , vig.NumPolizasTuristas  
  , vig.NumPolizasAp  
  , vig.NumPolizasAutosResidentes  
  , vig.NumPolizasDanios  
  , vig.IdOficina  
  , ase.FechaIngreso  
  , vxp.PrimaNeta  
  , vxp.CantidadSiniestros  
  , vxp.Ocurrido
  ,Dest.DescEstado
  ,can.DescTipoVehiculo
  ,can.TipoPago
  ,can.paquete
  ,IdAseguradoUnico
  ,can.Uso_Vehiculo
  ,can.ModeloVehiculo
  ,can.MarcaVehiculo
  ,can.descviacotizacion
) as pp --p1

where numeracion = 1