# COOBoostR
COOBoostR: An extreme gradient boosting-based tool for robust tissue or cell-of-origin prediction of tumors by R

![GitHub_figure re scaled](https://user-images.githubusercontent.com/85658413/167326301-b9246775-de95-4662-96d3-89a22d0d9048.svg)

## Input Data Description
COOBoost  takes two values of training data and test data as input and predicts the tissue-of-origin (TOO) or cell-of-origin (COO) of human cells and tissues. The test data is the somatic mutation profiles of human cells/tissues from which the user wants to predict TOO or COO. The training data are another type of profiles used to predict the TOO or COO from the mutation data. Histone modification profile, fixed-tissue chromatin immunoprecipitation sequencing (Fit-seq) profile, and single cell ATAC sequencing (scATAC-seq) profile can be used for training input, and if desired, COO can be performed by replacing scRNA-seq profiling instead of these chromatin features .

#### test mutation data   
In COOBoostR, mutation data that the user wants to predict TOO/COO receives the vcf file with the somatic mutation calling process completed. Before executing COOBoostR, the user must go through three verification processes. If the input vcf file is not suitable for COOBoostR, it is necessary to modify the vcf file through the following vcf preprocessing process .

Insertion deletion(INDEL) remove 
When performing mutation calling, some programs extract mutations including INDEL. Since the COOBoost algorithm operates based on somatic mutation profiles, if an INDEL is included in the user's vcf file, it must be removed. A program that can be used for this is vcftools (http://vcftools.sourceforge.net/), and you can use the following command to remove INDEL from your vcf file.
```bash
vcftools --vcf input.vcf --recode --remove-indels --out output.vcf 
```
Reference mapping  
COOBoost does not receive the somatic mutation data contained in the vcf file as it is, but receives a file in which the mutation frequency is applied to the data transformed in units of 1 Mbp window. For accurate analysis, the same version of the human reference genome should be used. Since the 1 Mbp window conversion is set based on the hg19/GRch37 human genome reference, if the user's vcf file is a file called based on the reference of another version, it must be lifted with the hg19 version. For this process, you can use the CrossMap tool (http://crossmap.sourceforge.net), and modify the vcf file with hg19 version by using the chain file that matches the reference version used in the mutation calling process .

Chromosome notation  
In the VCF file, mutation genomic coordinates are listed from the chromosome number. However, depending on the type of VCF file, there are cases where the chromosome number is written only as numbers like 1,2,3.., and there are cases where ‘chr’ is additionally attached like chr1, chr2, chr3. In order to perform mutation counting in units of 1 Mbp window in the somatic mutation vcf file, this notation must be unified. If there is no notation of 'chr' in the user's input vcf file, the vcf file can be modified with the following simple perl command. (The 1megabase region we use is marked with 'chr' notation)
 ```bash
perl -pe 's/^([^#])/chr\1/' input.vcf > output.vcf 
```
COOBoostR accepts the regional mutation density estimated in 1 Mbp window size. This 1Mbp window size was not arbitrary, but was frequently used on related publications from two different groups. Polak et al (PMID: 25693567) used 1 Mbp window in their entire paper, including random forest algorithm based feature selection and other analyses. In the case of Schuster-Bockler et al (PMID: 22820252), they also used 1 Mbp window for their core analyses on assessing the correlation between cancer SNVs and different chromatin levels. In addition, this paper showed that the correlation level was lower for smaller windows (10kb and 100kb) comparing to larger windows (1 Mbp and 10 Mbp), which could be due to low median number of SNVs per window. Counting the frequency of  mutations in 1 Mbp window from the user input vcf file can be calculated using bedtools (https://bedtools.readthedocs.io/en/latest/) and the 1 Mbp genomic coordinates file that we have uploaded to the tutorial folder (1mb_paper.bed).
COOBoostR/tutorial/1mb_paper.bed

```bash
bedtools intersect -a 1mb_paper.bed -b input_vcffile -c > output.bed 
```

The  1mb_paper.bed file we put in the tutorial folder contains an autosomal genomic coordinates divided into 1 Mbp window according to human genome reference 19 version, based on this, it is possible to measure the frequency of mutations in the user's input vcf file. However, since the method using bedtools can handle only one vcf file, it is cumbersome to process vcf files of multiple samples. So, we are supporting this pre-processing function in COOBoostR to perform 1 Mbp window counting for all vcf files at a time, and to create a unified mutation matrix. Users only need to collect vcf files in one folder and perform the following functions.
By  utilizing the mutation counting function, a matrix is created in which the mutation frequency of each vcf file is measured for every 2,128 regions. Users can use this matrix as input data for TOO/COO predictions. We made three sample matrix with virtual random values as example files and made them as tutorial that users can reproduce how to use COOBoostR. ‘COO_mutation.csv’ file is the tutorial matrix for the test set, and the mutation type included in this file borrowed the Barrett’s esophagus, Esophageal adenocarcinoma, and Esophageal squamous cell carcinoma used in the previous study (PMID: 29263826) that performed TOO prediction for precancerous and cancerous lesions. The values included in this tutorial data are virtual data randomly created based on the quartile of the existing mutation profiles. When the user prepares the test set data in this form, the first input matrix required for COOBoostR is completed .

#### training chromatin feature data
 Normal  cell level chromatin feature data is used as learning material before testing mutation data. In general, chrmoatin feature data uses ChIP-seq-based histone modification profiling, but fit-seq or scATAC-seq can also be used. Like the mutation preprocessing process, training data is also inputted into a matrix transformed by 1 Mbp window, rather than using the original value in COOBoostR. Users can freely configure the dataset they want to use to construct the learning model of COOBoost, and preprocess the file paying attention to the Reference version mapping, and Chromosome notation mentioned above. When the bed format file containing the chromatin feature data that has progressed up to the reference aligning process is ready, counting can be performed in units of 1 Mbp window just like creating a test mutation matrix. If you want to make multiple cell types into one matrix, you can perform the following functions prepared in COOBoostR.
The  training data set we prepared as a tutorial is a virtual random value of human chromatin data extracted from ChIP-seq. A total of 24 sample training data of kidney, liver, lung, CD19, CD3, colonic mucosa, esophagus, and gastric type, which were also used in previous studies (PMID: 29263826), were generated based on the quartile values of the existing chromatin profile. From this training matrix, COOBoostR works by determining the TOO/COO of each sample by measuring which type of chromatin feature among cell types can best explain the mutation profiles. We will perform TOO/COO predictions using 24 ChIP-seq features with virtual random value as a tutorial training data, but it is also possible to increase the number of this training set further if desired. If it is assumed that the experimental conditions and development method of the chromatin data are the identical, it is sufficiently possible to configure more than 100 training sets .

### preprocess 

--------------------------------
## Development Environment
 
- Language : R script
- Integrated Development Environment : Rstudio
```bash
    platform       x86_64-apple-darwin15.6.0   
    arch           x86_64                      
    os             darwin15.6.0                
    system         x86_64, darwin15.6.0        
    major          3                           
    minor          5.1                         
    year           2018                        
    month          07                          
    day            02                          
    svn rev        74947                       
    language       R                           
    version.string R version 3.5.1 (2018-07-02)
```
- Executable Operating System(OS) : Linux(e.g Ubuntu)
- COOBoostR imports R package xgboost and stringr 
--------------------------------
## Tutorial
 
```R 
rm(list=ls())
 
# Set the working directory as COOBoostR/COOBoostR/ for package installation.
packagePath <- "path/to/COOBoostRpackage/"
setwd(packagePath)
 
# Installing packages using devtools and load COOBoostR.
devtools::install()
library("COOBoostR")
 
# sourcePath : Directory with data needed for analysis(epimarker, mutation).
sourcePath <- "path/to/tutorial_data/"
# resultsPath : The directory where the results will be saved after analysis. 
resultsPath <- "path/to/results/" 
 
# Data generated through 1mb preprocessing. Requires csv format.(You need a csv file name, not a data frame or variable.)
epimarker <- "COO_epimarker.csv"
mutation <- "COO_mutation.csv"
 
# Analysis with COOBoostR
COOBoostR(sourcePath = sourcePath, resultPath = resultPath ,epimarker_rawdata = epimarker , mutation_rawdata = mutation, mEta = 0.01, mdepth = 2)
```
--------------------------------

## Final Output description
Once the matrix is completed through the preparation process of input data, TOO/COO prediction for each sample is possible through COOBoostR. The output from COOBoostR is one csv file that summarizes the results of all the samples, and there are several txt file groups that contain log data such as evaluation score.

#Summary output

Summary output is integrated TOO/COO prediction results for the test samples. It is like a synthesis of the results for the three types (Barret’s esophagus, Esophageal adenocarcinoma, Esophageal squamous cell carcinoma) presented in the tutorial. If the user is not interested in the detailed log information of COOBoost, it is okay to check only this file. 

If you look at the tutorial analysis results, the TOO/COO prediction results for the three types are arranged in order. Rank 1 - The type of training features can be interpreted as the type predicted TOO/COO. That is, TOO of Barrett's esophaugs is gastric, and TOO of esophageal adenocarcinoma is also gastric, but in the case of Esophageal squamous cell carcinoma, esophaugs can be interpreted as TOO. 

In the summary output, training features up to 10th place are recorded. These 10 rankings were determined by removing the features that obtained low scores one by one from the rank 20 training features (backward eliminiation). The summary output also includes information on the probability that training features are predicted to be TOO in each step of the iterative test. Looking at the example of Barrett's esophagus, it means that the gastric feature was predicted as TOO with a 57% probability when the last two training features were left. 

 

# Multiple log files 

COOBoostR provides four types of original log files that occur during the TOO/COO prediction process. The log file includes basic operation information of the algorithm beyond the TOO/COO Summary output result, so it is possible to collect files if the user wants. 

 

"evalLog_****" - model training log file 

It is a log file that collects training and test error values from repeated tests. If you check the train and test error values of the tutorial data, you can see that abnormally high values are recorded. This is a phenomenon that occurs because the method of COOBoostR operates differently from the calculation of this error value. Generally, the XGBoost algorithm learns from a large number of samples and measures the error rate based on the model. In the case of COOBoostR, 1 Mbp region selection, not sample selection, works in the same way as predicting TOO/COO with the preceding random-forest based algorithm (PMID: 25693567). In more detail, when the training and test matrices come into COOBoostR as inputs, the 2,128 regions are randomly divided in a 9:1 ratio, and the error rate of the tree model is measured in this form. This is a characteristic of the TOO/COO prediction algorithm that defines one specific type rather than repeatedly configuring the same cell type when constructing the training matrix, which is not suitable for evaluation of the existing XGBoost algorithm. 

"output_****_extract" - ordered feature list after back-elimination Simply you need to use and identify this output result 

"rank_****" - feature importance sets while training models It is possible to change feature count due to back-elimination 

"time_****" - you can check execution time using not only whole features but also back-elimination feature list 
