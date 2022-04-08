# COOBoostR
COOBoostR: An extreme gradient boosting-based tool for robust tissue or cell-of-origin prediction of tumors by R
## Input Data Description
1. COO_epimarker.csv(4*1915)
4 columns (Barrett, Gastric, Ileum, Squamous)

2. COO_mutation.csv(2*1915)
2 samples (BA and EAC)

### preprocess 

#### 1MB 

collect somatic mutation density by 1 Mega base pairs(Mbp) with bedtools(https://bedtools.readthedocs.io/en/latest/).

bedtools intersect -a megabase_map -b input_bedfile -c > output

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
--------------------------------
## Final Output description

--------------------------------


