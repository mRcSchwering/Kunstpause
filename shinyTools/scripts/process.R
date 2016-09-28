library(shinyTools)

print(commandArgs(TRUE))

# Init
input <- RProcessInit(commandArgs(TRUE))
#input <- RProcessInit("/home/marc/src/mRc_repo/shinyTools/tmp/id1.status")

Sys.sleep(4)

# Update
info <- RProcessUp(0.2)

# Log
Log(c("Input is", input))

# Process
Try(sum(a+2), ignore = TRUE)


RProcessFin("asd")












