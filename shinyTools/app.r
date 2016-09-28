library(shinyTools)

# some function as example
check <- function(text, add){ if(any(grepl(add$pat, text))) return(paste("Don't use letter", add$pat, "in any entry."))}

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel(h2("RProcess"),
    numericInput("num1", "Number1", 2, 1, 5),
    actionButton("trigger", "Multiply number1"),
    helpText("This is done in R batch script."), br(),
    numericInput("num2", "Number2", 2, 1, 5),
    helpText("Number2 is multiplied in app.")
  ),
  mainPanel(h2("Result of number1"), verbatimTextOutput("res1"),
            h2("Result of number2"), verbatimTextOutput("res2"))
))

# logFile kann NULL
# sessionid kann NULL
# pwd default = getwd()
# scriptpath muss gegeben sein

# checkFun + addArgs muss noch rein

server <-function(input, output, session) {

  observeEvent(input$trigger, {

    input <- input$num1

    id <- "id1"
    pid <- paste0(format(Sys.time(), "%Y-%m-%d_%H:%M_"), paste(sample(0:9, 4, replace = TRUE), collapse = ""))
    sessionid <- "asd1234"
    pwd <- file.path(getwd(), "tmp")
    command <- "Rscript"
    scriptPath <- "/home/marc/src/mRc_repo/shinyTools/scripts/process.R"
    logFile <- "/home/marc/src/mRc_repo/shinyTools/log/log.log"

    # write input
    saveRDS(input, file.path(pwd, paste0(id, ".rds")))

    # write info file
    info <- c(paste0("progress;", 0), paste0("pid;", pid), paste0("sessionid;", sessionid),
              "status", paste0("pwd;", pwd), paste0("ifof;", file.path(pwd, paste0(id, ".rds"))),
              paste0(command, ";", scriptPath), paste0("logFile;", logFile))
    write(info, file.path(pwd, paste0(id, ".status")))

    # start
    system2(command, args = c(scriptPath, file.path(pwd, paste0(id, ".status"))), wait = FALSE, stdout = NULL, stderr = NULL)
  })

  #output$res1 <- renderPrint(res1())
  output$res2 <- renderPrint(input$num2^2)
}

shinyApp(ui, server)
