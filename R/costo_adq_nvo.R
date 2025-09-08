library(tidyr)
library(dplyr)
library(ggplot2)
library(stringr)
library(openxlsx)
library(readxl)
library(mice)
library(lubridate)
library(RODBC)
library(forecast)
library(zoo)
library(astsa)
library(xts)
library(DBI)
library(odbc)

Todo<-read_excel('~/Proyectos/Recluta productiva/segmentacion_enero_2025/base_adquisicion_21_24_cierre.xlsx')

DWHNEW<-readLines('~/R/R_connection.sql') %>% 
  odbcDriverConnect()

agentes<-sqlQuery(DWHNEW,
                  paste(
                    "
                  select age.NipPerfilAgente, 
 		age.NipAgente,
 		case WHEN age.NombreAgente ='CERTUS, AGENTE DE SEGUROS Y DE FIANZAS SA DE CV' then 'CERTUS AGENTE DE SEGUROS Y DE FIANZAS SA DE CV' 
        when  age.NombreAgente= 'MIURA RISK AGENTE DE SEGUROS Y DE FIANZAS S.A. DE C.V.' then 'MIURA RISK AGENTE DE SEGUROS Y DE FIANZAS SAPI  DE C.V.' 
        else age.NombreAgente end as NombreAgente
 
 
                  
 from tb_bi_dimagente as age
                  
                  "
                  )
)


close(DWHNEW)

Todo$NipPerfilAgente=as.integer(Todo$NipPerfilAgente)

Todo_merge<-Todo%>%
  left_join(agentes[c('NipPerfilAgente', 'NombreAgente')], by='NipPerfilAgente', suffix=c('_Original', '_Bueno'))

Todo_merge<-Todo_merge%>%
  mutate(Bono_tot=Comisión+BonoProducción+BonoRentabilidad+BonoCrecimiento+UDI+DerechoPolizaBono+DerechoPolizaUDI+IncentivoWeb)


Todo_ultimos_3<-Todo_merge%>%
  filter(`Año` %in% c(2024,2023,2022))

Todo_2024<-Todo_merge%>%
  filter(`Año` ==2024)

Todo_ultimos_3_res<-Todo_ultimos_3%>%
  group_by(NombreAgente_Bueno)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Bono_tot`))%>%
  mutate(Cost_adq=Bono_Tot/Emitida_Tot)


Todo_2024_res<-Todo_2024%>%
  group_by(NombreAgente_Bueno)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Bono_tot`))%>%
  mutate(Cost_adq=Bono_Tot/Emitida_Tot)

list_of_datasets <- list("tres_anios" = Todo_ultimos_3_res, "2024" = Todo_2024_res)

write.xlsx(list_of_datasets, file = "~/Proyectos/Recluta productiva/segmentacion_enero_2025/base_adq_.xlsx")

