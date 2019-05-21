library(shiny)
library(googlesheets)

epochTime <- function() {
  as.integer(Sys.time())
}
judges <- sort(c("","Flanagan, David T","Kawski, Clayton","Reynolds, Josann M","McNamara, Nichols J","Ehlke, Stephen E","Berz, Ellen K","Hanrahan, William","Hyland, John D","Hanson, Jason","Crawford, Susan M","O'Brien, Sarah B","Kaforsky, Jill J","Samuelson, Timothy C","Commissioner, First Appearance","Asmus, Brian"))
prosecutors <- sort(c("","Barnett, Paul L","McMiller, Tracy L ","Fallon, Thomas James JD ","Hilton, Stephanie R","Sattler, Rachel E","Larson, Cara J","Raymond, Andrea Beth ","Cogbill, Allison E","Liegel, Christopher Allen ","Quattromani, James Michael ","Wetjen, Chelsea E","Winter, Patrick","Hess, Daniel R ","Ozanne, Ismael R ","Brown, William Leroy ","Helmberger, Tim","Moeser, Matthew D ","Suleski, Justine L ","Jambois, Robert J ","Stephan, Corey","Miller, Jessica ","Kalser, Robert John Jr ","Hilton, Stephanie","Delain, Margaret ","Powell, Valerian ","Pierson, Bryce M ","Hanson, Erin","Hart, David A ","Khaleel, Awais ","Montano, Dallas B ","Keyes, Lexi","Rennicke, Rebekah M"))
statutes <- sort(c("","940.225(3)",
                   "940.32(2)",
                   "940.235(1)"))
amended <- sort(c("","940.225 (3m)",
                  "947.01(1)",
                  "940.235(1)",
                  "940.225(2)(a)",
                  "948.09",
                  "940.225(3)",
                  "941.30(2)",
                  "813.125(7)",
                  "947.0125(2)(f)",
                  "940.19(1)",
                  "947.0125(2)(c)",
                  "32.03"))

disposition <- sort(c("","PleadAm","PleadOrg","Dism","GJuryTr","na","GCourtTr","DPA","Other"))
orders <- sort(c("","ProbSW","ProbSI","Jail","Prison","Other","NA"))
unitsofsentence <- sort(c("","Days","Months"))
typeofsentence <-sort(c("","Prob","Prison","Ext Sup","Jail","Jail as Cond"))

allFields <- c("caseNo", 
               "defendant",
               "race",
               "hispanicName",
               "judge",
               "prosecutor",
               "count",
               "outOf",
               "statute",
               "amended",
               "dispo",
               "ordered",
               "s1no",
               "s1unit",
               "s1type",
               "s1stayed",
               "s2no",
               "s2unit",
               "s2type",
               "s2stayed",
               "s3no",
               "s3unit",
               "s3type",
               "s3stayed",
               "s4no",
               "s4unit",
               "s4type",
               "s4stayed")

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
    #gs_edit_cells(sheet,ws=1, input = data.frame(1,2,3))
    return(sheet$sheet_title)
   })

  #text output
  # output$text <- renderText({
  #   text_reactive()
  # })


  output$record <- renderTable({
    data.frame(c(input$caseNo,
      input$defendant,
      input$race,
      input$hispanicName,
      input$judge,
      input$prosecutor,
      input$count,
      input$outOf,
      input$statute,
      input$amended,
      input$dispo,
      input$ordered,
      input$s1no,
      input$s1unit,
      input$s1type,
      input$s1stayed,
      input$s2no,
      input$s2unit,
      input$s2type,
      input$s2stayed,
      input$s3no,
      input$s3unit,
      input$s3type,
      input$s3stayed,
      input$s4no,
      input$s4unit,
      input$s4type,
      input$s4stayed))
  })
  
}


#ui
ui <- fluidPage(
#title
  titlePanel("Data Entry Form for Data Sentencing Project"),
  sidebarLayout(
    sidebarPanel(
      #inputs
     textInput("caseNo","Case Number"),
     textInput("defendant","Defendant Name"),
     radioButtons("race","Race",c("AfAm","White")),
     checkboxInput("hispanicName","Hispanic Seeming Name"),
     selectInput("judge","Judge",judges),
     selectInput("prosecutor","Prosecutor",prosecutors),
     numericInput("count","Count",value = NULL),
     numericInput("outOf","Out of", value = NULL),
     selectInput("statute","Statute",statutes),
     selectInput("amended","Amended To",amended,multiple = TRUE),
     selectInput("dispo","Disposition",disposition),
     selectInput("ordered","Ordered",orders),
     numericInput("s1no","Sentence 1 Number", value = NULL),
     selectInput("s1unit","Sentence 1 Units",unitsofsentence),
     selectInput("s1type","Sentence 1 Type",typeofsentence),
     checkboxInput("s1stayed","Sentence 1 Stayed?"),
     numericInput("s2no","Sentence 2 Number", value = NULL),
     selectInput("s2unit","Sentence 2 Units",unitsofsentence),
     selectInput("s2type","Sentence 2 Type",typeofsentence),
     checkboxInput("s2stayed","Sentence 2 Stayed?"),
     numericInput("s3no","Sentence 3 Number", value = NULL),
     selectInput("s3unit","Sentence 3 Units",unitsofsentence),
     selectInput("s3type","Sentence 3 Type",typeofsentence),
     checkboxInput("s3stayed","Sentence 3 Stayed?"),
     numericInput("s4no","Sentence 4 Number", value = NULL),
     selectInput("s4unit","Sentence 4 Units",unitsofsentence),
     selectInput("s4type","Sentence 4 Type",typeofsentence),
     checkboxInput("s4stayed","Sentence 4 Stayed?")
     ),
    #main panel - will show record before sending to google docs sheet
    mainPanel(
      #actionButton("loginButton","Log In to Google Sheets"),
      #textOutput("text"),
      tableOutput('record')
      )
  )
)

shinyApp(ui = ui, server = server)