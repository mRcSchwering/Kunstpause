# read input and info about process, report to app that it started
input <- shinyTools::Init(commandArgs(TRUE))
#input <- shinyTools::Init("tmp/process-ifof.status")

# Log sth
shinyTools::Log(c("Input is", input))

# status update to shiny session
info <- shinyTools::Up(0.8)

# do stuff
Sys.sleep(4)
a <- shinyTools::Try(dpois(1:100, input))

# finish return result to shiny session
shinyTools::Fin(a)









