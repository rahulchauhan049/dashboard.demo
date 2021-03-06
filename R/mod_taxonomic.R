# Module UI

#' @title   Module to visualize taxonomic data
#' @description  Contain plots to visulaize taxonomic related data fields.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_taxonomic
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_taxonomic_ui <- function(id) {
  ns <- NS(id)
  fluidPage(fluidRow(
    column(
      6,
      selectizeInput(
        ns("taxo_bar_input_1"),
        "Select Taxonomic Level",
        choices = NULL
      ),
      uiOutput(ns("back_1")),
      plotlyOutput(ns("bar_1"),
                   height = "250px")
    ),
    column(
      6,
      selectizeInput(
        ns("taxo_bar_input_2"),
        "Select Taxonomic Level",
        choices = NULL
      ),
      uiOutput(ns("back_2")),
      plotlyOutput(ns("bar_2"),
                   height = "250px")
    )
  ),
  fluidRow(br(),
           column(
             12,
             selectizeInput(
               ns("show_vars"),
               "Columns to show:",
               choices = NULL,
               multiple = TRUE
             ),
             DT::dataTableOutput(ns("table"))
            )
          )
        )
  
}

# Module Server

#' @rdname mod_taxonomic
#' @export
#' @keywords internal

mod_taxonomic_server <-
  function(input, output, session, data_taxo) {
    ns <- session$ns
    
    observe({
      choices = c(
        "kingdom",
        "phylum",
        "order",
        "family",
        "genus",
        "species",
        "basisOfRecord",
        "name",
        "missing_name",
        "scientificName"
      )
      
      column_names <- vector()
      for(i in choices){
        if(i %in% colnames(data_taxo())){
          column_names <- c(column_names, i)
        }
      }
      
      # Can also set the label and select items
      updateSelectInput(session, "taxo_bar_input_1",
                        "Select columns to show:",
                        choices = column_names,
                        selected = tail(column_names, 1)
      )
  })
    
    observe({
      choices = c(
        "identifiedBy",
        "recordedBy",
        "typeStatus",
        "year",
        "countryCode"
      )
      
      column_names <- vector()
      for(i in choices){
        if(i %in% colnames(data_taxo())){
          column_names <- c(column_names, i)
        }
      }
      
      # Can also set the label and select items
      updateSelectInput(session, "taxo_bar_input_2",
                        "Select columns to show:",
                        choices = column_names,
                        selected = tail(column_names, 1)
      )
    })
    
    observe({
      choices = c(
        "scientificName",
        "kingdom",
        "phylum",
        "order",
        "family",
        "genus",
        "species",
        "identifiedBy",
        "dateIdentified",
        "year",
        "month",
        "day",
        "taxonRemarks",
        "taxonomicStatus",
        "infraspecificEpithet",
        "taxonKey",
        "taxonRank",
        "speciesKey",
        "recordedBy",
        "recordNumber",
        "typeStatus",
        "species_guess",
        "uri"
      )
      column_names <- vector()
      for(i in choices){
        if(i %in% colnames(data_taxo())){
          column_names <- c(column_names, i)
        }
      }
      
      # Can also set the label and select items
      updateSelectInput(session, "show_vars",
                        "Select columns to show:",
                        choices = column_names,
                        selected = tail(column_names, 1)
      )
    })
    
    

        selected_bar_1 <- reactiveVal()
        output$bar_1 <- renderPlotly({
          validate(
            need(length(data_taxo())>0, 'Please upload/download a dataset first')
          )
          label <- switch(
            input$taxo_bar_input_1,
            "kingdom" = ~ kingdom,
            "phylum" = ~ phylum,
            "order" = ~ order,
            "family" = ~ family,
            "genus" = ~ genus,
            "species" = ~ species,
            "basisOfRecord" = ~ basisOfRecord,
            "name" = ~ name,
            "missing_name" = ~ missing_name,
            "scientificName" = ~ scientificName
          )
          if (length(selected_bar_1()) == 0) {
            plot_ly(
              data = data_taxo(),
              y = label,
              color = label,
              source = "taxobar_1"
            ) %>%
              layout(
                paper_bgcolor = 'transparent',
                plot_bgcolor = "transparent",
                showlegend = FALSE,
                xaxis = list(
                  color = '#ffffff',
                  zeroline = TRUE,
                  showline = TRUE,
                  showticklabels = TRUE,
                  showgrid = FALSE
                ),
                yaxis = list(
                  color = '#ffffff',
                  showticklabels = TRUE,
                  showgrid = FALSE
                )
              )
          } else {
            data_taxo() %>%
              filter(switch(
                input$taxo_bar_input_1,
                "kingdom" = kingdom,
                "phylum" = phylum,
                "order" = order,
                "family" = family,
                "genus" = genus,
                "species" = species,
                "basisOfRecord" = basisOfRecord,
                "name" = name,
                "missing_name" = missing_name,
                "scientificName" = scientificName
              ) %in%
                selected_bar_1()$y) %>%
              plot_ly(y = label,
                      color = label,
                      source = "taxobar_1") %>%
              layout(
                paper_bgcolor = 'transparent',
                plot_bgcolor = "transparent",
                showlegend = FALSE,
                xaxis = list(
                  color = '#ffffff',
                  zeroline = TRUE,
                  showline = TRUE,
                  showticklabels = TRUE,
                  showgrid = FALSE
                ),
                yaxis = list(
                  color = '#ffffff',
                  showticklabels = TRUE,
                  showgrid = FALSE
                )
              )
          }
        })
        
        observeEvent(event_data("plotly_click",
                                source = "taxobar_1"),
                     {
                       new <- event_data("plotly_click",
                                         source = "taxobar_1")
                       selected_bar_1(new)
                     })
        
        # populate back button if category is chosen
        output$back_1 <- renderUI({
          if (length(selected_bar_1())) {
            actionButton(ns("clear_bar_1"),
                         "Back/Reset",
                         icon("chevron-left"))
          }
        })
        
        # clear the chosen category on back button press
        observeEvent(input$clear_bar_1, selected_bar_1(NULL))
        
        #Bar2........................
        selected_bar_2 <- reactiveVal()
        output$bar_2 <- renderPlotly({
          validate(
            need(length(data_taxo())>0, 'Please upload/download a dataset first')
          )
          label <- switch(
            input$taxo_bar_input_2,
            "identifiedBy" = ~ identifiedBy,
            "year" = ~ year,
            "countryCode" = ~ countryCode,
            "recordedBy" = ~ recordedBy,
            "typeStatus" = ~ typeStatus
            )
          
          if (length(selected_bar_2()) == 0) {
            if (input$taxo_bar_input_2 == "year") {
              count(data_taxo(),
                    year) %>%
                plot_ly(source = "taxobar_2") %>%
                add_lines(x = ~ year,
                          y = ~ n) %>%
                layout(
                  paper_bgcolor = 'transparent',
                  plot_bgcolor = "transparent",
                  showlegend = FALSE,
                  xaxis = list(
                    color = '#ffffff',
                    zeroline = TRUE,
                    showline = TRUE,
                    showticklabels = TRUE,
                    showgrid = FALSE
                  ),
                  yaxis = list(
                    color = '#ffffff',
                    showticklabels = TRUE,
                    showgrid = FALSE
                  )
                )
            } else {
              plot_ly(
                data = data_taxo(),
                y = label,
                color = label,
                source = "taxobar_2"
              ) %>%
                layout(
                  paper_bgcolor = 'transparent',
                  plot_bgcolor = "transparent",
                  showlegend = FALSE,
                  xaxis = list(
                    color = '#ffffff',
                    zeroline = TRUE,
                    showline = TRUE,
                    showticklabels = TRUE,
                    showgrid = FALSE
                  ),
                  yaxis = list(
                    color = '#ffffff',
                    showticklabels = TRUE,
                    showgrid = FALSE
                  )
                )
            }
          } else {
            data_taxo() %>%
              filter( 
                switch(
                input$taxo_bar_input_2,
                "identifiedBy" = identifiedBy,
                "year" =  year,
                "countryCode" = countryCode,
                "recordedBy" = recordedBy,
                "typeStatus" = typeStatus
              ) %in%
                if (input$taxo_bar_input_2 == "year") {
                  selected_bar_2()$x
                } else {
                  selected_bar_2()$y
                }) %>%
              plot_ly(y = label,
                      color = label,
                      source = "taxobar_2") %>%
              layout(
                paper_bgcolor = 'transparent',
                plot_bgcolor = "transparent",
                showlegend = FALSE,
                xaxis = list(
                  color = '#ffffff',
                  zeroline = TRUE,
                  showline = TRUE,
                  showticklabels = TRUE,
                  showgrid = FALSE
                ),
                yaxis = list(
                  color = '#ffffff',
                  showticklabels = TRUE,
                  showgrid = FALSE
                )
              )
          }
        })
        
        observeEvent(event_data("plotly_click",
                                source = "taxobar_2"),
                     {
                       new <- event_data("plotly_click",
                                         source = "taxobar_2")
                       selected_bar_2(new)
                     })
        
        # populate back button if category is chosen
        output$back_2 <- renderUI({
          if (length(selected_bar_2())) {
            actionButton(ns("clear_bar_2"),
                         "Back/Reset",
                         icon("chevron-left"))
          }
        })
        
        # clear the chosen category on back button press
        observeEvent(input$clear_bar_2, selected_bar_2(NULL))
        
        output$b <- renderPrint({
          select1 <- event_data("plotly_click",
                                source = "taxobar_1")
          selected_bar_1()$y
        })
        
        output$a <- renderPrint({
          select2 <- event_data("plotly_click", source = "taxobar_2")
          select2
        })
        
        

        
        
        
        output$table <- DT::renderDataTable({
          validate(
            need(length(data_taxo())>0, 'Please upload/download a dataset first')
          )
          if (is.null(selected_bar_1()) && is.null(selected_bar_2())) {
            as.datatable(formattable::formattable(data_taxo()[input$show_vars],
                                                  align = c("l",
                                                            rep(
                                                              "r",
                                                              NCOL(df) - 1
                                                            ))))
          } else if (!is.null(selected_bar_1()) &&
                     is.null(selected_bar_2())) {
            df <- data_taxo() %>%
              filter(switch(
                input$taxo_bar_input_1,
                "kingdom" = kingdom,
                "phylum" = phylum,
                "order" = order,
                "family" = family,
                "genus" = genus,
                "species" = species,
                "basisOfRecord" = basisOfRecord,
                "name" = name,
                "missing_name" = missing_name,
                "scientificName" = scientificName
              ) %in%
                selected_bar_1()$y)
            as.datatable(formattable::formattable(df[input$show_vars],
                                                  align = c("l",
                                                            rep(
                                                              "r",
                                                              NCOL(table) - 1
                                                            ))))
          } else if (is.null(selected_bar_1()) &&
                     !is.null(selected_bar_2())) {
            df <- data_taxo() %>%
              filter(switch(
                as.integer(input$taxo_bar_input_2),
                identifiedBy,
                year,
                countryCode
              ) %in%
                if (input$taxo_bar_input_2 == "2") {
                  selected_bar_2()$x
                } else {
                  selected_bar_2()$y
                })
            as.datatable(formattable::formattable(df[input$show_vars],
                                                  align = c("l",
                                                            rep(
                                                              "r",
                                                              NCOL(table) - 1
                                                            ))))
          } else if (!is.null(selected_bar_1()) &&
                     !is.null(selected_bar_2())) {
            df <- data_taxo() %>%
              filter(switch(
                input$taxo_bar_input_2,
                "identifiedBy" = identifiedBy,
                "year" =  year,
                "countryCode" = countryCode,
                "recordedBy" = recordedBy,
                "typeStatus" = typeStatus
              ) %in%
                if (input$taxo_bar_input_2 == "2") {
                  selected_bar_2()$x
                } else {
                  selected_bar_2()$y
                })
            df <- df %>%
              filter(switch(
                input$taxo_bar_input_1,
                "kingdom" = kingdom,
                "phylum" = phylum,
                "order" = order,
                "family" = family,
                "genus" = genus,
                "species" = species,
                "basisOfRecord" = basisOfRecord,
                "name" = name,
                "missing_name" = missing_name,
                "scientificName" = scientificName
              ) %in%
                selected_bar_1()$y)
            as.datatable(formattable::formattable(df[input$show_vars],
                                                  align = c("l",
                                                            rep(
                                                              "r",
                                                              NCOL(table) - 1
                                                            ))))
          }
        })
    
  }
