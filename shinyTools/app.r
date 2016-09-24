library(shinyTools)

# some function as example
check <- function(text, add){ if(any(grepl(add$pat, text))) return(paste("Don't use letter", add$pat, "in any entry."))}

# little app with module
ui <- fluidPage(sidebarLayout(
  sidebarPanel(h2("ReactiveTextInputUI"),
    numericInput("nGroups", "n Groups", 2, -2, 10),
    ReactiveTextInputUI("id1", "Groups")
  ),
  mainPanel(h2("Output of ReactiveTextInput"), verbatimTextOutput("display"))
))


server <-function(input, output, session) {
  display <- callModule(ReactiveTextInput, "id1", n = reactive(input$nGroups), prefix = "Group",
                        values = c("Untreated", "Treated"), checkFun = "check", addArgs = list(pat = "X"))
  output$display <- renderPrint(display())
}

shinyApp(ui, server)
