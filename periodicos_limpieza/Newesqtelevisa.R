library(dplyr)
library(readr)
setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/televisa")

#Definir directorio de archivos
files <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/televisa")
lista2<-matrix(files)
narchivos<-nrow(lista2)

for (j in 1:narchivos){ 
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Todos_medios/televisa")
  archivo<-paste(lista2[j,1])
  archivo<-read_csv(archivo, locale = locale(encoding = "ISO-8859-1"))
  base<-data.frame(archivo)
  n<-ncol(base)
  base<-na.omit(base)
  
  for(i in 1:n){
    base[,i]<-chartr('áéíóúñ','aeioun',base[,i])
    base[,i]<-chartr('ÁÉÍÓÚÑ','aeioun',base[,i])
    
  }
  
   base[,5]<-gsub("FUENTE", "",base[,5],  fixed = TRUE)
   base[,5]<-gsub("DESDE", "",base[,5], fixed = TRUE)
   base[,5]<-gsub(":", "",base[,5], fixed = TRUE)
   base[,5]<-gsub("|", "",base[,5], fixed = TRUE)
   base[,5]<-gsub("CDMX", "",base[,5], fixed = TRUE)
   base[,5]<-gsub("Mexico", "",base[,5], fixed = TRUE)
   base[,5]<-gsub("NUEVO LEoN", "",base[,5], fixed = TRUE)
   
   
  base[,3]<-gsub("POR: ", "", base[,3], fixed = TRUE)
  base[,5]<-gsub("FUENTE", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("noticieros televisa", "", base[,5], fixed = TRUE)
  base[,5]<-gsub(",", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("notimex", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("reuters", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("ap", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("agencia", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("XALAPA", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("QUITO", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Ecuador", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("FLORIDA", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Estados Unidos", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("LONDRES", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Reino Unido", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("forotv", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Nueva York", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("HABANACuba", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("WASHINGTON", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Suiza", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("GINEBRA", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Turquia", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("MONTERREY", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("PUERTO ESCONDIDO", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Oaxaca", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("efe", "", base[,5], fixed = TRUE)
  base[,5]<-gsub("Inglaterra", "", base[,5], fixed = TRUE)
  
  name<-paste(lista2[j,1])
  fecha_ws<-substr(name,13,18)
  ano<-substr(name,13,14)
  mes<-substr(name,15,16)
  dia<-substr(name,17,18)
  hora<-substr(name,20,23)
  periodico<-substr(name,4,11)
  names(base)=c("Titular", "Nota", "Autor", "Tipo", "Fecha")
  base<-mutate(base, ano=ano, mes=mes, dia=dia, hora=hora, Periodico=periodico, fecha_ws=fecha_ws, idioma ="es")
  print(j)
  name2<-paste("TelevisaNuevoEsq",fecha_ws,hora,sep="-",".csv")
  setwd("/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios")
  write.csv(base, name2,  fileEncoding = "ISO-8859-1") 
}



##Unir los archivos
files2 <- list.files(path="/Volumes/Data/Alam/Web_Scraping/Scrapy/Medios_limpios") 
tmp <- lapply(files2, read.csv, header = TRUE)
todos <- do.call(rbind, tmp)

#Guardar archivo
#setwd("~/Desktop/Todos_Inmo")
write.csv(todos, file = "Todos_inmo.csv", enconding = "ISO-8859-1")
