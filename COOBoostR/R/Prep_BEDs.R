#' Prep_BEDs() function
#'
#' This function preprocesses the bed file to fit 1mb.
#'
#' @param BED_path bedfile path
#' @param resultpath results path
#' @param mb1_path mb1 file path
#' @param BED_form bed4 or bed5, default = "bed4"
#' @param BED_sep bed file separator, default = ","
#' @param BED_header bed file header, default = F
#'
#' Prep_BEDs(BED_path, resultpath, mb1_path, BED_form, BED_sep, BED_header)
#' @export

Prep_BEDs <- function(BED_path, resultpath, mb1_path, BED_sep = ",", BED_header = F, BED_form = "bed4"){
  
  file_list <- list.files(BED_path)
  
  if (BED_form == "bed4"){
    
    for (j in file_list){
      
      BED_file <- read.csv(paste0(BED_path, j),sep = BED_sep, header = BED_header)
      mb1 <- read.csv(paste0(mb1_path),sep = "\t", header = F)
      mb1$V5 <- 0 
      
      for (i in 1:dim(mb1)[1]){
        tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,2] >= mb1$V2[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,3] <= mb1$V3[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
        tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,2] < mb1$V3[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,3] > mb1$V3[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
        tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,2] < mb1$V2[i])
        tmp_bed <- subset(tmp_bed, tmp_bed[,3] > mb1$V2[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
      }
      
      write.table(mb1, paste0(resultpath,j,"_converted_BED.csv"), row.names = F, col.names = F, quote = F, sep = ",")
      
    }
    
    
    } else if(BED_form == "bed5"){
      
      for (j in file_list){
        
        BED_file <- read.csv(paste0(BED_path, j),sep = BED_sep,header = BED_header)
        mb1 <- read.csv(paste0(mb1_path),sep = "\t",header = F)
        mb1$V5 <- 0 
        
        for (i in 1:dim(mb1)[1]){
          tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,2] >= mb1$V2[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,3] <= mb1$V3[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
          tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,2] < mb1$V3[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,3] > mb1$V3[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
          tmp_bed <- subset(BED_file, BED_file[,1] == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,2] < mb1$V2[i])
          tmp_bed <- subset(tmp_bed, tmp_bed[,3] > mb1$V2[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
        }
        
        write.table(mb1, paste0(resultpath,j,"_converted_BED.csv"), row.names = F, col.names = F, quote = F, sep = ",")
        
      }
      
    
    } else { 
    
    return(print("ERROR"))
    
    }
  
}
