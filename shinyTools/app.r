library(shiny)
library(shinyTools)

source("R/GetCaptures.R")
source("R/CapturePattern.R")

regexes <- list("^(.+?)_.*$", "^(.+?)_(.*?)_(.*?)\\.(.*)$", "^.*(SG.+?)1.*_(.+?)_.*$")
lib <- paste0("ENSG00000139", apply(expand.grid(0:9, 0:9, 0:9, "_8_", sample(20000:60000, 5), ".", sample(20000:60000, 5)),
                                    1, function(x) paste0(x, collapse = "")))

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel( width = 4, h2("Pattern as input"), p("Not part of Module UI"),
                selectizeInput("regex", "Regex", choices = regexes, options = list(create = TRUE))
  ),
  mainPanel( width = 8, h2("CapturePatternUI"),
    CapturePatternUI("cap", "Patterns Captured")
  )
))

server <-function(input, output, session) {
  callModule(CapturePattern, "cap", pat = reactive(input$regex), lines = reactive(lib))
}

shinyApp(ui, server)

