#' @import shiny
#' @import bdclean

app_server <- function(input, output, session) {
  
  session$onSessionEnded(stopApp)
  
  options(shiny.maxRequestSize = 5000 * 1024 ^ 2)
  
  data_input <- 
    callModule(
      bdutilities.app::mod_add_data_server,
      id = "bdFileInput",
      "darwinControlInner"
    )

  darwinized_data <- callModule(bdutilities.app::mod_darwinize_server,
                                "darwinize",
                                dat = data_input)

  callModule(mod_dataSummary_server, "dataSummary_ui", darwinized_data)

  callModule(mod_missing_data_server, "missing_data_ui", darwinized_data)

  callModule(mod_spatial_server, "spatial_ui", darwinized_data)

  callModule(mod_taxonomic_server, "taxonomic_ui", darwinized_data)

  callModule(mod_temporal_server, "temporal_ui", darwinized_data)
  
  callModule(
    bdutilities.app::mod_citation_server,
    id = "bdcite",
    package = "dashboard.demo"
  )
  
  
  
  observeEvent(input$sideBar, {
    dat <- data_input
    dar <- darwinized_data
    
    if(input$sideBar == "dataSummary"){
      if (length(dat()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please add data",
                         duration = 6)
      }
      if (length(dar()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please Darwanize Data",
                         duration = 6)
      }
      
    } else if (input$sideBar == "missing_overview"){
      if (length(dat()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please add data",
                         duration = 6)
      }
      if (length(dar()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please Darwanize Data",
                         duration = 6)
      }
    } else if (input$sideBar == "spatialTab"){
      if (length(dat()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please add data",
                         duration = 6)
      }
      if (length(dar()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please Darwanize Data",
                         duration = 6)
      }
    } else if (input$sideBar == "taxonomicTab"){
      if (length(dat()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please add data",
                         duration = 6)
      }
      if (length(dar()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please Darwanize Data",
                         duration = 6)
      }
    } else if (input$sideBar == "temporalTab"){
      if (length(dat()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please add data",
                         duration = 6)
      }
      if (length(dar()) == 0) {
        updateTabItems(session, "sideBar", "dataInputTab")
        showNotification("Please Darwanize Data",
                         duration = 6)
      }
    }
  })
  
  
  
}
