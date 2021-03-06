#' ---
#' title: "Plotting uncorrected `phyloseq` object (**Needed for figure in main text**)"
#' author: "Paul Czechowski"
#' date: "October 22nd, 2016"
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
#' itself and can be rendered at any stage using 
#' `rmarkdown::render ("42_plot_uncorrected.r")`. Please check the session info 
#' at the end of the document for further notes on the coding environment.
#' 
#' # Prerequisites
#' 
#' * This script is in the parent directory of the repository. 
#' * Scripts `10_import_predictors.r`, `20_format_predictors.r`,
#'   and `30_format_phyloseq.r`were run.
#' * Script `00_functions.r` is available .
#' * Output of these scripts is available throughout the repository directory
#'   tree.
#' 
#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#' 
#' # Environment preparation
#'
#' ## Package loading and cleaning of work-space
#+ message=FALSE, results='hide'
library ("phyloseq")   # required for working with phyloseq objects
library ("ggbiplot")   # package for simple generation of PCA biplots
library ("ggplot2")    # package used for barplot (for themes()) 
library ("corrplot")   # plotting of correlations ...
library ("ggcorrplot") # ... which can be saved to disk 
library ("gridExtra")  # re-arranging graphical objects 
library ("GGally")     # scatter plot matrices (geochemical and combined data)
library ("vegan")      # CCA and MDS
library ("dplyr")      # for easier reading of complex expressions
rm(list=ls())          # clear R environment
                       # working directory needs to be set manually for
                       #   cross-platform compatibility

#' ## Setting locations for data import and export
#' 
#' This script uses the objects generated by `30_format_phyloseq.r` that are located
#' in the `Zenodo` directory tree. It will also write to that location. The 
#' number in front of the file name denotes the source script.
#'
#' ### Import locations
#'
#' Path to filtered, not abundance-corrected data with curated taxonomy and field
#' measurements.
path_phsq_ob <- file.path ("Zenodo/R_Objects/37_phsq_ob.Rdata",
                           fsep = .Platform$file.sep) 
#' ### Export locations
#'
#' Workspace image for future reference, after plotiing and after analyses.
path_workspace_b    <- file.path ("Zenodo/R_Objects/42_020_workspace.Rdata",
                                fsep = .Platform$file.sep)

#' Graphics for main manuscript and supplemental information. Mostly unused.
path_abnds   <- file.path ('Zenodo/R_Output/42-010_abundances.pdf', 
                          fsep = .Platform$file.sep)
path_coord   <- file.path ('Zenodo/R_Output/42-020_coordinates.csv', 
                          fsep = .Platform$file.sep)
path_brplts  <- file.path ('Zenodo/R_Output/42-030_barplots.pdf', 
                          fsep = .Platform$file.sep)
path_map_pcm <- file.path ('Zenodo/R_Output/42-040_map_pcm.pdf', 
                          fsep = .Platform$file.sep)
path_all_cor <- file.path ('Zenodo/R_Output/42-050_cor_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_min_cor <- file.path ('Zenodo/R_Output/42-060_cor_min_vars.pdf', 
                          fsep = .Platform$file.sep)
path_sca_tra <- file.path ('Zenodo/R_Output/42-070_sca_tra_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_vio_tra <- file.path ('Zenodo/R_Output/42-080_vio_tra_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_pca_var <- file.path ('Zenodo/R_Output/42-090_pca_var_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_pca_bip <- file.path ('Zenodo/R_Output/42-110_pca_bip_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_mds_hip <- file.path ('Zenodo/R_Output/42-120_mds_mds_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_hmp_all <- file.path ('Zenodo/R_Output/42-130_hmp_____all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_regr    <- file.path ('Zenodo/R_Output/42-140_regr_age_chem.pdf', 
                          fsep = .Platform$file.sep)


#' ## Loading functions
#'
#' This script uses many functions, and it impractical  to have them all in here.
#' They are loaded from `00_functions.R`.
source (file.path ("00_functions.r", fsep = .Platform$file.sep))

#' ## Data import
#' 
#' Phylotype data is imported using basic R functionality. Imported are `phyloseq`
#' objects [@McMurdie2013].
load (path_phsq_ob) # object name is "phsq_ob"

#' ## Defining predictor categories
#' 
#' These character vectors can be passed to `get_predictors()` to create data 
#' frames with customised variable content.
geochems <- c ("AMMN", "NITR", "POTA", "SLPH", "COND", "PHCC",  "PHOS", "CARB",
               "PHHO")
                        # "AMMN" and "NITR" with 57% and 47% undefined data
                        #   may be removed, these may hold important 
                        #   information. "PHOS" "CARB" may be removed because not 
                        #   relevant for MM?
minerals <- c ("QUTZ", "FDSP", "TTAN", "PRAG", "MICA", "DOLO", "KAOC")  
                        # "CALC" with 33 NA's and "CHLR" with 52 NA's
                        #   are removed, otherwise the MM mineral composition
                        #   can't be analysed 
location <- c ("AREA")
position <- c ("LONG", "LATI") # for spatial distance matrices
raw_ages <- c ("LAGE", "HAGE") # low and high age estimate

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#'
#' # Describe imported `phyloseq` object 
#' 
#' ## Invertebrate abundances per sample
#'
#' The following plots are agglomerated on a specified level by calling 
#' `agglomerate()`. The first plot shows proportional abundance of invertebrates
#' in rarefied data. In the second plot, all abundances are converted to "1",
#' (via `make_binary ()`)and the rank composition is more visible. Create the 
#' plots.:
pl1 <- barplot_samples (agglomerate (phsq_ob, "Class"), "Class")
pl2 <- barplot_samples (make_binary (agglomerate (phsq_ob, "Class")), "Class")

#' Showing the plots.:
#+ message=FALSE, results='hide', warning=FALSE, fig.width=7, fig.height=7, dpi=200, fig.align='center',  fig.cap="Invertebrate abundances at selected taxonomic level. Abundances are raw sequence counts! (approx. code line 145)"
grid.arrange(pl1, pl2, nrow = 2)

#' Save the plots.:
ggsave (file = path_abnds, plot = arrangeGrob (pl1, pl2, nrow = 2), 
        dpi = 200, width = 7, height = 7, units = "in")

#' Garbage collection.
rm(pl1, pl2)

#' ## Invertebrate abundances per location
#'
#' Bar-plot taxa  by locations. Firstly, building a list which can be used 
#' to give and take from plotting function. "[[ ]]" will get the atomic 
#' vector rather then a sub-data frame, to give a character vector of length 
#' three (3 locations).
areas <- unique (as.character (as.data.frame (sample_data (phsq_ob))[["AREA"]]))

#' An object will be agglomerated on class level to match the previous plots. 
phsq_agg <- agglomerate (phsq_ob, "Class")

#' `subset_samples()` and `lapply()` are still not friends, but subsetting 
#' per location is still necessary.
phsq_obs <- list (subset_samples (phsq_ob, 
                                  sample_data (phsq_ob)[, "AREA"] == areas[[1]]),
                  subset_samples (phsq_ob, 
                                  sample_data (phsq_ob)[, "AREA"] == areas[[2]]),
                  subset_samples (phsq_ob, 
                                  sample_data (phsq_ob)[, "AREA"] == areas[[3]]))

#' I will also filter for empty sample columns, as no empty are columns wanted 
#' in plots.
phsq_obs <- lapply (phsq_obs, remove_empty)

#' Looks like `plot_bar()` doesn't like `lapply()` either, as it looks, so I 
#' need to create a plot for each location individually. 
plots <- list (plot_bar (phsq_obs[[1]], fill = "Class", facet_grid = "Phylum~AREA") +
                 theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1,
                 size = 8), strip.text.x = element_text(size = 12), 
                 strip.text.y = element_text(size = 12, angle = 0), 
                 axis.text.y = element_text (size = 8)) +
                 geom_bar ( aes(color = Class, fill = Class), stat="identity",
                 position="stack"),
               plot_bar (phsq_obs[[3]], fill = "Class", facet_grid = "Phylum~AREA") + 
                 theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1, 
                 size = 8), strip.text.x = element_text(size = 12), 
                 strip.text.y = element_text(size = 12, angle = 0),
                 axis.text.y = element_text (size = 8)) +
                 geom_bar ( aes(color = Class, fill = Class), stat="identity",
                 position="stack"),
               plot_bar (phsq_obs[[2]], fill = "Class", facet_grid = "Phylum~AREA") +
                 theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1,
                 size = 8), strip.text.x = element_text(size = 12), 
                 strip.text.y = element_text(size = 12, angle = 0),
                 axis.text.y = element_text (size = 8)) +
                 geom_bar ( aes(color = Class, fill = Class), stat="identity",
                 position="stack"))

#' Plots can now be shown, and saved to the output directory. Objects are then
#' discarded.
#+ message=FALSE, results='hide', warning=FALSE, fig.width=7, fig.height=10, dpi=200, fig.align='center',  fig.cap="Invertebrate class and phylum composition per sampling location, with uncorrected abundances (!). (Approx. code line 205)"
grid.arrange(plots[[1]], plots[[2]], plots[[3]], nrow = 3)

#' Saving plots.:
ggsave (file = path_brplts, plot = arrangeGrob (plots[[1]], plots[[2]],
                                                plots[[3]], nrow = 3), 
        dpi = 200, width = 7, height = 10, units = "in")

#' Garbage collection.:
rm (plots, phsq_obs, phsq_agg)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#'
#' # Write data to disk 
#'
#' Saved are object created by this script as well as command history and work-space
#' image.
save.image (path_workspace_b)                    # work-space

#' # Session info
#' 
#' The code and output in this document were tested and generated in the 
#' following computing environment:
#+ echo=FALSE
sessionInfo()

#' # References 
