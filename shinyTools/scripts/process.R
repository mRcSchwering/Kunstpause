# read input and info about process, report to app that it started
input <- shinyTools::Init(commandArgs(TRUE))
#input <- shinyTools::Init("tmp/process-ifof.status")

# Log sth
shinyTools::Log(c("Input is", input))

# status update to shiny session
Sys.sleep(4)
info <- shinyTools::Up(0.4)

# make plot
library(ggplot2)
.e <- environment()
a <- shinyTools::Try( ggplot(data.frame(x = 1:100, y = dpois(1:100, input)), environment = .e) + geom_point(aes(x = x, y = y)) )

# status update to shiny session
info <- shinyTools::Up(0.7)
Sys.sleep(4)

# fail, report to shiny session but continue
shinyTools::Try(1+asd, ignore = TRUE)

# finish return result to shiny session
shinyTools::Fin(a)









