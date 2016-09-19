#' FileUploadUI
#'
#' This file upload handler provides some functionalities for file uploading and possible renaming of uploaded files.
#'
#' This is are ui elements of the file upload handler, an error message and some text.
#' In case rename is not NULL, several text input forms for renaming files are created after file upload.
#'
#' @family FileUpload module functions
#'
#' @param id        chr id of this object for shiny session
#' @param label     chr or NULL a lable/ title for the file upload
#' @param help      chr or NULL a help Text
#' @param rename    chr or NULL (NULL). If not NULL uploaded files can be renamed after upload.
#'                  Value of rename will be used as a label above the renaming ui.
#' @param multiple  bool (FALSE) whether more than 1 file can be uploaded
#' @param horiz     bool (FALSE) whether ui elements should be placed horizontally, not vertically
#'
#' @return chr HTML for creating ui elements.
#'
#' @examples
#' library(shiny)
#' library(shinyTools)
#'
#' # check functions as example
#' check1 <- function(df, add){ if(any(grepl(add$type, df$type))) return(paste("Don't upload", add$type, "files."))}
#' check2 <- function(names, add){ if(any(grepl(add$pat, names))) return(paste("Don't use", add$pat, "in a file name."))}
#'
#' # little app with module
#' ui <- fluidPage(sidebarLayout(
#'   sidebarPanel( width = 4, h2("FileUploadUI"),
#'                 FileUploadUI("uploadID", "Upload File", rename = "Rename File", multiple = TRUE, horiz = TRUE)
#'   ),
#'   mainPanel( width = 8, h2("Return value of FileUpload"),
#'              verbatimTextOutput("content1")
#'   )
#' ))
#' server <-function(input, output, session) {
#'   info <- callModule(FileUpload, "uploadID", rename = TRUE, checkNames = "check2", checkFiles = "check1",
#'                      addArgs = list(pat = "a", type = "text"))
#'   output$content1 <- renderPrint(info())
#' }
#' shinyApp(ui, server)
#'
#' @export
#'
CapturePatternUI <- function(id, label) {
  ns <- NS(id)
  out <- tagList(h3(label), br(), uiOutput(ns("captures")))
  return(out)
}



#' FileUpload
#'
#' This file upload handler provides some functionalities for file uploading and possible renaming of uploaded files.
#'
#' On server side there is an additional option to include a function call which can be used to do a quality check
#' with uploaded files.
#' With argument checkFiles a function name can be defined.
#' This function must take a data.frame as first argument, which will contain information about uploaded files.
#' It has columns name, datapath, size, type.
#' The function must return a chr value which will be printed as error message in the ui.
#' Thereby, the function can be used as quality check with a user feedback.
#'
#' checkNames works like checkFiles, just that it is a quality check for the user defined names, if rename = TRUE.
#' It must take a chr vector as first argument which are the names defined by the user.
#'
#' Additional argumets can be handed over to both functions via the list addArgs.
#'
#' @family FileUpload module functions
#'
#' @param input      argument used by shiny session
#' @param output     argument used by shiny session
#' @param session    argument used by shiny session
#' @param rename     bool (FALSE) whether interactive renaming of uploaded files is enabled
#' @param checkFiles chr or NULL (NULL) if not NULL name of a function which can be used as a quality check for uploaded files
#' @param checkNames chr or NULL (NULL) if not NULL name of a function which can be used as a quality check user defined names
#' @param addArgs    list or NULL (NULL) if not NULL list of additional arguments which will be passed to checkFiles or checkNames
#'
#' @return data.frame of information about uploaded files (and user defined generic names)
#'
#' @examples
#' library(shiny)
#' library(shinyTools)
#'
#' # check functions as example
#' check1 <- function(df, add){ if(any(grepl(add$type, df$type))) return(paste("Don't upload", add$type, "files."))}
#' check2 <- function(names, add){ if(any(grepl(add$pat, names))) return(paste("Don't use", add$pat, "in a file name."))}
#'
#' # little app with module
#' ui <- fluidPage(sidebarLayout(
#'   sidebarPanel( width = 4, h2("FileUploadUI"),
#'                 FileUploadUI("uploadID", "Upload File", rename = "Rename File", multiple = TRUE, horiz = TRUE)
#'   ),
#'   mainPanel( width = 8, h2("Return value of FileUpload"),
#'              verbatimTextOutput("content1")
#'   )
#' ))
#' server <-function(input, output, session) {
#'   info <- callModule(FileUpload, "uploadID", rename = TRUE, checkNames = "check2", checkFiles = "check1",
#'                      addArgs = list(pat = "a", type = "text"))
#'   output$content1 <- renderPrint(info())
#' }
#' shinyApp(ui, server)
#'
#' @export
#'
CapturePattern <- function(input, output, session, pat, lines, n = 5, cols = NULL) {

  if(is.null(cols)) cols <- c("#db4437", "#4285f4", "#0f9d58", "#f4b400")

  output$captures <- renderUI({
    x <- lines()
    #pat <- input$regex

    if(length(x) < n) return(HTML(paste("<div style='color:red;'>Fewer than", n, "lines detected.</div>")))
    x <- x[grepl(pat(), x)]
    if(length(x) < n) return(HTML(paste("<div style='color:red;'>Fewer than", n, "lines match the pattern.</div>")))
    x <- x[sample(1:length(x), n)]
    if(length(pat()) < 1 || pat() == "") return(HTML(paste0("<tt>", paste(x, collapse = "<br/>"), "</tt>")))

    txt <- character()
    for( i in 1:n ){
      m <- GetCaptures(x[i], pat())
      m <- apply(rbind(m[1, ], apply(m, 2, function(s) substr(x, s[2], s[3]))), 2, function(ss){
        if(as.integer(ss[1]) != 0) paste0('<font color="', cols[as.integer(ss[1])], '">', ss[2], "</font>") else ss[2]})
      txt <- c(txt, paste(m, collapse = ""))
    }
    HTML(paste0("<tt>", paste( txt, collapse = "<br/>"), "</tt>"))
  })

}
