library(shiny)
library(googlesheets)


  options("googlesheets.webapp.client_id" = '4205699659-mjppbfcc54tpt44qgme6fsi9198dpmpg.apps.googleusercontent.com')
  options("googlesheets.webapp.client_secret" = 'bXyYWUThZN18tFWwSk0RYof4')
  options("googlesheets.webapp.redirect_uri" = "https://everettcarytrechter.shinyapps.io")
#function signs a user into googlesheets

#loginToGoogle <- function(){
#  gs_webapp_auth_url(client_id = getOption("googlesheets.webapp.client_id"),
#                     redirect_uri = getOption("googlesheets.webapp.redirect_uri"),
#                     access_type = "online", approval_prompt = "force")
#}
  
getGoogleSheet <- function(){
  gs_webapp_auth_url(client_id = getOption("googlesheets.webapp.client_id"),
                     redirect_uri = getOption("googlesheets.webapp.redirect_uri"),
                     access_type = "online", approval_prompt = "force")
  theSheet <- gs_title("Dane County Sentencing")
  return(theSheet)
}

#will append a data tibble to a google sheet
writeToSheet <- function(input){
  
}

#server
server <- function(input, output){
  text_reactive <- eventReactive(input$loginButton,{
    sheet <- getGoogleSheet()
    return(sheet$sheet_title)
   })
  #text_reactive <-eventReactive(input$helpbutton,{"HELLLP"})
  #text output
  output$text <- renderText({
    text_reactive()
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
      actionButton("loginButton","Log In to Google Sheets"),
      actionButton("helpbutton","help"),
      textOutput("text")
      )
  )
)

shinyApp(ui = ui, server = server)