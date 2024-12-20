% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Prep_VCFs.R
\name{Prep_VCFs}
\alias{Prep_VCFs}
\title{Prep_VCFs() function}
\usage{
Prep_VCFs(VCF_path, resultpath, mb1_path, VCF_sep = "\\t", VCF_header = F)
}
\arguments{
\item{VCF_path}{VCF file path}

\item{resultpath}{results path}

\item{mb1_path}{mb1 file path}

\item{VCF_sep}{VCF file separator, default = tap}

\item{VCF_header}{VCF file header, default = F

Prep_VCFs(VCF_path, resultpath, mb1_path, VCF_sep, VCF_header)}
}
\description{
This function preprocesses the bed file to fit 1mb.
}
