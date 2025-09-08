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

Autos<-read_excel('~/Proyectos/convenios_costo_adq/Base Adq 2021-2024.xlsx', sheet='Autos')
Danos<-read_excel('~/Proyectos/convenios_costo_adq/Base Adq 2021-2024.xlsx', sheet='Daños')

DWHNEW<-readLines('~/R/R_connection.sql') %>% 
  odbcDriverConnect()

agentes<-sqlQuery(DWHNEW,
                  paste(
                    "
                  select *
                  
                  from tb_bi_dimagente as age
                  
                  "
                  )
)


close(DWHNEW)

Autos<-Autos%>%
  left_join(agentes[c('NipPerfilAgente', 'NombreAgente')], by='NipPerfilAgente')

Danos<-Danos%>%
  left_join(agentes[c('NipPerfilAgente', 'NombreAgente')], by='NipPerfilAgente')

Autos_2023<-Autos%>%
  filter(`Año`<=2023)

Autos_2024<-Autos%>%
  filter(`Año`==2024)

Danos_2023<-Danos%>%
  filter(`Año`<=2023)

Danos_2024<-Danos%>%
  filter(`Año`==2024)

Autos_2023_res<-Autos_2023%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Autos_2024_res<-Autos_2024%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Danos_2023_res<-Danos_2023%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total_Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Danos_2024_res<-Danos_2024%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total_Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Total_2023<-bind_rows(Autos_2023_res,Danos_2023_res)

Total_2023<-Total_2023%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(Emitida_Tot), Bono_Tot=sum(Bono_Tot), Devengada_Tot=sum(Devengada_Tot), Ocurrido_Tot=sum(Ocurrido_Tot))

Total_2024<-bind_rows(Autos_2024_res,Danos_2024_res)

Total_2024<-Total_2024%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(Emitida_Tot), Bono_Tot=sum(Bono_Tot), Devengada_Tot=sum(Devengada_Tot), Ocurrido_Tot=sum(Ocurrido_Tot))

Total_2023<-Total_2023%>%
  mutate(Porc_adq=Bono_Tot/Emitida_Tot, Sini=Ocurrido_Tot/Devengada_Tot)

Total_2024<-Total_2024%>%
  mutate(Porc_adq=Bono_Tot/Emitida_Tot, Sini=Ocurrido_Tot/Devengada_Tot)

Total_2023<-Total_2023%>%
  mutate(IC=Sini+Porc_adq)

Total_2024<-Total_2024%>%
  mutate(IC=Sini+Porc_adq)


#solo 2023

Autos_2023_solo<-Autos%>%
  filter(`Año`==2023)

Danos_2023_solo<-Danos%>%
  filter(`Año`==2023)


Autos_2023_solo_res<-Autos_2023_solo%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Danos_2023_solo_res<-Danos_2023_solo%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(PrimaEmitida), Bono_Tot=sum(`Total_Bono`), Devengada_Tot=sum(PrimaDevengada), Ocurrido_Tot=sum(`Costo Siniestro Ocurrido`))

Total_2023_solo<-bind_rows(Autos_2023_solo_res,Danos_2023_solo_res)

Total_2023_solo<-Total_2023_solo%>%
  group_by(NombreAgente)%>%
  summarise(Emitida_Tot=sum(Emitida_Tot), Bono_Tot=sum(Bono_Tot), Devengada_Tot=sum(Devengada_Tot), Ocurrido_Tot=sum(Ocurrido_Tot))

Total_2023_solo<-Total_2023_solo%>%
  mutate(Porc_adq=Bono_Tot/Emitida_Tot, Sini=Ocurrido_Tot/Devengada_Tot)

Total_2023_solo<-Total_2023_solo%>%
  mutate(IC=Sini+Porc_adq)

