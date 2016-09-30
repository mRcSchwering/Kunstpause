library(shinyTools)

# some function as example
check <- function(object, add){ if(object <= add$n) return(paste("Lambda must be greater", add$n, "idiot!"))}

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel(
    h2("dpois"),
    numericInput("num1", "set lambda", 10, -10, 50),
    RProcessStartUI("process"),
    actionButton("trigger", "Start"),
    helpText("Plot is created in R batch script with 4s delay.")
  ),
  mainPanel(h2("Plot Output"), plotOutput("res1"), verbatimTextOutput("res2"))
))

server <-function(input, output, session) {

  callModule(RProcessStart, "process", trigger = reactive(input$trigger), object = reactive(input$num1),
             script = "./scripts/process.R", logFile = "./log/log.log", pwd = "./tmp",
             checkFun = "check", addArgs = list(n = 0))

  id <- "process"
  pwd <- "./tmp"

  id <- paste0(id, "-ifof")
  pwd <- normalizePath(pwd)

  status <- reactiveFileReader(500, session, file.path(pwd, paste0(id, ".status")),
                               function(x) if(file.exists(x)) ReadInfo(x) else NULL)

  res1 <- eventReactive(status(), {
    if(is.null(status()) || status()$progress != "1") NULL else {
      out <- readRDS(file.path(pwd, paste0(id, ".rds")))
      out
    }
  })


  output$res1 <- renderPlot(res1())
  output$res2 <- renderPrint(status())
}

shinyApp(ui, server)
