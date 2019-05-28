library(shiny)
library(tidyverse)
library(googlesheets)
library(DT)

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


#server
server <- function(input, output){
  
  table_reactive <- eventReactive(input$loginButton,{
    sheet <- getGoogleSheet()
    recordl <- recordList()
    gs_add_row(sheet,ws=1, input = recordl)
    return((recordl))
   })
  
  recordList <-reactive({
                  tibble(caseNo = input$caseNo,
                  defendant = input$defendant,
                  race = input$race,
                  hispanic = input$hispanicName,
                  judge = input$judge,
                  prosecutor = input$prosecutor,
                  count = input$count,
                  outof = input$outOf,
                  statute = input$statute,
                  amended =  paste(unlist(strsplit(ifelse(is.null(input$amended),"nothing",input$amended)," ")),sep="",collapse ="|"),
                  dispo = input$dispo,
                  ordered = input$ordered,
                  s1no = input$s1no,
                  s1unit =input$s1unit,
                  s1type = input$s1type,
                  s1stayed = input$s1stayed,
                  s2no = input$s2no,
                  s2unit = input$s2unit,
                  s2type= input$s2type,
                  s2stayed= input$s2stayed,
                  s3no= input$s3no,
                  s3unit = input$s3unit,
                  s3type = input$s3type,
                  s3stayed = input$s3stayed,
                  s4no = input$s4no,
                  s4unit = input$s4unit,
                  s4type = input$s4type,
                  s4stayed = input$s4stayed)})
  
 output$record <- DT::renderDataTable({
    table_reactive()
  })

}


#ui
ui <- fluidPage(
#title
  titlePanel("Data Entry Form for Data Sentencing Project"),
fluidRow(
      #inputs
    column(3,
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
       selectInput("ordered","Ordered",orders)
    ),
    column(8,
     fluidRow(
       h4("Sentence 1"),
       column(2,numericInput("s1no","Number", value = NULL)),
       column(2,selectInput("s1unit","Units",unitsofsentence)),
       column(2,selectInput("s1type","Type",typeofsentence)),
       column(2,checkboxInput("s1stayed","Stayed?"))
     ),
    fluidRow(
       h4("Sentence 2"),
       column(2,numericInput("s2no","Number", value = NULL)),
       column(2,selectInput("s2unit","Units",unitsofsentence)),
       column(2,selectInput("s2type","Type",typeofsentence)),
       column(2,checkboxInput("s2stayed","Stayed?"))
    ),
    fluidRow(
      h4("Sentence 3"),
       column(2,numericInput("s3no","Number", value = NULL)),
       column(2,selectInput("s3unit","Units",unitsofsentence)),
       column(2,selectInput("s3type","Type",typeofsentence)),
       column(2,checkboxInput("s3stayed","Stayed?"))
    ),
     fluidRow(
       h4("Sentence 4"),
       column(2,numericInput("s4no","Number", value = NULL)),
       column(2,selectInput("s4unit","Units",unitsofsentence)),
       column(2,selectInput("s4type","Type",typeofsentence)),
       column(2,checkboxInput("s4stayed","Stayed?"))
     )),
     actionButton("loginButton","Input to Google Sheets"),
     dataTableOutput('record')
  )

)

shinyApp(ui = ui, server = server)