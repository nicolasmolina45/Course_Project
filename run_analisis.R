# Obtención y limpieza de datos: Proyecto de curso

## 1-Descripción de los datos - archivo de origen
## 2-Combinar datos de prueba y entrenamiento para crear un conjunto de datos
## 3-Extraer informacion de la media y la desviación estándar 
## 4-Use nombres de actividades descriptivos para las mediciones de actividad
## 5-Etiquete adecuadamente el conjunto de datos con nombres de variables descriptivos
## 6-Cree un conjunto de datos ordenado con el promedio de cada variable, por actividad, por tema
## 7-Información de la sesión

# Librerias utilizadas
## Las Libraries utilizadas en esta operación son data.table y dplyr.

library(data.table)
library(dplyr)

# 1-Descripción de los datos - archivo de origen

## El archivo zip debe ser descargado en la carpeta del proyecto de los siguientes enlaces

dataDescription <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Descargar y extraer archivo zip en la carpeta del proyecto

download.file(dataUrl, destfile = "data.zip")
unzip("data.zip")

# 2-Combinar datos de prueba y entrenamiento para crear un conjunto de datos

## Leer datos de  Activity y Featur_labels 

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 
features <- read.table("./UCI HAR Dataset/features.txt")  

## Leer datos de Test

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

## Leer datos de Train: subject_train, X_train, y_train 

subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")


## Combinar subjects, activity labels, and features en conjunto de datos: test y train

test  <- cbind(subjecttest, ytest, Xtest)
train <- cbind(subjecttrain, ytrain, Xtrain)

## Combinar conjuntos de prueba y entrenamiento en un conjunto de datos total

totalDataSet <- rbind(test, train)

# 3-Extraer informacion sobre la media y la desviación estándar 

featuresNames <- c("subject", "activity", as.character(features$V2))
meanStdColumns <- grep("subject|activity|[Mm]ean|std", featuresNames, value = FALSE)
reducedDataSet <- totalDataSet[ ,meanStdColumns]


# 4-Utilizar nombres de actividades descriptivos para las mediciones de actividad

names(activity_labels) <- c("activityNumber", "activityName")
reducedSet$V1.1 <- activity_labels$activityName[reducedSet$V1.1]

# 5-Etiquete adecuadamente el conjunto de datos con nombres de variables descriptivos

## Renombrar variables por sustitucion

reducedNames <- featuresNames[meanStdColumns]    
reducedNames <- gsub("mean", "Mean", reducedNames)
reducedNames <- gsub("std", "Std", reducedNames)
reducedNames <- gsub("gravity", "Gravity", reducedNames)
reducedNames <- gsub("[[:punct:]]", "", reducedNames)
reducedNames <- gsub("^t", "time", reducedNames)
reducedNames <- gsub("^f", "frequency", reducedNames)
reducedNames <- gsub("^anglet", "angleTime", reducedNames)

## Renombrar el data frame

names(reducedSet) <- reducedNames   


# 6-Crear un conjunto de datos ordenado con el promedio de cada variable, por activity y subject

tidyDataset <- reducedSet %>% group_by(activity, subject) %>% summarise_all(funs(mean))

## Escribir datos ordenados en el archivo de salida txt

write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)
seetable <- read.table("tidyDataset.txt")
View(seetable)

# Seccion de informacion

sessionInfo()




