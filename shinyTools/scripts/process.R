################
#### in app ####
################
setwd("/home/marc/src/mRc_repo/shinyTools/tmp")
saveRDS(mtcars, "id1.rds")
info <- c(paste0("progress;", 0), "status",
  paste0("sign;", format(Sys.time(), "%Y-%m-%d_%H:%M_"), paste(sample(0:9, 4, replace = TRUE), collapse = "")),
  paste0("ifof;", "id1.rds"), paste0("pwd;", getwd()))
write(info, "id1.status")
rm(info, mtcars)
setwd("/home/marc/src/mRc_repo/shinyTools")
####################
#### end of app ####
####################


#### ReadInfo
# reading info file
# writing progress 0.1
Info <- function(args = commandArgs(TRUE)){
  if(length(args) < 1) stop("Argument args is empty")
  info <- strsplit(readLines(args[1]), ";")
  names(info) <- sapply(info, function(x) x[1])
  info <- sapply(info, function(x) x[-1])
  info$statusFile <- args[1]
  info$progress <- 0.1
  write(sapply(1:length(info), function(x) paste0(names(info)[x], ";", paste(info[[x]], collapse = ";"))), info$statusFile)
  class(info) <- "ProcessInfo"
  info
}



#### Update
# get object of file "ProcessStatus"
# write info file (after checking sign)
#
Update()
Update <- function(progress, info = NULL){
  if(progress > 1 || progress < 0) stop("Progress must be bewteen 0 and 1")
  if(is.null(info)) info <- get(Filter(function(x) class(get(x)) == "ProcessInfo", ls(pos = 1))[1])

  info$progress <- progress

  sign <- strsplit(readLines(info$statusFile, n = 3)[3], ";")[2]
  if(sign != info$sign){
    if( !is.null(info$logFile) ) write("process expired", info$logFile)
    quit("no", 0)
  }
  return(info)
}


sapply(ls(), function(x) class())

?get()

# read info
#info <- Info(commandArgs(TRUE))
iff <- Info("/home/marc/src/mRc_repo/shinyTools/tmp/id1.status")


# read input










