#' ---
#' title: "Predictor import for R analysis"
#' author: "Paul Czechowski"
#' date: "August 11th, 2016"
#' output: pdf_document
#' toc: true
#' highlight: zenburn
#' bibliography: ./references.bib
#' ---
#'
#' # Preface
#' 
#' This code is tested using a raw R terminal. Path names are defined relative 
#' to the project directory. This code commentary is included in the R code 
#' itself and can be rendered at any stage using  `rmarkdown::render ("./10_import_predictors.R")`. 
#' Please check the session info below for
#' further notes on the coding environment.
#'
#' # Prerequisites  
#' 
#' * This script is located in the project parent directory.
#' * Contents of the Zenodo repository have been added to a folder `Zenodo` in 
#' the project parent directory.
#' * `predictors.csv` is availabale at `/Zenodo/Environment/`
#'
#' # Environment preparation
#'
#' Packages loading and cleaning of work-space:
#+ message=FALSE, results='hide' 
rm(list=ls())        # clear R environment
                     #   working directory current directory by default and not set

#' ## Setting location of data for import
#' 
#' Path names to x-ray diffraction and soil geochemical data are defined:  
path_obs <- "./Zenodo/Environment/predictors.csv"

#' # Data import
#' 
#' Soil geochemical and X-Ray diffraction data is imported using basic R functionality
predictors <- read.csv(path_obs, stringsAsFactors = FALSE)

#' ## Check data dimensions
#' 
#' An initial look at the `pred` data frame with the predictor variables can be done here.
#+ include=TRUE
str(predictors)

#' # Write data to disk 
#' 
#' Saved are object created by this script as well as command history and work-space
#' image. The number in front of the file name denotes the source script.
save (predictors, file = "./Zenodo/R_Objects/10_predictors.Rdata")  # data frame
save.image ("./Zenodo/R_Objects/10_workspace.Rdata")                # work-space

#' # Session info
#' 
#' The code and output in this document were tested and generated in the 
#' following computing environment:
#+ echo=FALSE
sessionInfo()
