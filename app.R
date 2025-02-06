library("ShinyAppBuilder") 
library("ResultModelManager")

# Variable to fill in
mySchema = "main"
myServer = "data/sqlite/databaseFile.sqlite"
myUser = NULL
myPassword = NULL
myDbms = "sqlite"
myPort = NULL 
myTableAppend =''
usePooledConnection = TRUE
studyDescription = NULL
title = "OHDSI Analysis Viewer"
# protocolLink = 'http://ohdsi.org'
protocolLink = "https://github.com/mi-erasmusmc/PlpBenchmarks/blob/main/docs/Protocol/Protocol.html"
themePackage = "ShinyAppBuilder"

config <- ParallelLogger::loadSettingsFromJson(
  fileName = system.file(
    'shinyConfigUpdate.json', 
    package = "PatientLevelPrediction"
  ))

connectionDetailSettings <- list(
  dbms = myDbms,
  server =  myServer, 
  user = myUser, 
  password = myPassword, 
  port = myPort
)

databaseSettings <- list(
  connectionDetailSettings = connectionDetailSettings, 
  schema = mySchema,
  tablePrefix = myTableAppend,
  dbms = myDbms,
  server = myServer,
  user = myUser, 
  password = myPassword,
  port = myPort
)


databaseSettings$plpTablePrefix = databaseSettings$tablePrefix
databaseSettings$cgTablePrefix = databaseSettings$tablePrefix
databaseSettings$databaseTable = 'database_meta_data'
databaseSettings$databaseTablePrefix = databaseSettings$tablePrefix

resultDatabaseSettings  = databaseSettings
# usePooledConnection = TRUE
# studyDescription = NULL
# title = "OHDSI Analysis Viewer"
# protocolLink = 'http://ohdsi.org'
# themePackage = "ShinyAppBuilder"

connectionDetails <- do.call(
  DatabaseConnector::createConnectionDetails, 
  databaseSettings$connectionDetailSettings
)
connection <- ResultModelManager::ConnectionHandler$new(connectionDetails)
databaseSettings$connectionDetailSettings <- NULL


app <- shiny::shinyApp(
  ui = ShinyAppBuilder:::ui(
    config = config,
    title = title,
    link = protocolLink,
    studyDescription = studyDescription,
    themePackage = themePackage
  ),
  server = ShinyAppBuilder:::server(
    config = config,
    connection = connection,
    resultDatabaseSettings = resultDatabaseSettings
  ),
  onStart = function() {
    shiny::onStop(connection$finalize)
  }
)

# app <- createShinyApp(
#   config = config,
#   connection = connection,
#   resultDatabaseSettings = resultDatabaseSettings,
#   connectionDetails = connectionDetails,
#   usePooledConnection = usePooledConnection,
#   studyDescription = studyDescription,
#   title = title,
#   protocolLink = protocolLink,
#   themePackage = themePackage
# )
