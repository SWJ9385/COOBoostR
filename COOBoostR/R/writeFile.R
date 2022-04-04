#' writeFile() function
#'
#' This function writes ouput_mutation.txt and ouput_mutation_extract.txt
#'
#' @param path results path
#' @param top number of top ranks
#' @param mutation name of mutation
#' @param initJar t of f
#' @param rp number of repetitions
#' @param nround :number of rounds
#' @param rankdf output of readFile()
#'
#' writeFile(path, top, mutation, initJar, rp, nround, rankdf)

writeFile <- function(path, top, mutation, initJar, rp, nround, rankdf){

  wr <- paste0(path, "output_", mutation, ".txt")
  wr2 <- paste0(path, "output_", mutation, "_extract.txt")
  evl <- paste0(path, "evalLog_", mutation, "_", (as.numeric(top)), ".txt")

  if (toupper(initJar) == "T"){
    write(x = "name",file = wr)
    for( i in rankdf$typelist[1:dim(rankdf)[1]]){
      write(x = i, file = wr, append = T)
    }
    avgEvalLogLast_results <- avgEvalLogLast(rp = rp, nround = nround, path = path, top = top, mutation = mutation, initJar = initJar)
    tmpwr2 <- paste0("All\tFeatures100\tTr: (", avgEvalLogLast_results[1], ")", ", Ts: (", avgEvalLogLast_results[2], ")")
    write(x = tmpwr2, file = wr2, append = T)
  }else if(toupper(initJar) == "F"){
    if(top == 1){
      avgEvalLogLast_results <- avgEvalLogLast(rp = rp, nround = nround, path = path, top = 1, mutation = mutation, initJar = initJar)
      tmpwr2 <- paste0(top, "\t", rankdf[top,1],"\tTr: (", avgEvalLogLast_results[1], ")", ", Ts: (", avgEvalLogLast_results[2], ")")
      write(x = tmpwr2, file = wr2, append = T)
      write(x = "name",file = wr)
      write(x = rankdf$typelist[1], file = wr, append = T)

    }else if(top == 0){

    }else if(top <= 10 && top != 1){
      avgEvalLogLast_results <- avgEvalLogLast(rp = rp, nround = nround, path = path, top = top, mutation = mutation, initJar = initJar)
      tmpwr2 <- paste0(top, "\t", rankdf[top,1],"\tTr: (", avgEvalLogLast_results[1], ")", ", Ts: (", avgEvalLogLast_results[2], ")")
      write(x = tmpwr2, file = wr2, append = T)
      write(x = "name",file = wr)
      for(i in rankdf$typelist[1:dim(rankdf)[1]-1]){
        write(x = i, file = wr, append = T)
      }
    }else{
      write(x = "name",file = wr)
      for(i in rankdf$typelist[1:dim(rankdf)[1]-1]){
        write(x = i, file = wr, append = T)
      }
    }
  }else{
    print("initJar err")
  }
}
