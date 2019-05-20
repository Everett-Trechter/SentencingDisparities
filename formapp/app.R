library(shiny)
library(googlesheets)


judges <- c("Flanagan, David T","Kawski, Clayton","Reynolds, Josann M","McNamara, Nichols J","Ehlke, Stephen E","Berz, Ellen K","Hanrahan, William","Hyland, John D","Hanson, Jason","Crawford, Susan M","O'Brien, Sarah B","Kaforsky, Jill J","Samuelson, Timothy C","Commissioner, First Appearance","Asmus, Brian")
prosecutors <- c("Barnett, Paul L","McMiller, Tracy L ","Fallon, Thomas James JD ","Hilton, Stephanie R","Sattler, Rachel E","Larson, Cara J","Raymond, Andrea Beth ","Cogbill, Allison E","Liegel, Christopher Allen ","Quattromani, James Michael ","Wetjen, Chelsea E","Winter, Patrick","Hess, Daniel R ","Ozanne, Ismael R ","Brown, William Leroy ","Helmberger, Tim","Moeser, Matthew D ","Suleski, Justine L ","Jambois, Robert J ","Stephan, Corey","Miller, Jessica ","Kalser, Robert John Jr ","Hilton, Stephanie","Delain, Margaret ","Powell, Valerian ","Pierson, Bryce M ","Hanson, Erin","Hart, David A ","Khaleel, Awais ","Montano, Dallas B ","Keyes, Lexi","Rennicke, Rebekah M")

  options("googlesheets.webapp.client_id" = '4205699659-mjppbfcc54tpt44qgme6fsi9198dpmpg.apps.googleusercontent.com')
  options("googlesheets.webapp.client_secret" = 'bXyYWUThZN18tFWwSk0RYof4')
  options("googlesheets.webapp.redirect_uri" = "https://everettcarytrechter.shinyapps.io/formapp")
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
    gs_edit_cells(sheet,ws=1, input = data.frame(1,2,3))
    return(sheet$sheet_title)
   })

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
     textInput("caseno","Case Number"),
     textInput("defendant","Defendant Name"),
     radioButtons("Race","Race",c("AfAm","White")),
     checkboxInput("hispanicName","Hispanic Seeming Name"),
     selectInput("judge","Judge",judges),
     selectInput("prosecutor","Prosecutor",prosecutors)
    ),
    #main panel - will show record before sending to google docs sheet
    mainPanel(
      actionButton("loginButton","Log In to Google Sheets"),
      textOutput("text")
      )
  )
)

shinyApp(ui = ui, server = server)