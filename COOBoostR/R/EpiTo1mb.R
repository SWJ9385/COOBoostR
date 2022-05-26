#' EpiTo1mb() function
#'
#' This function preprocesses the bed file to fit 1mb.
#'
#' @param bedpath bedfile path
#' @param resultpath results path
#' @param mb1_path mb1 file path
#' @param bedform bed4 or bed5, default = "bed4"
#' @param bed_sep bed file separator, default = ","
#' @param bed_header bed file header, default = F
#'
#' EpiTo1mb(bedpath, resultpath, mb1_path, bedform, bed_sep, bed_header)


EpiTo1mb <- function(bedpath, resultpath, mb1_path, bed_sep = ",", bed_header = F, bedform = "bed4"){
  
  file_list <- list.files(bedpath)
  
  if (bedform == "bed4"){
    
    for (j in file_list){
      
      bed_file <- read.csv(paste0(bedpath, j),sep = bed_sep, header = bed_header)
      mb1 <- read.csv(paste0(mb1_path),sep = "\t", header = F)
      mb1$V5 <- 0 
      
      for (i in 1:dim(mb1)[1]){
        tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V2 >= mb1$V2[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V3 <= mb1$V3[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
        tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V2 <= mb1$V3[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V3 >= mb1$V3[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
        tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V2 <= mb1$V2[i])
        tmp_bed <- subset(tmp_bed, tmp_bed$V3 >= mb1$V2[i])
        mb1$V5[i] <-dim(tmp_bed)[1] + mb1$V5[i]
        
      }
      
      write.table(mb1, paste0(resultpath,j,"_epi_converted.csv"), row.names = F, col.names = F, quote = F, sep = ",")
      
    }
    
    
    } else if(bedform == "bed5"){
      
      for (j in file_list){
        
        bed_file <- read.csv(paste0(bedpath, j),sep = bed_sep,header = bed_header)
        mb1 <- read.csv(paste0(mb1_path),sep = "\t",header = F)
        mb1$V5 <- 0 
        
        for (i in 1:dim(mb1)[1]){
          tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V2 >= mb1$V2[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V3 <= mb1$V3[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
          tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V2 <= mb1$V3[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V3 >= mb1$V3[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
          tmp_bed <- subset(bed_file, bed_file$V1 == mb1$V1[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V2 <= mb1$V2[i])
          tmp_bed <- subset(tmp_bed, tmp_bed$V3 >= mb1$V2[i])
          mb1$V5[i] <- sum(tmp_bed$V5) + mb1$V5[i]
          
        }
        
        write.table(mb1, paste0(resultpath,j,"_epi_converted.csv"), row.names = F, col.names = F, quote = F, sep = ",")
        
      }
      
    
    } else { 
    
    return(print("ERROR"))
    
    }
  
}
