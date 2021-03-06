library(dplyr)
library(readr)
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eluniversal")

#Definir directorio de archivos
files <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eluniversal")
lista2<-matrix(files)
narchivos<-nrow(lista2)

for (j in 1:narchivos){ 
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/eluniversal")
  archivo<-paste(lista2[j,1])
  archivo<-read_csv(archivo, locale = locale(encoding = "ISO-8859-1"))
  base<-data.frame(archivo)
  n<-ncol(base)

  for(i in 1:n){
    base[,i]<-chartr('áéíóúñ','aeioun',base[,i])
    base[,i]<-chartr('ÁÉÍÓÚÑ','aeioun',base[,i])
    
  }
  
  
  base[,2]<-gsub("[email¬†protected]", "",base[,2],  fixed = TRUE)

  name<-paste(lista2[j,1])
  fecha_ws<-substr(name,16,21)
  ano<-substr(name,16,17)
  mes<-substr(name,18,19)
  dia<-substr(name,20,21)
  hora<-substr(name,23,26)
  periodico<-substr(name,4,14)
  names(base)=c("Titular", "Nota", "Autor", "Tipo", "Fecha")
  base<-mutate(base, ano=ano, mes=mes, dia=dia, hora=hora, Periodico=periodico, fecha_ws=fecha_ws, idioma = "es")
  print(j)
  #name(base)<-c("titular", "nota", "autor", "tipo", "fecha", "ano", "mes", "dia", "hora", "Periodico", "fecha_ws")
  name2<-paste("EluniversalNuevoEsq",fecha_ws,hora,sep="-",".csv")
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
