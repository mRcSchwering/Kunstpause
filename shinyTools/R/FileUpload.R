#### Module UI
# name of moduleUI function must be <name>UI, <name>Input, or <name>Output
# 1st line always: ns <- NS(id)
# put all input/output elements in ns() function
# by this, they are contained in the namespace defined by id (important)
# arg id defines namespace when calling module, other arguments are custom
# this one just creates an ui with a error message and a file upload
# with label and bMulti, file upload can be adjusted
FileUploadUI <- function(id, label, help = "Select files for upload.", rename = NULL,
                         multiple = FALSE, horiz = FALSE) {
  ns <- NS(id)

  # checks
  if(!is.logical(c(multiple, horiz))) stop("Arguments multiple and horiz need to be logical")

  # file Input
  inputUI <- tagList(
    uiOutput(ns("errorMessage_files")),
    fileInput(ns("file"), label, multiple = multiple)
  )

  # rename UI
  if(!is.null(rename)){
    renameUI <- tagList(
      strong(rename),
      uiOutput(ns("errorMessage_rename")),
      uiOutput(ns("rename"))
    )
    if(horiz == FALSE) inputUI <- tagList(inputUI, br(), renameUI)
    if(horiz == TRUE) inputUI <- tagList(fluidRow(column(6, inputUI), column(6, renameUI)))
    #inputUI <- tagList(inputUI, div(actionButton(ns("upload"), "Upload"), class = "centered"))
  }

  # add help Text
  if(!is.null(help)) out <- tagList(inputUI, helpText(help))

  return(out)
}



#### Module server
# name of Module server must be <name> (according to UI part)
# this is called in server with callModule(), where 1st arg is module name
# and 2nd arg is id for namespace, other args are custom
# the module server function always needs the 1st three arguments (they are not mentioned in callModule())
# then custom arguments can be added
# whenever input/output element is used, it is called from the namespace which was defined with id
# if input/output from global envir should be used, it must be added as argument
# here I just have the name of the checkFuntion used as custom argument
# file is uploaded, immediately checked with checkfunction
# if check function finds error -> error message is rendered (into module UI)
# if check function finds no error -> module returns info about uploaded file
# so basically, the function value is the module value: this can be loaded in global envir in app
# input/output stuff are like side effects, but they stay within the 'id' namespace
FileUpload <- function(input, output, session,
                       rename = FALSE,
                       checkFiles = NULL, checkNames = NULL,
                       logFile = NULL, logPrefix = NULL) {

  # checks
  if(class(rename) != "logical") stop("Argument rename must be TRUE or FALSE")
  if(!is.null(checkFiles) && class(checkFiles) != "character") stop("Argument checkFiles must be a function or NULL")
  if(!is.null(checkNames) && class(checkNames) != "character") stop("Argument checkNames must be a function or NULL")
  if(!is.null(logFile) && class(logFile) != "character") stop("Argument logFile must be character or NULL")
  if(!is.null(logPrefix) && class(logPrefix) != "character") stop("Argument logPrefix must be character or NULL")
  if(!is.null(logFile) && !file.exists(logFile)) stop("File", logFile, "not found.")

  # error messages
  error <- reactiveValues(uploaded = NULL, renamed = NULL)

  # uploaded files
  uploaded <- eventReactive(input$file, {
    df <- input$file
    if( is.null(df) || is.na(df) || length(df) == 0 || df == "" ){
      NULL
    } else if( is.null(checkFiles) ){
      df
    } else {
      error$uploaded <- do.call(checkFiles, args = list(data = df, logFile = logFile, logPrefix = logPrefix))
      if(is.null(error$uploaded)) df else NULL
    }
  })

  # UI for renaming
  output$rename <- renderUI({
    if( is.null(uploaded()) || !rename ) return(NULL)
    df <- uploaded()
    ns <- session$ns
    out <- tagList()
    for(i in 1:nrow(df)) out[[i]] <- textInput(ns(paste0("rename_", i)), df$name[i])
    out
  })

  # check file names
  renamed <- reactive({
    if( is.null(uploaded())) return(NULL)
    df <- uploaded()
    if( !rename ) return(df)
    genNames <- character(0)
    for(i in 1:nrow(df)) genNames <- c(genNames, input[[paste0("rename_", i)]])
    if( nrow(df) != length(genNames) ) return(NULL)
    if( is.null(checkNames) ){
      return(cbind(data.frame(genNames = genNames), df))
    } else {
      error$renamed <- do.call(checkNames, args = list(genNames = genNames, logFile = logFile, logPrefix = logPrefix))
      if(is.null(error$renamed)) cbind(data.frame(genNames = genNames), df) else NULL
    }
  })

  # show error messages
  output$errorMessage_files <- renderUI(HTML(paste0("<div style='color:red'>", error$uploaded, "</div>")))
  output$errorMessage_rename <- renderUI(HTML(paste0("<div style='color:red'>", error$renamed, "</div>")))

  return(renamed)
}
