check <- function(data, logFile, logPrefix){

  if(nrow(data) < 2) return("Select more than 1 file")
  NULL
}

check2 <- function(genNames, logFile, logPrefix){

  if(any(duplicated(genNames))) return("Each file must have a unique name")
  NULL
}
