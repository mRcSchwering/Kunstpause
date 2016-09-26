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

#### ReadInfo
# core fucntion, just reading info file
ReadInfo <- function(infoFile){
  info <- strsplit(readLines(infoFile), ";")
  names(info) <- sapply(info, function(x) x[1])
  info <- sapply(info, function(x) x[-1])
  info$statusFile <- infoFile
  class(info) <- "ProcessInfo"
  info
}


#### Log
# write log file
# checks pid before writing
Log <- function(msg, info = NULL){

  # get ProcessInfo object
  if(is.null(info)) info <- get(Filter(function(x) class(get(x)) == "ProcessInfo", ls(pos = 1))[1])
  if(length(info) < 1) stop("Argument info empty or no ProcessInfo object found.")

  # create lines for log msg
  log <- c("", msg)
  if(!is.null(info$sessionid)) log <- paste(info$sessionid, log, sep = " : ")

  # write log after confirming pid
  pid <- ReadInfo(info$statusFile)$pid
  if(pid != info$pid){
    if(!is.null(info$logFile)) write(paste("Process expired, quitting at", Sys.time()), info$logFile, append = TRUE)
    quit("no", 0)
  } else {
    if(!is.null(info$logFile)){
      write(log, info$logFile, append = TRUE)
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}


#### InitProcess
# reading info file
# writing progress 0.1 after confirming pid
ProcessInit <- function( args = commandArgs(TRUE),
                         log = paste("Starting at", Sys.time()) ){

  if(length(args) < 1) stop("Argument args is empty")

  # reading info
  info <- ReadInfo(args[1])

  # logging
  Log( c("", paste(rep("#", 40), collapse = ""), log, "", "ProcessInfo:", "",
        sapply(1:length(info), function(x) paste0(names(info)[x], ";", paste(info[[x]], collapse = ";")))),
        info = info )

  # update progress
  info$progress <- 0.1
  write(sapply(1:length(info), function(x) paste0(names(info)[x], ";", paste(info[[x]], collapse = ";"))), info$statusFile)
  info
}






#### Update
# get object of file "ProcessStatus"
# write info file (after checking sign)
# returns updated info
ProcessUp <- function(progress, info = NULL){

  if(progress >= 1 || progress <= 0) stop("Progress must be greater 0 and smaller 1")

  # look for ProcessInfo object
  if(is.null(info)) info <- get(Filter(function(x) class(get(x)) == "ProcessInfo", ls(pos = 1))[1])
  if(length(info) < 1) stop("Argument info empty or no ProcessInfo object found.")

  # write log if pid valid
  Log(paste("Progress update to", progress), info = info)

  # update progress
  info$progress <- progress
  write(sapply(1:length(info), function(x) paste0(names(info)[x], ";", paste(info[[x]], collapse = ";"))), info$statusFile)

  info
}



### Ptry
# wraps expression in try
# if error, returns NULL, writes status and log
# if ignore, quits
Ptry <- function(expr, ignore = FALSE, info = NULL){

  # eval expr
  expr <- substitute(expr)
  res <- try(eval(expr))

  # get process info
  if(is.null(info)) info <- get(Filter(function(x) class(get(x)) == "ProcessInfo", ls(pos = 1))[1])

  # action
  # in case of error write log and update status
  if(class(res) == "try-error"){
    res <- gsub("\n", "", res[1])
    Log(c("Expression:", deparse(expr), "returned error:", res), info = info)
    if(!ignore){
      info$progress <- 1
      info$status <- res
      Log(paste("Quitting at", Sys.time()), info = info)
      write(sapply(1:length(info), function(x) paste0(names(info)[x], ";", paste(info[[x]], collapse = ";"))), info$statusFile)
      quit("no", 0)
    }
    out <- NULL

  } else out <- res

  out
}


# Init
#info <- Info(commandArgs(TRUE))
iff <- ProcessInit("/home/marc/src/mRc_repo/shinyTools/tmp/id1.status")

# Update
iff <- ProcessUp(0.2)

# Log
Log("some log")

# Process
Ptry(sum(a+2))


try(seq(1:Inf, 1))[1]





