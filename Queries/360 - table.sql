SELECT IdEjecutivo, TipoPeriodo, Periodo, IdTipoIndicador, Presupuesto,  PresupuestoPagado
 FROM cv360.Tbl_IndicadoresXEjecutivo 
 where Periodo BETWEEN 202501 and 202512 --and IdEjecutivo = 430005166002
 and IdTipoIndicador in (1, 2, 35) and TipoPeriodo in (1,2,3)
 and Presupuesto is not null
SELECT * FROM cv360.Tbl_CatNivelesJerarquia
/** 002 Ejecutivo, 003 Gerente, 004