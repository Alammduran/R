library(dplyr)
library(readr)
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/excelsior")

#Definir directorio de archivos
files <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/excelsior")
lista2<-matrix(files)
narchivos<-nrow(lista2)

for (j in 1:narchivos){ 
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/excelsior")
  archivo<-paste(lista2[j,1])
  archivo<-read_csv(archivo, locale = locale(encoding = "ISO-8859-1"))
  base<-data.frame(archivo)
  n<-ncol(base)
  base<-na.omit(base)
  
  for(i in 1:n){
    base[,i]<-chartr('áéíóúñ','aeioun',base[,i])
    base[,i]<-chartr('ÁÉÍÓÚÑ','aeioun',base[,i])
    
  }
  
  base[,3]<-gsub("†", "",base[,3],  fixed = TRUE)
  name<-paste(lista2[j,1])
  fecha_ws<-substr(name,14,19)
  ano<-substr(name,14,15)
  mes<-substr(name,16,17)
  dia<-substr(name,18,19)
  hora<-substr(name,21,24)
  periodico<-substr(name,4,12)
  names(base)=c("Titular", "Nota", "Autor", "Tipo", "Fecha")
  base<-mutate(base, ano=ano, mes=mes, dia=dia, hora=hora, Periodico=periodico, fecha_ws=fecha_ws, idioma = "es")
  print(j)
  name2<-paste("ExcelsiorNuevoEsq",fecha_ws,hora,sep="-",".csv")
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios")
  write.csv(base,file = name2,  fileEncoding = "ISO-8859-1") 
}


##Unir los archivos
files2 <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios") 
tmp <- lapply(files2, read.csv, header = TRUE)
todos <- do.call(rbind, tmp)

#Guardar archivo
#setwd("~/Desktop/Todos_Inmo")
write.csv(todos, file = "Todos_inmo.csv", enconding = "ISO-8859-1")
