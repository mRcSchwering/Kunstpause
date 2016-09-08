# This is a small app which embeds the module
library(shiny)
library(shinyjs)

# load module functions
source("R/FileUpload.R")

# ui
ui <- fluidPage(sidebarLayout(

  sidebarPanel( width = 4,
        useShinyjs(debug = TRUE),
        h2("Upload a File"),
        div(id = "file", FileUploadUI("first", "First File Upload", rename = "rename", multiple = TRUE, horiz = TRUE)),
        actionButton("toggle", "toggle")
  ),

  mainPanel( width = 8,
        h1("File Upload Modul"),
        h3("First File Content"),
        verbatimTextOutput("content1"), br(),
        h3("Info to Second File(s)"),
        verbatimTextOutput("content2")
  )

))

source("R/FileUpload.R")
source("check.R")

server <-function(input, output, session) {

  # use modules (args: module name, id for namespace, ... custom arguments of module)
  firstFile <- callModule(FileUpload, "first", rename = TRUE, checkFile = "check", checkNames = "check2")

  # some processing (not part of module)
  output$content1 <- renderPrint(firstFile())

  # toggle stuff
  observeEvent(input$toggle, toggleState("file"))

}


shinyApp(ui, server)
