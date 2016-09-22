library(shinyTools)

# some function as example
check <- function(text, add){ if(any(grepl(add$pat, text))) return(paste("Don't use letter", add$pat, "in any entry."))}

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel(h2("TextInputUI"),
               TextInputUI("id1", c("positive Ctrls", "non-targeting Ctrls"), c("positive", "non-targeting"),
                           help = "use HGNC symbols", horiz = FALSE)
  ),
  mainPanel(h2("Output of TextInput"), verbatimTextOutput("display"))
))

server <-function(input, output, session) {
  display <- callModule(TextInput, "id1", n = 2, checkFun = "check", addArgs = list(pat = "X"))
  output$display <- renderPrint(display())
}

shinyApp(ui, server)
