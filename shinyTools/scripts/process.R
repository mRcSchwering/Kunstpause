################
#### in app ####
################
setwd("/home/marc/src/mRc_repo/shinyTools/tmp")
saveRDS(mtcars, "id1.rds")
info <- c(paste0("progress;", 0),
  paste0("pid;", format(Sys.time(), "%Y-%m-%d_%H:%M_"), paste(sample(0:9, 4, replace = TRUE), collapse = "")),
  paste0("sessionid;", "id1234"),
  "status",
  paste0("pwd;", getwd()), paste0("ifof;", file.path(getwd(), "id1.rds")),
  paste0("RScript;", "/home/marc/src/mRc_repo/shinyTools/scripts/process.R"),
  paste0("logFile;", "/home/marc/src/mRc_repo/shinyTools/log/log.log"))
write(info, "id1.status")
rm(info)
setwd("/home/marc/src/mRc_repo/shinyTools")
####################
#### end of app ####
####################


library(shinyTools)

# Init
#info <- Info(commandArgs(TRUE))
input <- RProcessInit("/home/marc/src/mRc_repo/shinyTools/tmp/id1.status")

# Update
info <- RProcessUp(0.2)

# Log
Log("some log")

# Process
Try(sum(1+2))


RProcessFin("asd")














