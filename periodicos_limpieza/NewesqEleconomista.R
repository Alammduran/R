library(dplyr)
library(readr)
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eleconomista")

#Definir directorio de archivos
files <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eleconomista")
lista2<-matrix(files)
narchivos<-nrow(lista2)

for (j in 1:narchivos){
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eleconomista")
  archivo<-paste(lista2[j,1])
  archivo<-read_csv(archivo, locale = locale(encoding = "ISO-8859-1"))
  base<-data.frame(archivo)
  n<-ncol(base)
  base<-na.omit(base)
  
  for(i in 1:n){
    base[,i]<-chartr('áéíóúñ','aeioun',base[,i])
    base[,i]<-chartr('ÁÉÍÓÚÑ','aeioun',base[,i])
    
  }
  
  name<-paste(lista2[j,1])
  fecha_ws<-substr(name,17,22 )
  ano<-substr(name,17,18)
  mes<-substr(name,19,20)
  dia<-substr(name,21,22)
  hora<-substr(name,24,27)
  periodico<-substr(name,4,15)
  names(base)=c("Titular", "Nota", "Autor", "Tipo", "Fecha")
  base<-mutate(base, ano=ano, mes=mes, dia=dia, hora=hora, Periodico=periodico, fecha_ws=fecha_ws, idioma = "es")
  print(j)
  base<-select(base,"Titular", "Nota", "Autor", "Tipo", "Fecha", "ano", "mes", "dia", "hora", "Periodico", "fecha_ws", "idioma")
  base<-base[ , c(5,3,1,4,2,6,7,8,9,10,11,12)]
  names(base)=c("Titular", "Nota", "Autor", "Tipo", "Fecha", "ano", "mes", "dia", "hora", "Periodico", "fecha_ws", "idioma")
  name2<-paste("EleconomistaNuevoEsq",fecha_ws,hora,sep="-",".csv")
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios")
  write.csv(base,file = name2,  fileEncoding = "UTF-8") 
}


##Unir los archivos
files2 <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios") 
tmp <- lapply(files2, read.csv, header = TRUE)
todos <- do.call(rbind, tmp)

#Guardar archivo
#setwd("~/Desktop/Todos_Inmo")
write.csv(todos, file = "Todos_inmo.csv", enconding = "ISO-8859-1")
