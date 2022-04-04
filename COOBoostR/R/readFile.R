#' readFile() function
#'
#' This function reads rank_mutation.txt or rank_mutation_top.txt
#' and return rankdf
#' @param path results path
#' @param top number of top ranks
#' @param mutation name of mutation
#' @param initJar t of f
#' @param bio_colnames total cell type names
#'
#' readFile(path, top, mutation, initJar, bio_colnames)

readFile <- function(path, top, mutation, initJar, bio_colnames){

  if(top == 1){
    top <- 2
  }

  if(toupper(initJar) == "T"){
    br = paste0(path, "rank_", mutation, ".txt")
  }else if(toupper(initJar) == "F"){
    br = paste0(path, "rank_", mutation,"_", top, ".txt")
  }else{
    br = "err"
  }
  for (i in 1:length(readLines(br))){
    tmpline <- readLines(br)[i]
    tmpline <- str_split(tmpline," ")[[1]]
    tmpline <- tmpline[tmpline != ""]
    if (i == 1){
      typelist <- tmpline
      ranklist <- c(1:length(tmpline))
      rankdf <- data.frame(typelist, ranklist)
      for (j in bio_colnames[!(bio_colnames %in% typelist)]){
        rankdf <- rbind(rankdf, c(j,10000))
      }
    }else{
      rankdf[!(rankdf[,1] %in% tmpline),2] <- as.numeric(rankdf[!(rankdf[,1] %in% tmpline),2])+10000
      for (j in which(!(tmpline %in% rankdf[,1]))){
        rankdf <- rbind(rankdf, c(tmpline[j],10000))
      }
      for(j in 1:length(tmpline)){
        rankdf[rankdf$typelist == tmpline[j],2] <- as.numeric(rankdf[rankdf$typelist == tmpline[j],2])+j
      }
    }

  }
  rankdf <- rankdf[order(as.numeric(rankdf$ranklist)),]
  rownames(rankdf) = NULL
  rankdf <- rankdf[c(1:top),]
  return(rankdf)
}
