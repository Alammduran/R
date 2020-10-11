##Analisis de periodicos
##Busqueda de palabras en la base de periodicos

library(tidyverse)
library(tidytext)
library(tm)
library(lubridate)
library(zoo)
library(scales)
library(dplyr)
library(tidyr)
library(RXKCD)
library(RColorBrewer)
library(tokenizers)
library(wordcloud)
library(SnowballC)
library(data.table)
library(tidytext)
library(rworldmap)
library(stringi)

#Cargar archivo CSV
setwd("/Volumes/Data/Artur/WS/newNEsq/Agrupados")
Periodicos_180919_190821 <- read.csv("periodicos_180919_190821.csv")
periodicos<-Periodicos_180919_190821
periodicos_subset<-subset(periodicos, fecha > "180918")
periodicos<-periodicos_subset

#Solo guardar ciertos periodicos
#periodicos_elegidos<-subset(periodicos, Periodico == "Azteca" | Periodico == "ElEconomista" | Periodico == "ElUniversal" | Periodico == "Excelsior"
                          #| Periodico == "Milenio" | Periodico == "Proceso" | Periodico == "Televisa")
periodicos_elegidos<-subset(periodicos, Periodico != "ElFinanciero")
periodicos_elegidos<-subset(periodicos_elegidos, Periodico != "La Jornada")

periodicos_elegidos<-mutate(periodicos_elegidos,fecha=ifelse(periodicos_elegidos$an.o == 18, paste("2018",mes,dia, sep = "-"),paste("2019",mes,dia, sep = "-")))
periodicos_elegidos$fecha<-as.Date(periodicos_elegidos$fecha)

#Minusculas
periodicos_elegidos$Nota <- str_to_lower(periodicos_elegidos$Nota, locale = "es")

#Quitar acentos
periodicos_elegidos$Nota <- stri_trans_general (periodicos_elegidos$Nota, "Latin-ASCII")

#Eliminar duplicados
anyDuplicated(periodicos_elegidos$Nota) #cuantos duplicados, si hay...
periodicos_elegidos<-periodicos_elegidos[!duplicated(periodicos_elegidos$Nota), ]
lista <- readxl::read_excel("Palabras_corru.xlsx")
periodicos_elegidos<-periodicos_elegidos[!duplicated(periodicos_elegidos$Titular), ]

#Busca la palabra
periodicos_elegidos$Nota<-tolower(periodicos_elegidos$Nota)
periodicos_prueba_pal <- 
  periodicos_elegidos %>%
  unnest_tokens(input = "Nota", output = "Palabra") %>%
  inner_join(lista, ., by = "Palabra")

#Identeficar palabras
periodicos_prueba_pal <-
  periodicos_prueba_pal %>%
  mutate(corrupcion= ifelse(Palabra == "corrupcion", 1, 0))

periodicos3<-select(periodicos_prueba_pal,"X.1", "corrupcion")

#Eliminar repetidos (Si la nota tiene corrupción más de una vez, si unifican para dar el valor total)
periodicos4<-aggregate(. ~ X.1, periodicos3, sum)
periodicos4<-data.table(periodicos4,key=c("X.1"))  #Unicos
periodicos_elegidos<-data.table(periodicos_elegidos,key=c("X.1"))
periodicos_completos<-periodicos4[periodicos_elegidos, nomatch=NA]
periodicos_iden<-subset(periodicos_completos, is.na(corrupcion)=="FALSE")

#Contar 
#por_fecha2<-aggregate(. ~ X.1, periodicos_elegidos, sum)
periodicos5<-mutate(periodicos_iden,ones=1)
#por_fecha<-dcast(periodicos5,Periodico~fecha,sum,value.var="ones")
#por_fecha <-periodicos5 %>% group_by(Periodico, fecha) %>% summarise(counter = length(Periodico)) 

#Contamos la cantidad de notas de cada periodico por fecha y se saca la frecuencia de la palabra (corrupcion) por cada fecha y periodico
por_fecha_corrup <-periodicos5 %>% group_by( fecha,Periodico) %>% summarise(notas = length(Periodico), palabra = sum(corrupcion)) 

#Ordenamos la base por periodico (de la A a la Z)
por_fecha_corrup2<-arrange(por_fecha_corrup, Periodico)

#Se crear un otra base solo con el periodico azteca
#periodico_individual<-subset(por_fecha_corrup, Periodico == "Azteca")

notas_dia <- por_fecha_corrup %>% group_by(fecha) %>% summarise(notas_por_dia = sum(notas)) 

por_fecha_corrup <-periodicos5 %>% group_by( fecha,Periodico) %>% summarise(notas = length(Periodico), palabra = sum(corrupcion)) 

######################

#Crear base de periodicos por mes
mes_notas <-periodicos5 %>% group_by(fecha, Periodico) %>% summarise(notas_por_mes = sum(ones))
mes_notas$fecha<- format(as.Date(mes_notas$fecha), "%Y-%m")
mes_notas <-mes_notas %>% group_by(fecha) %>% summarise(notas_por_mes = sum(notas_por_mes))

#Crear base de periodicos por mes por y por periodico
mes_notas2 <-periodicos5 %>% group_by(fecha, Periodico) %>% summarise(notas_por_mes = sum(ones))
mes_notas2$fecha<- format(as.Date(mes_notas2$fecha), "%Y-%m")
mes_notas_periodico <-mes_notas2 %>% group_by(fecha, Periodico) %>% summarise(notas_por_mes = sum(notas_por_mes))

#Graficar los datos
notas_dia %>%
  ggplot() +
  aes(fecha, notas_por_dia, color = "blue") +
  geom_line() +
  theme(legend.position = "top")

mes_notas %>%
  ggplot() +
  aes(fecha, notas_por_mes, group = 1) +
  geom_line( color = "blue") +
  theme(legend.position = "top")


por_fecha_corrup2 %>%
  count(Periodico, fechas) %>%
  group_by(notas) %>%
  mutate(Proporcion = n / sum(n)) %>%
  ggplot() +
  aes(notas, Proporcion, fill = Periodico) +
  geom_col() +
  scale_y_continuous(labels = percent_format()) +
  theme(legend.position = "top")+scale_fill_brewer(palette="Paired")


por_fecha_corrup2 %>%
  ggplot() +
  aes(notas, Periodico, color = Periodico) +
  geom_col() +
  theme(legend.position = "top")


##Grafica de barras de las menciones por fecha y periodico


mes_notas_periodico %>%
  ggplot() +
  aes(fecha, notas_por_mes, fill= Periodico) +
  geom_bar(stat="identity", position=position_stack()) +
  theme(legend.position = "right")+
  scale_fill_brewer(palette="Paired")+
  ggtitle("Total de Notas Mensuales Tema Corrupción")+
  xlab("Mes")+
  ylab("Notas por Mes")+
  theme(axis.text.x=element_text(angle = 90))

