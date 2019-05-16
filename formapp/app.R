library(shiny)
library(googlesheets)

#function signs a user into googlesheets
getGoogleSheet <- function(){
  gs_auth(new_user = TRUE)
  theSheet <- gs_key('1nlOrDIa8rW1-VzMhk7DlRUKYXA3d-b-dDeYpiM0rVfU')
}

#will append a data tibble to a google sheet
writeToSheet <- function(input){
  
}

#server
server <- function(input, output) {
  
}


#ui
ui <- fluidPage(
#title
  titlePanel("Data Entry Form for Data Sentencing Project"),
  sidebarLayout(
    sidebarPanel(
      #inputs
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    #main panel - will show record before sending to google docs sheet
    mainPanel(
      actionButton("connect","Connect to Google Sheet")
      )
  )
)

shinyApp(ui = ui, server = server)