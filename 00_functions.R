#' ---
#' title: "Helper functions for invertebrate analysis."
#' author: "Paul Czechowski"
#' date: "August 15th, 2016"
#' output: pdf_document
#' toc: true
#' highlight: zenburn
#' bibliography: ./references.bib
#' ---
#'
#' # Preface
#'
#' This code is tested using a raw R terminal. Path names are
#' defined relative to the project directory. This code commentary is included
#' in the R code itself and can be rendered at any stage using
#' `rmarkdown::render ("./00_functions.R")`. Please check the
#' session info at the end of the document for further notes on the coding environment.
#'
#' <!-- #################################################################### -->
#'
#' # Functions for `phyloseq` objects
#'
#' ## Remove empty data
#'
#' This function removes "0" count phylotypes from samples and samples with "0"
#' phylotypes. Currently used as subroutine for `agglomerate()`.
remove_empty <- function(phsq_ob){

  # package loading
  require("phyloseq")

  # filter Phylotypes
	phsq_ob <- prune_taxa (taxa_sums (phsq_ob) > 0, phsq_ob)

	# filter samples
	phsq_ob <- prune_samples (sample_sums (phsq_ob) > 0, phsq_ob)

	# return object
	return (phsq_ob)
	}

#' ## Agglomerate taxonomy
#'
#' To increase data density, rank based agglomeration may be desirable. This
#' function checks for the presence of the correct ranknames in passed in string
#' and then agglomerates.
agglomerate <- function (ps_ob, tax_rank) {

  # package loading
  require("phyloseq")

  # check correct naming of taxonomy strings
  stopifnot (tax_rank %in% rank_names (ps_ob))

  # agglomerate taxa on requested level
  ps_ob <- tax_glom (ps_ob, tax_rank)

  # filter object
  ps_ob <- remove_empty (ps_ob)

  # return agglomerated object
  return (ps_ob)
}

#' ## Reset presence absence values
#'
#' This calculates Presence / absence within a given phyloseq object
#' on phylotypes. Only makes sense with agglomerated object.
make_binary <- function(phsq_ob){

  # package loading
  require("phyloseq")

  # transform data to binary
  otu_table (phsq_ob) [otu_table (phsq_ob) > 0]  <-1

  # return object
	return (phsq_ob)
}

#' ## Transposing phylotype counts
#'
#' Function for transposing phylotype count tables from Phyloseq objects to the
#' rest of the R world (i.e. `vegan`).
get_phylotypes <- function (ps_ob) {

  # package loading
  require("phyloseq")

  OTU <- otu_table (ps_ob)
  if (taxa_are_rows (OTU)) {
    OTU <- t (OTU)
  }
  return (as (OTU, "matrix"))
}

#' ## Renaming phylotypes
#'
#' Function to rename phylotypes from identifier to specific taxon name
rename_phylotypes <- function (spc, ps_ob, tax_rank) {

  # package loading
  require("phyloseq")

  # check correct naming of taxonomy strings and matrix format of input matrix
  stopifnot (tax_rank %in% rank_names (ps_ob) & is.matrix (spc))

  # set names
  colnames(spc) <- tax_table (ps_ob) [which (colnames (spc) %in%
    rownames (tax_table (ps_ob))), tax_rank]

  # return modified species matrix
  return (spc)
}

#' ## Getting data frames of predictor variables
#'
#' Function to get selected predictor variables from Phyloseq objects.
get_predictors <- function (ps_ob, vars) {

  # package loading
  require("phyloseq")

  # for function writing / testing / debugging
  # ps_ob <- phsq_ob_comb
  # vars  <- c ("AREA", "GENE")

  # stop if passed in variables are not contained in the sample data
  #  of the phyloseq object, or if a phyloseq object wasn't passed in
  stopifnot (all (vars %in% colnames (sample_data(ps_ob))))
  stopifnot (class(ps_ob) == "phyloseq")

  # generate a predictor data frame from selected columns
  predictors <- data.frame (sample_data (ps_ob)[ , vars])

  # return data frame
  return (predictors)
}

#' ## Relative abundances
#'
#' This calculates relative abundances within a given phyloseq object
#' phylotypes (Used for plotting).
make_proportional <- function(phsq_ob){

  # package loading
  require("phyloseq")

  phsq_ob <- transform_sample_counts(phsq_ob, function(OTU) OTU / sum(OTU))

  return (phsq_ob)
}

#' # Functions for `base` objects
#'
#' ## Re-setting presence absence counts
#'
#' Function for re-setting presence / absence counts after taxon agglomerating
set_presences <- function (spc) {

  # check if data is matrix (perhaps not needed)
  stopifnot ( is.matrix(spc))

  # set values
  spc [ spc > 0 ] <- 1

  # return object
  return (spc)
}

#' ## Matching predictor variables with phylotype data
#'
#' For some samples biological information is available, but no abiotic information
#' because collection of predictors sometimes wasn't possible. Such samples cannot
#' be included in some downstream analyses. In this function `complete.cases()` is run on
#' predictor variables alone.
cmpl_predictors <- function (predictors) {

  # test the input data
  stopifnot (class (predictors) == "data.frame")

  # filtering
  predictors_filtered <- predictors[ which (complete.cases(predictors)), ]

  # return filtered object
  return (predictors_filtered)
}

#' In this function the phylotype data is pruned to defined cases in a passed-in
#' data frame with predictors.
cmpl_phylotypes  <- function (phylotypes, predictors) {

  # for function development
  # load (path_phsq_ob_comb)
  # phylotypes  <- get_phylotypes (agglomerate (phsq_ob_comb, "Class"))
  # predictors  <- cmpl_predictors (get_predictors (agglomerate (phsq_ob_comb,
  #  "Class"), vars = c("AMMN", "NITR", "PHOS", "POTA", "SLPH", "CARB","COND",
  #  "PHCC", "PHHO")))

  # test the input data
  stopifnot (class (phylotypes) == "matrix" & class (predictors) == "data.frame")

  # remove samples from biotic observations if they are not matched by abiotic ones
  phylotypes_filtered <- phylotypes[which ( rownames (phylotypes) %in%
    rownames (predictors)), ]

  # return filtered matrix
  return (phylotypes_filtered)
}

#' ## Getting R-compatible data frames
#'
#' This function returns a matrix `spc` and a data frame `obs` from a passed-in
#' phyloseq object. It also returns vectors `loc` and `gen` (to have available
#' location groups and marker coverage for plots etc.)
get_list <- function (ps_ob, tax_rank, pred_cat, pres_abs = FALSE) {

  # package loading
  require("phyloseq")

  # check correct naming of taxonomy strings and type of predictor category
  stopifnot (tax_rank %in% rank_names (ps_ob) & is.character (pred_cat))

  # taxon agglomeration
  ps_ob <- agglomerate (ps_ob, tax_rank)

  # data frame of soil geochemical variables
  obs <- get_predictors (ps_ob, vars = pred_cat)

  # matrix of biotic observations
  spc <- get_phylotypes (ps_ob)

  # EXPERIMENTAL: convert "0" to NAs, to get clear pattrern on defined values
  # message ("EXPERIMENTAL: Substitution of values below detection limit with NA
  #  instead of '0'")
  # obs[obs == 0] <- NA # replacing 0s with NAs

  # get complete abiotic data
  obs <- cmpl_predictors (obs)

  # filter bio data respectively
  spc <- cmpl_phylotypes (spc, obs)

  # set presence / absence for species matrix
  #  if flag is set
    if( pres_abs == TRUE ){ spc <- set_presences (spc)}

  # set phylotype names
  spc <- rename_phylotypes (spc, ps_ob, tax_rank)

  # get groups for biplot (write as subroutine?)
  grp <- c (sample_data (ps_ob)[ which (rownames (obs) %in% sample_names
    (ps_ob)), ])$AREA

  # get marker names
  gen <- c (sample_data (ps_ob)[ which (rownames (obs) %in% sample_names
    (ps_ob)), ])$GENE

  # diagnostic message
  message ("samples -- spc: ", nrow(spc), "; obs: ", nrow(obs) , "; grp's: ", length (grp),
    "; gen's: ", length (gen))

  # use data frames instead of vector to not loose the sample information
  grp <- data.frame(grp, row.names = rownames(obs))
  gen <- data.frame(gen, row.names = rownames(obs))

  # create return list (add elements to the **END** if necessary)
  return (list ("spc" = spc, "obs" = obs, "grp" = grp, "gen" = gen))
}

#' ## Matching PCA labels with input object
#'
#' This function adjust the location factor variable to match and input data
#' frame (`obs`) or matrix (`spc`).
shorten_groups <- function (grp, pca_df) {

  # check input data - are the logicals correct in short form
  stopifnot ( is.matrix(pca_df) || is.data.frame (pca_df) && is.data.frame (grp))

  # shorten groups to match observations
  grp <- grp[which (rownames (grp) %in% rownames (pca_df)) ,]

  # diagnostic message
  message ("Type conversion of group performed.")

  # return vector
  return (grp)
}

#' # Functions for pre-processing
#'
#' ## Remove outliers
#'
#' This function removes outliers from soil geochemical data.
remove_outliers <- function (obs) {

  # package loading
  library ("outliers")

  # warning message
  message ("This is only adequate for soil geochemical values.")

  # print oilier count
  out <- sum    (outlier (as.matrix (obs), logical = TRUE), na.rm = TRUE )
  inl <- length (outlier (as.matrix (obs), logical = TRUE))
  message ("There are ", out, " outliers among ", inl, " values.")

  # remove outliers
  obs <- data.frame (rm.outlier (as.matrix (obs), fill = TRUE))

  # return object
  return (obs)
}

#' ## Centred log ratio transformation
#'
#' As described elsewhere [@Ranganathan2011], compositional data is best
#' transformed using centred log ratio, as implemented in package `rgr()`. This
#' will remove the closure effect of compositional data.
#' Use this function on compositional data only, such as the mineral
#' data. This function replaces `0` with `NA`s. Adjust the input object via
#' `get_list()` if too many samples with complete observations are lost. Check
#' the `summary()` ouput below to get the `NA` numbers.
transform_clr <- function (obs) {

  # package loading
  require ("rgr")

  # print message for use case
  message ("Use this function on compositional data only, such as the mineral
    data. This function replaces '0' with 'NA's. Adjust the input object via
    'get_list() if too few samples with complete observations are lost. Check
    the 'summary()' ouput below to get the 'NA' numbers." )

  # `clr()` of `rgr` needs a matrix
  obs <- as.matrix(obs)

  # undetected values need to be removed
  obs [obs==0] <- NA

  # undetected values have been removed
  print (summary (obs))

  # centred log ratio transformation [@Aitchison1986]
  obs <- clr (obs, ifclose = TRUE)

  # return transformed object
  return (obs)
}

#' ##  Transformations (Yeo-Johnson, Box-Cox, or none)
#'
#' This function performs Yeo-Johnson transformation [@yeo2000] (or others), centres, scales the data
#' and removes near zero variance values from the data. It's intended to be used
#' with continuous data (soil geochemical values, but will work on any data frame.
transform_any <- function (obs, method = c("center", "scale", "YeoJohnson", "nzv")) {

  # package loading
  require ("caret")

  # train model
  pp <- preProcess(obs, method = method)

  # apply model
  obs_trans <- predict(pp, newdata = obs)

  # print transformed data
  print(summary(obs_trans))

  # return transformed data
  return (obs_trans)
}

#' ##  Removing co-correlated variables
#'
#' Intended for use with soil geochemical values, but will accept and data frame.
remove_cocorrelated <- function (obs) {

  # package loading
  require ("caret")

  # Diagnostic message
  message ("Correlation treshhold is hard-coded with '.75'.")

  # Finding the co-correlations
  high_cor_obs <- findCorrelation (cor (obs), cutoff = .75)  # ident. highly. corr


  # Dividing the co-correlation set
  del_obs <- obs[, high_cor_obs]
  flt_obs <- obs[,-high_cor_obs]

  # Info
  message ("Above '.75'  (and removed): ", paste (names (del_obs), collapse=","))
  message ("Below '.75' (and retained): ", paste (names (flt_obs), collapse=","))

  # return observations without co-correlation
  return (flt_obs)
}

#' # Functions for plotting
#'
#' ## Create bi-plot
#'
#' This function generates a simple PCA biplot of a `prcomp()` object, with
#' circles defined by a matching factor variable.
get_biplot <- function (pcs, grp) {

  # package loading
  require("ggbiplot")

  bip <- ggbiplot (pcs, choices = 1:2, scale = 1, pc.biplot = TRUE, ellipse = TRUE,
    varname.size = 4, groups = grp, circle = TRUE) +  theme_bw() + theme (legend.title =
    element_blank(), legend.background = element_rect (color = "gray90", size =
    0.3, linetype= 1), legend.justification=c(1,1), legend.position=c(1,1))

  return (bip)
}

#' ## Plot PCA variance
#'
#' Plot eigenvalues and percentages of variation of an ordination object
#' Kaiser rule and broken stick model Usage: `evplot(ev)` where ev is a vector
#' of eigenvalues. License: GPL-2 Author: Francois Gillet, 25 August 2012.
#' Average might be dragged way below 1 here, so this is is perhaps not
#' the perfect implementation.
get_evplot <- function(ev) {

  # Broken stick model (MacArthur 1957)
	n <- length(ev)
	bsm <- data.frame(j=seq(1:n), p=0)
	bsm$p[1] <- 1/n
	for (i in 2:n) bsm$p[i] <- bsm$p[i-1] + (1/(n + 1 - i))
	bsm$p <- 100*bsm$p/n

  # Plot eigenvalues and % of variation for each axis
	op <- par(mfrow=c(2,1))
	barplot(ev, main="Eigenvalues", col="bisque", las=2)
	abline(h=mean(ev), col="red")
	legend("topright", "Average eigenvalue", lwd=1, col=2, bty="n")
	barplot(t(cbind(100*ev/sum(ev), bsm$p[n:1])), beside=TRUE,
		main="% variation", col=c("bisque",2), las=2)
	legend("topright", c("% eigenvalue", "Broken stick model"),
		pch=15, col=c("bisque",2), bty="n")
	par(op)
}

#' An improved version of the the function above written with `ggplot2`.
#' Author: Ben Rohrlach, 7 August 2016.
plot_pcvars <- function (pcs, plotScreen = FALSE){

  # package loading
  require(ggplot2)

  variances <- pcs$sdev^2

  PCs <- 1:length(variances)

  gp <- ggplot () + xlab ('\nPrincipal Component') + ylab ('Variances\n') +
  geom_line  (aes (x = PCs, y = variances), size = 1) +
  geom_point (aes (x = PCs, y = variances), size = 5) +
  geom_point (aes (x = PCs, y = variances), size = 4, col='white') +
  scale_x_continuous (labels = PCs, breaks = PCs) +
  coord_cartesian ( ylim = c (0, max (variances)), xlim = range (PCs))

  if (plotScreen){
    gp
  }

  return(gp)
}

#' ## Get `corrplots()`
#'
#' Simple function to get `corrplots()`; intended for use with soil geochemical values,
#' but should work with any other object as well.
get_corrplots <- function (obs, flt_obs) {

  # message
  message ("ggcotplot() will work better here")
  
  # package loading
  require("corrplot")

  # create the plots
  p1 <- corrplot.mixed (cor (obs), tl.pos="d")
  p2 <- corrplot.mixed (cor (flt_obs), tl.pos="d")

  # return list with plots
  return (list ( "obs" = obs, "flt_obs" = flt_obs))
}

#' ## Map phyloseq object
#'
#' The second function draws the sample map. Here I use package `phylogeo`, which
#' itself seems to be more of a helper to negotiate functionality between `ggplot2`
#' and `phyloseq`. Syntax options are limited, but it does the job. 
#'
#' * `phylogeo` needs correct names of long / lat variables in the `sample_data()`
#'    component of the `phyloseq` objects. 
#' *  Instead of centering the projection on the South Pole, it's centering is defined
#'    by the range of the sample coordinates of the respective 'phyloseq` object.
#' *  The plotting objects are returned and evaluated later.

# draw a map with the sampling locations, incl. altering the names of the input
#   phyloseq object
map_samples <- function(phsq_ob, col_long = NULL, col_lat = NULL, subtitle = NULL){
  
  
  # library("devtools")
  # install_github("zachcp/phylogeo")
  require (phylogeo)

  # check input data
  stopifnot (class (phsq_ob) == "phyloseq")
  stopifnot (is.null (col_long) == FALSE)
  stopifnot (is.null  (col_lat) == FALSE)
     
  # rename lat long columns in input phyloseq object to be recognized by 
  #   phylogeo - veriable expectations are hard coded in phylogeo 
  names (sample_data(phsq_ob))[names (sample_data(phsq_ob)) == col_lat] <- 
    "Latitude"
  names (sample_data(phsq_ob))[names (sample_data(phsq_ob)) == col_long] <-
    "Longitude"
  
  # set latitude and longitude for projection centring
  latitude  <- mean (range(sample_data (phsq_ob)$Latitude))
  longitude <- mean (range(sample_data (phsq_ob)$Longitude))
  
  # define title and subtitle
  plot.title <- "Sample Range"
  plot.subtitle <- subtitle
  
  # draw a map, adjust coordinates and give a title, subtitle 
  map <- map_phyloseq (phsq_ob, region="Antarctica", color="AREA", 
    jitter=TRUE, jitter.x=2,jitter.y=2,) + 
    coord_map( projection = "ortho", orientation = c(latitude, longitude, 0)) + 
    ggtitle(bquote(atop(.(plot.title), atop(italic(.(plot.subtitle)), "")))) +
    geom_path()
     
  # return object
  return (map)
}

#' ## Plot phyloseq object
#'
#' A simple barplot function to get an overview over the contents of `Phyloseq`
#' objects.:
barplot_samples <- function(ps_ob, tax_rank){

  # package loading
  require ("phyloseq")
  require ("ggplot2")

  # check correct naming of taxonomy strings
  stopifnot (tax_rank %in% rank_names (ps_ob))

  # define title and subtitle
  plot.title    <- "Taxonomic Composition"
  plot.subtitle <- "18S rDNA: CSS corrected (upper) or rank presence (lower) "

  # draw a barplot, and give a title, subtitle
  #   re-set "facet_grid" if desirable, doesn't make much sense here
  ps_bar <- plot_bar(ps_ob, fill = tax_rank) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 5)) +
    theme(legend.position="left") +
    ggtitle(bquote(atop(.(plot.title), atop(italic(.(plot.subtitle)), ""))))

  # return object
  return (ps_bar)
}

#' ## Functions for violin plots
#'
#' ### Add grouping factor for discrete X / continuous Y plots
#'
#' This is a "band-aid" function returning an data frame with a factor variable
#' if plotting by a grouping variable is desired, which is not (anymore) contained
#' in the data to be plotted. Factor data frame `dfr_x` is `merge()`d with
#' multivariate data frame `dfr_v`.
add_discretex <- function (dfr_v, dfr_x, dfr_x_name = NULL) {

  # check input data to match function requirements
  stopifnot (dfr_x_name != NULL)
  stopifnot (is.data.frame (dfr_v) == TRUE)
  stopifnot (is.data.frame (dfr_x) == TRUE)
  stopifnot (ncol (dfr_x) == 1)

  # naming discrete x factor
  names(dfr_x) <- dfr_x_name

  # merging data frame
  dfr_v <- merge (dfr_v, dfr_x, by = "row.names", all = TRUE)

  # cleaning data frame
  dfr_v <- dfr_v [complete.cases (dfr_v), ]
  rownames (dfr_v) <- dfr_v$Row.names
  dfr_v$Row.names  <- NULL

  # return data frame
  return (dfr_v)
}

#' ### Create data frames for `get_violin()`
#'
#' Create two-column data frame for `get_violin()`. Returns one two-column
#' data frame from input arguments.
get_viodf <- function (dfr_y_name, dfr, dfr_x_name){

  # create two-column data frame
  dfr <- dfr [ , c( dfr_y_name , dfr_x_name)]

  # return two-column data frame
  return (dfr)
}

#' ### Generate violin plots
#'
#' Generate violin plots from one discrete X and one continuous Y. Takes one
#' two column data frame, returns one `ggplot2` object
get_violin <- function (dfr, dfr_x_name = NULL){

  # checking input data
  stopifnot (is.data.frame (dfr) == TRUE)
  stopifnot (dfr_x_name != NULL)
  stopifnot (ncol (dfr) == 2)
  stopifnot (any (names (dfr) %in% dfr_x_name))
  stopifnot (length (dfr_x_name) == 1)

  # build the violin
  violin <- ggplot (dfr, aes_string (x = dfr_x_name, y = names(dfr) [which (names (dfr) != dfr_x_name)],
    color = dfr_x_name)) +
  geom_violin (scale = "area") +
  stat_summary (fun.data = mean_sdl, geom = "pointrange") +
  theme(legend.position='none')

  # return the violin
  return (violin)
}

#' ### Generate list of violin plot graphical objects
#'
#' Generate violin plots from one data frame and and on factor to by plotting by
#' Returns list of `ggplot2` objects. Requires `get_viodf()` and `get_violin()`.
get_violinplotlist <- function (dfr, dfr_x_name = NULL) {

  # for function building
  # dfr <- obs
  # dfr_x_name <- "AREA"

  # checking input data
  stopifnot (is.data.frame (dfr) == TRUE)
  stopifnot (dfr_x_name != NULL)
  stopifnot (any (names (dfr) %in% dfr_x_name))
  stopifnot (length (dfr_x_name) == 1)

  # create list of two-variable data frames
  #   one of which is the variable to be plotted, the other the factor to group
  #   by, all to be passed to get_violin()
  dfr <- lapply ( names(dfr) [which (names (dfr) != dfr_x_name)],
    get_viodf, dfr, dfr_x_name )

  # generate violin plots from list of data frames
  groblist <- lapply (dfr, get_violin, dfr_x_name)

  # return list of violin plots
  return (groblist)
}

#' <!-- #################################################################### -->
#'
#' # Session info
#'
#' The code and output in this document were tested and generated in the
#' following computing environment:
#+ echo=FALSE
sessionInfo()

#' # References
