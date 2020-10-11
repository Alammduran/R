library(dplyr)
library(readr)
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios")

rm(list=ls())
files <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios") 
lista<-matrix(files)
n=nrow(lista)
tmp <- lapply(files, read.csv, header = TRUE, fileEncoding="ISO-8859-1")
todos <- do.call(rbind, tmp)
base<-select(todos,"Titular", "Nota", "Autor", "Tipo", "fecha_ws", "ano", "mes", "dia", "hora", "Periodico", "idioma")
names(base)[5]="fecha"
names(base)[6]="an.o"
nombre<-paste("Periodicos-190927-191129.csv")
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Agrupados")
write.csv(base, file=nombre, fileEncoding = "ISO-8859-1")

