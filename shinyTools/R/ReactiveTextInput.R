#' ReactiveTextInputUI
#'
#' This is a series of textInputs with a functionality for validating the provided text inputs.
#'
#' The length of labels argument defines how many input fields there are.
#' So, argument n of the TextInput (server) function must be equal to length(labels).
#'
#' @family TextInput module functions
#'
#' @param id        chr id of this object for shiny session
#' @param labels    chr arr for textInput labels. length defines how many input fields there are
#' @param value     chr arr of length 1 or length(labels) defining default string inside all or each input fields.
#'                  NULL for no default value text. This is an actual input if it is not changed.
#' @param dummy     chr arr of length 1 or length(labels) defining dummy text inside all or each input fields.
#'                  NULL for no dummy text. This appears inside text field but is not an actual input.
#' @param help      chr or NULL (NULL) for help text placed underneath input fields.
#' @param horiz     bool (FALSE) whether ui elements should be placed horizontally, not vertically
#'
#' @return chr HTML for creating ui elements.
#'
#' @examples
#' library(shinyTools)
#'
#' # some function as example
#' check <- function(text, add){ if(any(grepl(add$pat, text))) return(paste("Don't use letter", add$pat, "in any entry."))}
#'
#' # little app with module
#' ui <- fluidPage(sidebarLayout(
#'   sidebarPanel(h2("TextInputUI"),
#'                TextInputUI("id1", c("positive Ctrls", "non-targeting Ctrls"), c("positive", "non-targeting"),
#'                            help = "use HGNC symbols", horiz = FALSE)
#'   ),
#'   mainPanel(h2("Output of TextInput"), verbatimTextOutput("display"))
#' ))
#'
#' server <-function(input, output, session) {
#'   display <- callModule(TextInput, "id1", n = 2, checkFun = "check", addArgs = list(pat = "X"))
#'   output$display <- renderPrint(display())
#' }
#'
#' shinyApp(ui, server)
#'
#' @export
#'
ReactiveTextInputUI <- function(id, title) {
  ns <- NS(id)
  out <- tagList(h3(title), uiOutput(ns("textFields")), uiOutput(ns("errorMessage")))
  return(out)
}



#' ReactiveTextInput
#'
#' This is a series of textInputs fields with a functionality for validating the provided text inputs.
#'
#' With argument checkFun a function name can be defined which will be used as quality control for the text inputs.
#' This function must take a chr arr as first argument. These are the user provided text inputs.
#' The function must either return NULL or a chr value. NULL means the input is valid.
#' If the user input should not be valid, the function must return a character value which will be used as error message.
#'
#' Additional argumets can be handed over to checkFun via the list addArgs.
#'
#' @family TextInput module functions
#'
#' @param input      argument used by shiny session
#' @param output     argument used by shiny session
#' @param session    argument used by shiny session
#' @param n          int number of textInput fields. n must be length(labels) from FileUploadUI.
#' @param checkFun   chr or NULL (NULL) if not NULL name of a function which can be used as a quality check for textInputs
#' @param addArgs    list or NULL (NULL) if not NULL list of additional arguments which will be passed to checkFun
#'
#' @return chr arr of user provided text input fields or NULL
#'
#' @examples
#' library(shinyTools)
#'
#' # some function as example
#' check <- function(text, add){ if(any(grepl(add$pat, text))) return(paste("Don't use letter", add$pat, "in any entry."))}
#'
#' # little app with module
#' ui <- fluidPage(sidebarLayout(
#'   sidebarPanel(h2("TextInputUI"),
#'                TextInputUI("id1", c("positive Ctrls", "non-targeting Ctrls"), c("positive", "non-targeting"),
#'                            help = "use HGNC symbols", horiz = FALSE)
#'   ),
#'   mainPanel(h2("Output of TextInput"), verbatimTextOutput("display"))
#' ))
#'
#' server <-function(input, output, session) {
#'   display <- callModule(TextInput, "id1", n = 2, checkFun = "check", addArgs = list(pat = "X"))
#'   output$display <- renderPrint(display())
#' }
#'
#' shinyApp(ui, server)
#'
#' @export
#'
ReactiveTextInput <- function(input, output, session, n, prefix = "Input", values = NULL, dummies = NULL,
                              checkFun = NULL, addArgs = NULL) {

  # checks
  if(!is.null(checkFun) && class(checkFun) != "character") stop("Argument checkFun must be a chr or NULL")
  if(!is.null(addArgs) && class(addArgs) != "list") stop("Argument addArgs must be a list or NULL")

  # create input fields ui
  output$textFields <- renderUI({
    if( n() < 1 ) return(NULL)
    ns <- session$ns
    labs <- if(is.null(prefix)) NULL else paste("Input", 1:n())
    tagList(lapply(1:n(), function(x) textInput(ns(paste0("text_", x)), labs[x], values[(x - 1)%%length(values) + 1],
                                      placeholder = dummies[(x - 1)%%length(dummies) + 1])))
  })

  # errors
  error <- reactiveValues(text = NULL)

  # output
  value <- reactive({
    out <- sapply(1:n(), function(x) input[[paste0("text_", x)]])
    if(class(out) == "list") return(NULL)
    if(is.null(checkFun)) return(out)
    error$text <- do.call(checkFun, args = list(out, addArgs))
    if(is.null(error$text)) out else NULL
  })

  # show error message
  output$errorMessage <- renderUI(HTML(paste0("<div style='color:red'>", error$text, "</div>")))

  return(value)
}
