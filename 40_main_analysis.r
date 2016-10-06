#' ---
#' title: "Main analysis"
#' author: "Paul Czechowski"
#' date: "October 4th, 2016"
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
#' `rmarkdown::render ("40_main_analysis.r")`. Please check the session info 
#' at the end of the document for further notes on the coding environment.

#' # Prerequisites
#' 
#' * This script is in the parent directory of the repository. 
#' * Scripts `10_import_predictors.r`, `20_format_predictors.r`,
#'   (`25_rarefy_phyloseq.r`,) and `30_format_phyloseq.r`were run.
#' * Script `00_functions.r`was run.
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
# path to filtered, abundance corrected data with curated taxonomy and field
#   measurements
path_phsq_ob <- file.path ("Zenodo/R_Objects/30_phsq_ob.Rdata",
                           fsep = .Platform$file.sep) 
#' ### Export locations
#'
#' Workspace image for future reference, after plotiing and after analyses.
path_workspace_a    <- file.path ("Zenodo/R_Objects/40_010_workspace.Rdata",
                                fsep = .Platform$file.sep)

path_workspace_b    <- file.path ("Zenodo/R_Objects/40_020_workspace.Rdata",
                                fsep = .Platform$file.sep)



# graphics for main manuscript and supplemental information 
path_abnds   <- file.path ('Zenodo/R_Output/40-010_abundances.pdf', 
                          fsep = .Platform$file.sep)
path_coord   <- file.path ('Zenodo/R_Output/40-020_coordinates.csv', 
                          fsep = .Platform$file.sep)
path_brplts  <- file.path ('Zenodo/R_Output/40-030_barplots.pdf', 
                          fsep = .Platform$file.sep)
path_map_pcm <- file.path ('Zenodo/R_Output/40-040_map_pcm.pdf', 
                          fsep = .Platform$file.sep)
path_all_cor <- file.path ('Zenodo/R_Output/40-050_cor_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_min_cor <- file.path ('Zenodo/R_Output/40-060_cor_min_vars.pdf', 
                          fsep = .Platform$file.sep)
path_sca_tra <- file.path ('Zenodo/R_Output/40-070_sca_tra_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_vio_tra <- file.path ('Zenodo/R_Output/40-080_vio_tra_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_pca_var <- file.path ('Zenodo/R_Output/40-090_pca_var_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_pca_bip <- file.path ('Zenodo/R_Output/40-110_pca_bip_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_mds_hip <- file.path ('Zenodo/R_Output/40-120_mds_mds_all_vars.pdf', 
                          fsep = .Platform$file.sep)
path_hmp_all <- file.path ('Zenodo/R_Output/04-130_hmp_____all_vars.pdf', 
                          fsep = .Platform$file.sep)

#' ## Loading functions
#'
#' This script uses many functions, and it impractical  to have them all in here.
#' They are loaded from `00_functions.R`.
source (file.path ("00_functions.r", fsep = .Platform$file.sep))

#' ## Data import
#' 
#' Phylotype data is imported using basic R functionality. Imported are phyloseq
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
position <- c ("LONG", "LATI")
                        # for spatial distance matrices
raw_ages <- c ("LAGE", "HAGE")
                        # low and high age estimate

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->

#' # Describe imported `phyloseq` object 
#' 
#' ## Invertebrate abundances per sample
#'
#' The following plots are agglomerated on a specified level by calling 
#' `agglomerate()`. The first plot shows proportional abundance of invertebrates
#' in rarefied data. In the second plot, all abundances are converted to "1",
#' (via `make_binary ()`)and the rank composition is more visible.

# create the plots
pl1 <- barplot_samples (agglomerate (phsq_ob, "Class"), "Class")
pl2 <- barplot_samples (make_binary (agglomerate (phsq_ob, "Class")), "Class")

# show the plots
#+ message=FALSE, results='hide', warning=FALSE, fig.width=7, fig.height=7, dpi=200, fig.align='center',  fig.cap="Invertebrate abundances at selected taxonomic level, rarefied. (approx. code line 158)"
grid.arrange(pl1, pl2, nrow = 2)

# save the plots
ggsave (file = path_abnds, plot = arrangeGrob (pl1, pl2, nrow = 2), 
        dpi = 200, width = 7, height = 7, units = "in")

# remove them from the environment
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
#+ message=FALSE, results='hide', warning=FALSE, fig.width=7, fig.height=10, dpi=200, fig.align='center',  fig.cap="Invertebrate class and phylum composition per sampling location, with rarefied abundances. (Approx. code line 205)"
# show plots
grid.arrange(plots[[2]], plots[[3]], plots[[1]], nrow = 3)

# save plots
ggsave (file = path_brplts, plot = arrangeGrob (plots[[2]], plots[[3]],
                                                plots[[1]], nrow = 3), 
        dpi = 200, width = 7, height = 10, units = "in")

# discard all objects related to barplots
rm (plots, phsq_obs, phsq_agg)

#' ## Map in addition to QGIS map 
#'
#' Here using an old function from repository `pcm_modelling`, which was minimally
#' adjusted for the current repository. Creating the map, plotting is here, and
#'saving it to file. Garbage collection afterwards.
phsq_map <- map_samples(phsq_ob, col_long = "LONG", col_lat = "LATI", 
  subtitle = "18S data")

#+ message=FALSE, results='hide', warning=FALSE, fig.width=10, fig.height=10, dpi=200, fig.align='center',  fig.cap="Smple range of responses and predictors (approx. code line 233)"
plot(phsq_map)

ggsave (path_map_pcm, plot = phsq_map, dpi = 200, width = 5.5, height = 4.5, 
  units = "in")

rm (phsq_map)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->

#' # Retrieve and write information from imported `phyloseq` object 
#'
#' Expand this section if further information is necessary for writing.
#' 
#' ## Mean elevation per sample
#'
#' Get elevation range for locations:
temp <- data.frame (sample_data (phsq_ob)[ , c("ELEV", "AREA")])

#' Output mean elevations per location:
summary (temp [ which (temp$AREA == "MM"),  "ELEV" ]) # MM
summary (temp [ which (temp$AREA == "ME"),  "ELEV" ]) # ME
summary (temp [ which (temp$AREA == "LT"),  "ELEV" ]) # LT

#' ## Write sample coordinates to be used with GIS software 
#'
#' Agglomeration beforehand is done only so that the data matches subsequent
#' analyses, just in case agglomerate changes the data (which it shouldn't, but
#' I haven't tested that is doesn't). The `.csv`file is used by
#' in Qgis file `/Zenodo/Qgis/map.qgs` in conjuction with the Quantarctica
#' package

# dplyr doesn't work here, storing object is necessary 
coordinates <- sample_data (agglomerate (phsq_ob, "Class"))[ , c ("LONG", "LATI",
  "AREA", "GENE")]

# see previously defined export path
write.table (as.data.frame (coordinates), file = path_coord, row.names	= TRUE,
  col.names = TRUE)
 
# garbage collection
rm (coordinates, temp)

#' # Saving intermediate workspace 
#'
#' Saving of temporary work space during coding, so that, code above doesn't
#' have to be run all the time, when changing the tiniest bit downstream.
save.image (path_workspace_a)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#' # Exploratory data analysis
#'
#' ##  Isolating data for this analysis 
#' 
#' Starting, again by getting the data frames. For now, unless `get_list()`
#' is modified, a lot is crammed into vector `pred_cat` which will be returned
#' in `obs`. Can't include `raw_ages` here, since it's rich in `NA`s and these
#' are filtered by `get_list()`.
matr_ana <- get_list (phsq_ob, tax_rank = "Class", pred_cat = c (geochems, 
  minerals, position), pres_abs = FALSE)

#' Returned as `data.frames` in list are `spc`, `obs`, `grp`, and `gen`.
grp <- matr_ana[["grp"]] # for PCA labels
spc <- matr_ana[["spc"]] # species data

#' `obs` is a mixture of things, which need to be treated separately in the
#' following. Hence some isolation work is necessary. The objects are erased from
#' the input list, as a precaution. ** There is a semicolon here!** Afterwards
#' `matr_ana[["obs"]]` is empty. 
posi <- matr_ana[["obs"]] [ , position]; matr_ana[["obs"]] [ , position] <- NULL  
chem <- matr_ana[["obs"]] [ , geochems]; matr_ana[["obs"]] [ , geochems] <- NULL  
minl <- matr_ana[["obs"]] [ , minerals]; matr_ana[["obs"]] [ , minerals] <- NULL
#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#' 
#' ##  Checking soil mineral and soil geochemical data
#'
#' ### Showing the initial state of the mineral and chemical data
#'
#' Isolated and combined mineral and chemical data from the `phyloseq` object,
#' congruent with rows in `spc`, `grp`, and `gen`.
#+ message=FALSE, results='hide', warning=FALSE, fig.width=16, fig.height=16, dpi=200, fig.align='center', fig.cap="Isolated and combined mineral and chemical data, unmodified. (approx. code line 289)"
ggpairs ( data.frame (chem, minl, check.rows = TRUE))
summary ( data.frame (chem, minl, check.rows = TRUE))
str (data.frame (chem, minl, check.rows = TRUE))

# violin plots for unmodified chemical data
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Chemical data per location, unmodified. (approx. code line 295)"
add_discretex (chem, grp, dfr_x_name = "AREA") %>% 
 get_violinplotlist ( . ,"AREA") %>%
 marrangeGrob ( . , nrow=3, ncol=3)
 
# violin plots for unmodified mineral data
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Mineral data per location, unmodified. (approx. code line 301)"
add_discretex (minl, grp, dfr_x_name = "AREA") %>% 
 get_violinplotlist ( . ,"AREA") %>%
 marrangeGrob ( . , nrow=3, ncol=3)

#' ###  Removing outliers in soil geochemical observations
#'
#' Many ordination approaches are sensitive to outliers, and perhaps this also
#' affects modelling approaches. Outliers are removed here and replaced with the
#' mean. If desired this could perhaps be left out at later stages. This is not
#' done for the rank / compositional mineral data, but only the soil geochemical
#' values.
chem <- remove_outliers (chem) 

#' ###  Transformations  
#'
#' These are helpful for all modelling attempts, PCA, and ANOVA approaches. 
#' 
#' Centred log ration transform for the mineral data as recommended by [@Ranganathan2011],
#' in order to use this data for PCA and alongside the chemical data. The 
#' transformation will remove rows from the data farame.
minl  <- data.frame (transform_clr (minl))

#' Yeo-Johnson transformation conducted here after recombining the data frame
#' (and garbage collection). 

# merging of data frame and garbage collection 
obs <- merge(chem, minl, by = "row.names", all = TRUE); rownames (obs) <- 
  obs$Row.names; obs$Row.names <- NULL ; rm (chem); rm(minl)

# transformation of combined mineral an chemical data 
obs <- transform_any (obs, method = c ("center", "scale", "YeoJohnson", "nzv")) 
obs <- obs[complete.cases(obs), ]

#' ### Plotting co-correlations
#'
#' A simple function call to see precisely, which variables are co-correlated.
#' Writing correlation plots to disk doesn't work (easily) with `corrplot()` using
#' `ggcorrplot()` instead now (shorten this!).

# getting correlations and p-values
corr_all <- ggcorrplot(cor (obs), hc.order = TRUE, type = "lower",
  outline.col = "white", p.mat = cor_pmat(obs),
  ggtheme = ggplot2::theme_gray,
  colors = c("#6D9EC1", "white", "#E46726"))

corr_min <-  ggcorrplot(cor (remove_cocorrelated(obs)), hc.order = TRUE, type = "lower",
  outline.col = "white", p.mat = cor_pmat(remove_cocorrelated(obs)), 
  ggtheme = ggplot2::theme_gray,
  colors = c("#6D9EC1", "white", "#E46726"))

# plot out
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=8, dpi=200, fig.align='center', fig.cap="removal of co-correlations  in yj transformed chemical data and clr yj transformed mineral data. (approx. code line 359)"
grid.arrange (corr_all,  corr_min , ncol=2)

# write to dik 
ggsave (path_all_cor, plot = corr_all, dpi = 200, width = 8, height = 4.5, 
  units = "in")
ggsave (path_min_cor, plot = corr_min, dpi = 200, width = 8, height = 4.5,
  units = "in")

# garbage cleaning
rm (path_all_cor, path_min_cor, corr_all, corr_min)

#' ###  Removing the co-correlated variables 
#' 
#' In addition to the plot above, the text confirms which 
#' variables are kept, and which ones are removed. 
obs <- remove_cocorrelated(obs)

#' ### Plotting out transformed mineral and chemical data
#'
#' Plot the data before it goes to into further analyses, only for checking.
#' Initially a scatterplot.

#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Scatterplot of centred and scaled mineral and chemical data (approx. code line 231)."
# saving this plot for disk-write
ggpairs (obs) # less co-correlation, less skew?
summary (obs)

# write data to disk (slooooooow)
pdf(path_sca_tra, height = 10, width = 10)
g <- ggpairs(obs)
print(g)
dev.off()

# garbage collection
rm (g)

#' And the violin plots.
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Violin plot of scaled mineral and chemical data. Note that several samples have been excluded when merging mineral and chemical data (approx. code line 235)."
add_discretex (obs, grp, dfr_x_name = "AREA") %>% 
 get_violinplotlist ( . ,"AREA") %>%
 marrangeGrob ( . , nrow=5, ncol=3)

# write data to disk (slooooooow)
g <- add_discretex (obs, grp, dfr_x_name = "AREA") %>% 
 get_violinplotlist ( . ,"AREA") %>%
 marrangeGrob ( . , nrow=5, ncol=3)

ggsave (path_vio_tra, plot = g, dpi = 200, width = 9, height = 9,
  units = "in")

# garbage collection
rm (g)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->

#' ## Principal component analysis
#' 
#' ### Getting the principal components
#' 
#' Principal components are retrieved for the `obs` data frame with the mineral
#' analysis values.
pcs <- prcomp (obs, center = FALSE, scale = FALSE) 

#' ### Testing the principal components
#'
#' Testing the principal components with a variance plot. Here on should only
#' interpret principal components with variances above 1.
#+ message=FALSE, warning=FALSE, fig.width=5, fig.height=5, dpi=200, fig.align='center', fig.cap="PCA variance plots of centred and scaled mineral data (approx. code line 759)"
plot_pcvars(pcs)

# write to disk
ggsave (path_pca_var, plot = last_plot (), path = NULL, scale = 1, width = 4, 
  height = 3, units = "in", dpi = 300)

#' ### Bi-plot (geochemical values)
#'
#' The biplot can be generated, after the variables in `grp` are subset to match
#' the `pcs` object, necessary for correct ovals in the plot.  
#+ message=FALSE, warning=FALSE, fig.width=8, fig.height=8, dpi=200, fig.align='center', fig.cap="PCA biplots on clr-transformed mineral data. CALC and CHLR excluded (too sparse at MM) (approx. code line 702)"
get_biplot(pcs, shorten_groups (grp, obs)) # `grp` is needed later without type
                                           #  conversion - don't expand this 
                                           #  expression!

# write to disk
ggsave (path_pca_bip, plot = last_plot (), scale = 1, width = 7, 
  height = 7, units = "in", dpi = 300)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#' 
#' ##  Checking species information 
#'
#' ### Showing the initial state of the species information 
#' 
#' Here used is the initial abundance data, which is abundance corrected using 
#' the CSS algorithm in Qiime [@Paulson2013] _"With CSS, raw counts are divided 
#' by the cumulative sum of counts up to a percentile determined using a data-driven 
#' approach."_ The data is shown using a scatterplot and a violin plot. 
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Scatter plot of cumulative sum-scaled species observations (approx. code line 467)."
ggpairs (spc)
summary (spc) 
#+ message=FALSE, results='hide', warning=FALSE, fig.width=12, fig.height=12, dpi=200, fig.align='center', fig.cap="Violin plot of cumulative sum-scaled species observations (approx. code line 470)."
add_discretex ( as.data.frame(spc), grp, dfr_x_name = "AREA") %>% 
 get_violinplotlist ( . ,"AREA") %>%
 marrangeGrob ( . , nrow=3, ncol=2)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->

#' # MDS trials 
#' 
#' ## Matching up phylotype and factor information. 
#'
#' Species observations have to match the observations.
spc <- cmpl_phylotypes(spc, obs)

#' ## Getting a `metaMDS` object from the species data
#' 
#' Calculating a `metaMDS` object on the `spc` data, for now without environmental
#' variables. Distance `jaccard` appears to be recommended in `vegan()`, 
#' `binary = TRUE` ensures correct distance calculation on presence / absence 
#' data. `try` is set higher, to look longer for solutions. Stress > 0.05 provides
#' an excellent representation in reduced dimensions, > 0.1 is great, > 0.2 is 
#' fair, and stress > 0.3 provides a poor representation. Inspect the generated 
#' model in the end. 
spc_mds <- metaMDS(spc, distance = "bray" ,  k = 2, try = 1000, trymax = 2000, 
  noshare = FALSE, wascores = TRUE, trace = 0, plot = FALSE, expand = TRUE, 
  binary = FALSE)

spc_mds # stress value is 0.07224375

#' ### Fitting environmental vectors 
#' 
env <- envfit(spc_mds, obs, permutations = 5000)
env

#+ message=FALSE, warning=FALSE, fig.width=10, fig.height=10, dpi=200, fig.align='center', fig.cap="MDS plot of species and mineral data, SLPH, FDSP with some significance here. Blue: Mount Menzies, Red: Lake Terrasovoje, Green: Mawson Escarpment  (approx. code line 465)"
par (mfrow = c (1, 1))
ordiplot (spc_mds, display = "sites" )
# ordihull (spc_mds, shorten_groups (grp, obs), col = c ("coral3", "chartreuse4", "cornflowerblue"))
ordiellipse(spc_mds, shorten_groups (grp, obs) , display = "sites", kind = "se", 
  conf = 0.95, label = T,  col = c ("red", "chartreuse4", "cornflowerblue"))
orditorp (spc_mds, display = "species", col="deepskyblue4", air = 0.01, cex = 1.0)
with (obs, ordisurf (spc_mds, SLPH, add = TRUE, col = "darkgoldenrod4" ))
# with (obs, ordisurf (spc_mds, AMMN, add = TRUE, col = "orange"))

# write data to disk (slooooooow)
pdf(path_mds_hip, height = 9, width = 9)
par (mfrow = c (1, 1))
ordiplot (spc_mds, display = "sites" )
# ordihull (spc_mds, shorten_groups (grp, obs), col = c ("coral3", "chartreuse4", "cornflowerblue"))
ordiellipse(spc_mds, shorten_groups (grp, obs) , display = "sites", kind = "se", 
  conf = 0.95, label = T,  col = c ("red", "chartreuse4", "cornflowerblue"))
orditorp (spc_mds, display = "species", col="deepskyblue4", air = 0.01, cex = 1.0)
with (obs, ordisurf (spc_mds, SLPH, add = TRUE, col = "darkgoldenrod4" ))
# with (obs, ordisurf (spc_mds, AMMN, add = TRUE, col = "orange"))
dev.off()

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
#' ## `adonis` trials
#'
#' Class beta diversity, expressed as distance `z = (log(2)-log(2*a+b+c)+log(a+b+c))/log(2)`
#' may be function of group means of all mineral and chemical variables. 
adonis (formula =  betadiver ( spc, "z") ~ AMMN + NITR + POTA + SLPH + PHOS + 
  CARB + PHHO + QUTZ + FDSP + TTAN + MICA + PRAG + DOLO + KAOC, data = obs, perm = 9999)

#' ## `envfit` trials
envfit(spc ~ AMMN + NITR + POTA + SLPH + PHOS + CARB + PHHO + QUTZ + FDSP + 
   TTAN + MICA + PRAG + DOLO + KAOC, data = obs, perm = 9999)

#' ## `CCorA` trials
#'
#' _"Canonical correlation analysis, following Brian McArdle's unpublished graduate
#' course notes, plus improvements to allow the  calculations in the case of very
#' sparse and collinear matrices, and permutation test of Pillai's trace 
#' statistic."_
out <- CCorA (decostand (spc, "hel"), obs, stand.Y = FALSE, stand.X = TRUE,
  permutations = 10000)
biplot(out, "ob")                 # Two plots of objects
biplot(out, "v", cex=c(0.7,0.6))  # Two plots of variables
biplot(out, "ov", cex=c(0.7,0.6)) # Four plots (2 for objects, 2 for variables)
biplot(out, "b", cex=c(0.7,0.6))  # Two biplots
biplot(out, xlabs = NA, plot.axes = c(3,5))    # Plot axes 3, 5. No object names
biplot(out, plot.type="biplots", xlabs = NULL) # Replace object names by numbers

#' ## Heatmap
# heatmap (spc, Rowv = grp$grp, scale = "column", labRow = grp$grp)

#' <!-- #################################################################### -->


#' <!-- #################################################################### -->
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
