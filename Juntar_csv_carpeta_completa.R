rm(list=ls())
library(twitteR)
library(ROAuth)
library(httr)
library(dplyr)
library(lubridate)
library(readxl)
require(mets)

files <- list.files(path="/Volumes/Data/Inmobiliario/web scraping/CSV_Limpio")
tmp <- lapply(files, read.csv, header = TRUE)
todos<-do.call(rbind,tmp)
write.csv(todos, file = "Todos_Inmo.csv")



