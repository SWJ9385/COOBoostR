#' reportFile() function
#'
#' This function produces a summary of the results.
#'
#' @param path results path
#'
#' reportFile(path)


reportFile <- function(path){
  
  output_dir <- path
  list_files <- list.files(output_dir, pattern = "extract")
  list_files <- gsub("output_", "", list_files)
  targetlist <- gsub("_extract.txt", "", list_files)
  
  for (k in targetlist){
    rank_test <- read.table(paste0(output_dir, "rank_",k,".txt"), fill = T)
    out_test <- read.table(paste0(output_dir, "output_",k,"_extract.txt"), fill = T)[-1,]
    
    out_test<-out_test[c(order(as.numeric(out_test$V1))),c(1,2)]
    rownames(out_test)<-NULL
    out_test[,3:11]<-0
    out_test <- out_test[,-1]
    colnames(out_test) <- c("type", paste0("rank_", rep(2:10)))
    
    for(i in 2:10){
      
      txt_file <- paste0(output_dir, "rank_", k, "_", i, ".txt")
      rank_test <- read.table(txt_file, fill = T)
      
      for (j in 1:i){
        
        test_table <- table(rank_test[,j]) * (11-j)
        for (l in 1:length(test_table)){
          out_test[out_test$type %in% data.frame(test_table)$Var1[l],i] <- out_test[out_test$type %in% data.frame(test_table)$Var1[l],i]+test_table[l]
        }
      }
      out_test[,i] <- out_test[,i]/sum(out_test[,i])
    }
    write.csv(out_test,paste0(output_dir, "/report_", k, ".csv"),row.names = F)
  }
  
}