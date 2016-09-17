library(shiny)
library(shinyTools)

# some data
lines <- c(">ENSG00000139083_0_0.3", "GCCTGCTCAGTGTAGCATTA", ">ENSG00000139083_11_61387.34124",
  "GGGAACATGAAGTGGCGTCG", ">ENSG00000139083_3_61387.34150", "GTGAGTGTTCGTGACCCGAG", ">ENSG00000139083_9_61387.34118",
  "GAGGAAGCGTAACTCGGCAC", ">ENSG00000139083_8_61387.34117", "GGGAAGCGTAACTCGGCACT", ">ENSG00000139083_10_61387.34120",
  "GGCGTCGAGGAAGCGTAACT", ">ENSG00000139083_49_184161.78616")
pat <- "^(.+?)(_.*)$"
pat <- "^(.+?)(_.*?)_(.*?)$"
pat <- "^.*_(.+?)_.*$"
pat <- "^.*(SG.+?)1.*_(.+?)_.*$"

ncaps <- stringr::str_count(pat, "\\(.+?\\)")
lines2 <- lines[grepl(pat, lines)]

source("R/GetCaptures.R")

s <- ">ENSG00000139083_8_61387.34117"
pat <- "^.*((SG.+?)1.*_(.+?))_.*$"

m <- GetCaptures(s, pat)
apply(m, 2, function(x) substr(s, x[2], x[3]))



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

