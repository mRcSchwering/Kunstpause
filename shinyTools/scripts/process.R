# read input and info about process, report to app that it started
input <- shinyTools::Init(commandArgs(TRUE))

# Log sth
shinyTools::Log(c("Input is", input))

# do stuff
Sys.sleep(4)

# status update to shiny session
info <- shinyTools::Up(0.2)

# make plot
input <- Try(ggplot2::qplot(1:100, dpois(1:100, input)))

# fail, report to shiny session but continue
input <- shinyTools::Try(1+"asd", ignore = TRUE)

# finish return result to shiny session
shinyTools::Fin(input)












