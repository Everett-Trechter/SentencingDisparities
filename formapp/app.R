library(shiny)
library(googlesheets)


  options("googlesheets.webapp.client_id" = '4205699659-mjppbfcc54tpt44qgme6fsi9198dpmpg.apps.googleusercontent.com')
  options("googlesheets.webapp.client_secret" = 'bXyYWUThZN18tFWwSk0RYof4')
  options("googlesheets.webapp.redirect_uri" = "http://127.0.0.1:4642")
#function signs a user into googlesheets

loginToGoogle <- function(){
  gs_webapp_auth_url(client_id = getOption("googlesheets.webapp.client_id"),
                     redirect_uri = getOption("googlesheets.webapp.redirect_uri"),
                     access_type = "online", approval_prompt = "force")
}
  
getGoogleSheet <- function(){
  theSheet <- gs_key('1nlOrDIa8rW1-VzMhk7DlRUKYXA3d-b-dDeYpiM0rVfU')
  return(theSheet)
}

#will append a data tibble to a google sheet
writeToSheet <- function(input){
  
}

#server
server <- function(input, output, session){
  observeEvent(input$loginButton,{
    loginToGoogle()
    sheet <-getGoogleSheet()
    })
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
      actionButton("loginButton","Log In to Google Sheets")
      )
  )
)

shinyApp(ui = ui, server = server)