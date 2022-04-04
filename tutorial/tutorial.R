rm(list=ls())

packagePath <- "path/to/COOBoostRpackage/"

devtools::install(packagePath)


sourcePath <- "path/to/tutorial_data/"
resultsPath <- "path/to/results/" 
epimarker <- "COO_epimarker.csv"
mutation <- "COO_mutation.csv"

COOBoostR(sourcePath = sourcePath, resultPath = resultPath ,epimarker_rawdata = epimarker_rawdata , mutation_rawdata = mutation_rawdata, mEta = 0.01, mdepth = 2)
