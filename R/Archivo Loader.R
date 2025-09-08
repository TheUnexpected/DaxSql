install.packages("readr")
library(tools)
ruta <- 'D:\\Users\\430010267\\OneDrive - HDI Seguros\\Documentos\\PowerBI\\TableroSmartOffice\\ArchivosSO'
file_names <- file_path_sans_ext(list.files(path=ruta, pattern = "\\.csv"))
for (i in file_names) {
  ruta2 <- paste(ruta,"\\",i,".csv", sep="")
  df <- read.csv(ruta2, stringsAsFactors = FALSE, fileEncoding = "latin1")
  df$Periodo = as.integer(i)
  new_df <- as.data.frame(df)
  ruta_Archivo <- "D:/Users/430010267/OneDrive - HDI Seguros/Documentos/PowerBI/TableroSmartOffice/Sesiones.csv"
  if(file.exists(ruta_Archivo)){
    existing_df <- read.csv(ruta_Archivo, stringsAsFactors = FALSE, fileEncoding = "latin1")
    combined_df <- rbind(existing_df, new_df)
  } else {
      combined_df <- new_df
  }
  write.csv(combined_df, ruta_Archivo, row.names = FALSE, fileEncoding = "latin1")

}

print(file_names)