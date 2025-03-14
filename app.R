library(OhdsiShinyAppBuilder)
library(ResultModelManager)
library(dplyr)

mySchema = "main"
myServer = "./data/PlpBenchmarkResults/databaseFile.sqlite"
myUser = NULL
myPassword = NULL
myDbms = "sqlite"
myPort = NULL 

config <- initializeModuleConfig() %>%
  addModuleConfig(createDefaultPredictionConfig()) 

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = myDbms,
  server =  myServer, 
  user = myUser, 
  password = myPassword, 
  port = myPort
)

databaseSettings <- list(
  connectionDetailSettings = NULL,
  schema = mySchema,
  tablePrefix = '',
  dbms = myDbms,
  server = myServer,
  user = myUser,
  password = myPassword,
  port = myPort
)

databaseSettings$plpTablePrefix <- databaseSettings$tablePrefix
databaseSettings$databaseTable <- "database_meta_data"
databaseSettings$databaseTablePrefix <- databaseSettings$tablePrefix

OhdsiShinyAppBuilder::createShinyApp(
  config = config, 
  connectionDetails = connectionDetails, 
  resultDatabaseSettings = databaseSettings
)