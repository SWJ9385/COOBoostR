rm(list=ls())


#1. VCF file to test matrix
# VCF_path : The location of the VCF files, and it must end with a delimiter (/).
VCF_path <- "path/to/VCF_files/"
# resultsPath : The directory where the results will be saved after analysis. Must end with a delimiter (/).
resultpath <- "path/to/result_files/"
# mb1_path : The location of 1mb_paper.bed
mb1_path <- "path/to/1mb_paper.bed"
# VCF_sep : VCF file separator, default = tap
# VCF_heder : VCF file header, default = F

Prep_VCFs(VCF_path, resultpath, mb1_path, VCF_sep = "\t", VCF_header = F)

#2. BED file to test matrix
# BED_path : The location of the BED files, and it must end with a delimiter (/).
BED_path <- "path/to/BED_files/"
# resultsPath : The directory where the results will be saved after analysis. Must end with a delimiter (/).
resultpath <- "path/to/result_files/"
# mb1_path : The location of 1mb_paper.bed
mb1_path <- "path/to/1mb_paper.bed"
# BED_sep : BED file separator, default = tap
# BED_heder : BED file header, default = F
# BED_form : bed4 or bed5, default = "bed4"

Prep_BEDs(BED_path, resultpath, mb1_path, BED_sep = ",", BED_header = F, BED_form = "bed5")

# Run COOBoostR
# Set the working directory as COOBoostR/COOBoostR/ for package installation.
packagePath <- "path/to/COOBoostRpackage/"
setwd(packagePath)
set.seed(1708)
 
# Installing packages using devtools and load COOBoostR.
devtools::install()
library("COOBoostR")
 
# sourcePath : Directory with data needed for analysis(epimarker, mutation). Must end with a delimiter (/).
sourcePath <- "path/to/tutorial_data/"
# resultsPath : The directory where the results will be saved after analysis. Must end with a delimiter (/).
resultsPath <- "path/to/results/" 
 
# Data generated through 1mb preprocessing. Requires csv format.(You need a csv file name, not a data frame or variable.)
epimarker <- "COO_epimarker.csv"
mutation <- "COO_mutation.csv"
 
# Analysis with COOBoostR
COOBoostR(sourcePath = sourcePath, resultPath = resultPath ,epimarker_rawdata = epimarker , mutation_rawdata = mutation, mEta = 0.01, mdepth = 2)
