library(shiny)
library(shinyTools)

# check functions as example
check1 <- function(df, add){ if(any(grepl(add$type, df$type))) return(paste("Don't upload", add$type, "files."))}
check2 <- function(names, add){ if(any(grepl(add$pat, names))) return(paste("Don't use", add$pat, "in a file name."))}

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel( width = 4, h2("FileUploadUI"),
        FileUploadUI("uploadID", "Upload File", rename = "Rename File", multiple = TRUE, horiz = TRUE)
  ),
  mainPanel( width = 8, h2("Return value of FileUpload"),
        verbatimTextOutput("content1")
  )
))

server <-function(input, output, session) {
  info <- callModule(FileUpload, "uploadID", rename = TRUE, checkNames = "check2", checkFiles = "check1",
                     addArgs = list(pat = "a", type = "text"))
  output$content1 <- renderPrint(info())
}

shinyApp(ui, server)

