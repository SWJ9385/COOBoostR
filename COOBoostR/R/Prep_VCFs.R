#' Prep_VCFs() function
#'
#' This function preprocesses the bed file to fit 1mb.
#'
#' @param VCF_path VCF file path
#' @param resultpath results path
#' @param mb1_path mb1 file path
#' @param VCF_sep bed file separator, default = "\t"
#' @param VCF_header bed file header, default = F
#'
#' Prep_VCFs(VCF_path, resultpath, mb1_path, VCF_sep, VCF_header)
#' @export

Prep_VCFs <- function(VCF_path, resultpath, mb1_path, VCF_sep = "\t", VCF_header = F){
  
  file_list <- list.files(VCF_path)
  
  for (j in file_list){
    
    VCF_file <- read.table(paste0(VCF_path, j),sep = VCF_sep, header = VCF_header)
    VCF_file[,1] <- paste0("chr", as.numeric(gsub("\\D","",VCF_file[,1])))
    mb1 <- read.csv(paste0(mb1_path),sep = "\t", header = F)
    mb1$V5 <- 0 
    
    for (i in 1:dim(mb1)[1]){
      tmp_vcf <- subset(VCF_file, VCF_file[,1] == mb1$V1[i])
      tmp_vcf <- subset(tmp_vcf, tmp_vcf[,2] >= mb1$V2[i])
      tmp_vcf <- subset(tmp_vcf, tmp_vcf[,2] <= mb1$V3[i])
      mb1$V5[i] <-dim(tmp_vcf)[1] + mb1$V5[i]
      
    }
    write.table(mb1, paste0(resultpath,j,"_converted_VCF.csv"), row.names = F, col.names = F, quote = F, sep = ",")
  }
  
}
