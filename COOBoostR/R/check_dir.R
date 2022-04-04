#' check_dir() function
#'
#' This function checks mainDir and subdir
#' If there is no directory, create one.
#' @param mainDir sourcePath
#' @param subDir mutation_rawdata name
#' @keywords : check and create dir

check_dir <- function(mainDir,subDir){
  temp <- paste0(mainDir,subDir)

  if (!file.exists(temp)){
    #dir.create(file.path(temp))
    dir.create(file.path(mainDir, subDir), recursive = TRUE)
  }
}
