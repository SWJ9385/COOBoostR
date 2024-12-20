#' avgEvalLogLast function
#'
#' This function calculates train and test error avgerage from log file
#'
#' @param path results path
#' @param top number of top ranks
#' @param mutation name of mutation
#' @param initJar t of f
#' @param rp number of repetitions
#' @param nround number of rounds
#'
#' avgEvalLogLast(path, top, mutation, initJar, rp, nround)

avgEvalLogLast <- function(path, top, mutation, initJar, rp, nround){

  if (toupper(initJar) == "T"){
    evl <- paste0(path, "evalLog_", mutation, ".txt")
  }else{
    evl <- paste0(path, "evalLog_", mutation, "_", (as.numeric(top)), ".txt")
  }
  br <- readLines(evl)
  Tr <- c()
  Ts <- c()
  for (i in 1:rp){
    tmpbr <- str_split(string = br[grep(paste0(nround,":"),br)][i],pattern = "[[:space:]]")[[1]]
    tmpbr <- tmpbr[tmpbr != ""]
    tmpTr <- as.numeric(tmpbr[3])
    tmpTs <- as.numeric(tmpbr[4])
    Tr <- append(Tr, tmpTr)
    Ts <- append(Ts, tmpTs)
  }
  return(c(mean(Tr),mean(Ts)))
}
