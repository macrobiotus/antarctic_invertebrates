# Environmental gradients and invertebrate distribution in the Prince Charles Mountains, East Antarctica.

### Disclaimer

**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.**

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica."** Use `git clone` to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`. Please refer to `tree.txt` if you would like to confirm that you have re-built the necessary directory structure. **Please do not execute the scripts on your system without looking at them first.**

### Version history

This is the fourth recoding of the analysis for this manuscript.

- The initial one, from June 2015, was incomprehensible for any reader apart from the author and made it complicated to include changes requested by both reviewers.
- The second version of the analysis (16th July 2016) improved on this to some extend, but not enough.
- The subsequent, third re-write (started 23rd August, 2016) used new transformation techniques which proved to be not down-stream compatible with analyses implemented in R.
- This re-code was started using cumulative sum scaling (CSS), as implemented in Qiime 1.9., and created on Ubuntu 16.04. The code has since been moved over to an Apple computer, running GNU and BSD POSIX tools and Qiime 1.9.1 in macOS 10.11.6. This code used CSS'd 18S phylotype data data (COI has been dropped) generated recently (Feb. 2016) from repository `pcm_modelling`. Since the CSS approach didn't work, the code now uses data with unadjusted abundance values from repository `pcm_modelling_mac`. Rarefaction is provided by R Package `phyloseq`, all in all because one can still not write `.biom`objects back to the system reliably once they have been imported into R and the input objects are (only) available in R
(without re-running much pre-processing code).

## Analysis documentation

Check script comments and `./Documentation` for diagrams. Each `R` script can generate `.pdf` reports. The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc` and `R` package `rmarkdown` installed. Also check the `.git` commit messages.

## Script overview

### Data preparation

- `00_functions.R` - Helper functions for analysis.
- `10_import_predictors.R` - Predictor import from `.csv` to `.Rdata`
- `20_format_predictors.R` - Predictor filtering, naming, and type setting.
- `30_format_phyloseq.R` - Input data has bee filtered to contain samples with more then 1000 sequences and Phylotypes with more then 100 sequences. This input data was generated in `pcm_modelling`, and documented in the overview diagrams. This script performs rarefaction, to a depth of 1010 sequences as established using Qiime tools (see lagacy sehll scripts below.) Nom-invertebrates not pertinent to the analysis are removed, sampling sites not pertinent to the analysis are removed. Formatted predictors are included, `phyloseq`slots are slighlty renamed for clarity in charts and coide of downstream analysis.

### Analysis

- nothing yet, but will be building on existing code

## Work progress

### Changelog
- **29.09.2016** - created and ran `0200_rarefy_alpha_18S.sh` and  `0300_rarefy_multi_18S.sh`.
- **30.09.2016** - created and ran `0400_ckeck_multi_18S.sh`, checked `10_import_predictors.R`, and  `20_format_predictors.R`, deleted unused documentation, started `30_format_phyloseq.R`.
- **02.09.2016** - there is currently no way to export properly formatted `.biom` tables to the shell (some function may be available in R package `biomformat`). All shell scripts and R warappers for shell scripts where moved to scratch. Doing rarefaction with `phyloseq` within R instead.

### Todo
- [ ] finish `30_format_phyloseq.R`
- [ ] design main analysis file
- [ ] update R scripts in overview file
- [ ] use MDS plot to inform on sample variability
- [ ] Draw NMDS plots in `ggplo2()` as described in bookmarks?
- [ ] The analysis approach of Wang _et al._ 2012 could be tried, as it looks to give promising results. Otherwise perhaps mail Warton?
- [ ] clean repository for submission (separate code and data as much as possible)
- [ ] remove files unrelated to this manuscript to local one this project is coded and or adjust `.gitignore` file.

### Done
- [x] tried rarefaction in Qiime and re-integration into R: no way to export `.biom` files to shell for Qiime. All Qiime work on `.biom` tables has to happen before R import.
- [x] extend generate todo list from below and resort this file
- [x] implement rarefaction at suitable depth
- [x] Abundance correction should perhaps happen after removal of chimeras, but before any subsequent filtering of blanks etc. This should be discussed, e.g. by contacting the Qiime development team, then implemented appropriately, also using the documentation of repository `pcm_modelling`. **Resolved by using rarefaction instead of cumulative sum scaling (or other abundance correction methods).Rarefaction is performed analogously to CSS after filtering of very low-covered samples. Contaminating reads should be removed, to give the "true" diversity, before rarefaction.**
- [x] It is hard to conceive how the `css` scaled abundance data in `560_psob_18S_css_filtered.RData` is transformed, it looks like `log` transform. This transformation may to be reversed after modelling and before discussing results. To solve this question Paulson _et al._ (2013) or the Qiime developer forum should be consulted. **Resolved by using rarefaction now.**

## Manuscript work

### Comment to address in by code and manuscript text

- [ ] **Seasonal variation** _"Thinking about seasonal variation, were Chromadorea less abundant, or were they absent from areas with below average conductivity? If they were absent, then less likely to be influenced by seasonal variation (as you'd detect with eDNA)."_
- [ ] **Seasonal variation** _"Another angle would be if you see the same patterns with presence/absence and abundance data. Presence/absence patterns are less likely to show seasonal changes (see second paragraph of discussion in my Arid Recovery paper)."_

### Comments to address by text only

- [ ] **Spatial variability** "Does increased salinity decrease mite / invertebrate diversity in other regions, or does it vary between studies? Show how comparable your findings are to previous work."_
- [ ] _Shorten the conclusion section_
- [ ] **Seasonal variation** _"Do you think the communities are likely to vary over the season, or do you think the same patterns would apply e.g. whole classes absent / much less abundant? 'Temporal bias' is different to seasonal variation"_
- [ ] **Seasonal variation** _"What is the generation time of these invertebrates? Would the community change over a season?"_
- [ ] **Global context and salinity"** _"But why do you think your results are important / could be applicable to global ecosystems?"_
- [ ] Update methods and results in main text
- [ ] Update methods and results in SI
- [ ] Check if PCM and Fig, and Software names are ok
- [ ] Check reference formatting again
- [ ] Update software versions
- [ ] Update repository information
- [ ] Check for COI C97 T75
- [ ] Check for 18S C97 T90
- [ ] SI check "metabarcoding" has been inserted everywhere
- [ ] SI check references are inserted properly
- [ ] SI check if tables are inserted properly

## Legacy scripts


### Preparation in in POSIX shell using Qiime 1.9.1

Shell code is not needed, but had been implemneted to rarefy data using Qiime. Rarefaction is now accomplished using `phyloseq`.

- `0200_rarefy_alpha_18S.sh` - **rarefaction plots to calibrate and control rarefaction in the next steps.** Writes to folder `./Zenodo/Rarefaction/` with script number. Summary of input table is also provided. Source file is decontaminated `.biom` table from `bioms18S/18S_btable147_counts_default.biom` of `pcm_modelling` repository. `0000_*` config files in parent directory specify rarefaction parameters and path to Qiime environment. Based on Goods coverage, employing a rarefaction depth of ~1000 sequences will be enough to observe all expected taxa in a sample. Using this low values enables inclusion of samples from Mount Menzies. (`.fdf` renders of plots are stored in `./Zenodo/Documentation`)
- `0300_rarefy_multi_18S.sh` - **perform multiple rarefactions for R analysis.** Rarefaction is used instead of other abundance methods corrections. A single rarefactions would give results that are perhaps not reproducible. ~~There is no script to combine multiple OTU tables in Qiime 1.9.1 one anymore since this may not be statistically valid.~~ Thus, the input file has samples removed with less then 1000 sequences and OTUs removed with less then 100 sequences, input file is also "decontaminated". Rarefaction results should thus always give more or less similar results. Additionally, OTU tables are plotted individually in the next script. Based on the plots of the previous script a rarefaction depth of 1010 sequences is chosen. Lineage information is carried over from input file. Empty Phylotypes are not removed from the input tables, to avoid potential downstream hick-ups due to inconsistent table dimensions.
- `0400_ckeck_multi_18S.sh` - **check rarefaction results in Qiime** since coverage differences are vast and rarefaction needs to be done at a low level, it is a goof idea to have some plots for furture reference (e.g. during R coding). This script uses the results from `0300_rarefy_multi_18S.sh` and will generate barplots for each of the rarefaction results. Writes to `./Zenodo/Rarefaction/0400_plots` accordingly. There still seem to be ample invertebrates in all samples, so one can contine the analysis.
