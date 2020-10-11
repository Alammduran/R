
library(dplyr)
library(readr)
setwd("/Volumes/Data/Inmobiliario/web scraping/CSV_Original")

#Definir directorio de archivos
files <- list.files(path="/Volumes/Data/Inmobiliario/web scraping/CSV_Original")
lista2<-matrix(files)
narchivos<-nrow(lista2)

for (j in 1:narchivos){
  setwd("/Volumes/Data/Inmobiliario/web scraping/CSV_Original")
  archivo<-paste(lista2[j,1])
  archivo<-read_csv(archivo, locale = locale(encoding = "ISO-8859-1"))
  base<-data.frame(archivo)
  n<-ncol(base)
  for(i in 1:n){
    base[,i]<-chartr('áéíóúñ','aeioun',base[,i])
    base[,i]<-chartr('ÁÉÍÓÚÑ','aeioun',base[,i])
  }
  base[,2]<-gsub(",", "",base[,2])
  base[,2]<-gsub("*", "",base[,2])
  base[,2]<-gsub("#", "",base[,2])
  base[,3]<-gsub("MN", "",base[,3])
  base[,3]<-gsub(",", "",base[,3])
  base[,5]<-gsub("m²", "",base[,5])
  base[,6]<-gsub("m²", "",base[,6])
  base[,7]<-gsub("Publicado", "",base[,7])
  base[,7]<-gsub("hace", "",base[,7])
  base[,7]<-gsub("dias", "",base[,7])
  name<-paste(lista2[j,1])
  Fuente<-substr(name,1,4)
  Tipo<-substr(name,6,9)
  Promo<-substr(name,11,13)
  Municipio<-substr(name,15,17)
  Fecha_Cons<-substr(name,19,24)
  base<-mutate(base, Promo=Promo, Tipo=Tipo, Mun=Municipio, Fecha=Fecha_Cons)
  print(j)
  name2<-paste("L", name,sep="_")
  setwd("/Volumes/Data/Inmobiliario/web scraping/CSV_Limpio")
  write.csv(base,name2 )
}


##Unir los archivos
files2 <- list.files(path="/Volumes/Data/Inmobiliario/web scraping/CSV_Limpio") 
tmp <- lapply(files2, read.csv, header = TRUE)
todos <- do.call(rbind, tmp)

#Guardar archivo
setwd("~/Documents/Esc/Todos_Inmo")
write.csv(todos, file = "Inmo_150519_221019.csv")

