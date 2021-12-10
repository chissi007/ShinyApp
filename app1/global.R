#librairies
library(plotly)
library(sqldf)
library(rnaturalearth)
library(magrittr)
library(tmap)
library(shiny)
library(shinythemes)
library(shinyjs)
#library(shinydashboard)

#chargement des données

#région
regions=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/region.csv",header = T,sep = ";", encoding = "UTF-8")
colnames(regions) <- c("id_region","region")
#département
dep=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/departement.csv",header = T,sep=",", encoding = "UTF-8")
#table date
ddate=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/dim_date.csv",header = T,sep=";", encoding="UTF-8")
#deces
deces=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/dim_deces.csv",header = T,sep = ",", encoding="UTF-8")
#indicateurs
indi=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/dim_indicateurs.csv",header = T,sep = ";", encoding = "UTF-8")
#indi$dep=as.character(indi$dep)
#vaccination
vaccin=read.csv("https://datafileapp.s3.eu-west-3.amazonaws.com/dim_vaccination.csv", header = T, sep = ";", encoding = "UTF-8")

#name_region
name_reg=ordered(regions$region)
#name_dep
name_dep=ordered(dep$nom_dep)

#get id dep
getId_dep<-function(nom_dep){
  id1=dep[dep$nom_dep==nom_dep,"id_dep"]
  return(id1)
}

#get id reg
getId_reg<-function(nom_reg){
  id1=regions[regions$region==nom_reg,"id_region"]
  return(id1)
}

#get id date
getId_date <- function(iddate){
  madate=ddate[ddate$date==iddate,"id_date"]
  return(madate)
}
