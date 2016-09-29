# Environmental gradients and invertebrate distribution in the Prince Charles Mountains, East Antarctica.

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica."** Use `git clone` to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`. Please refer to `tree.txt` if you would like to confirm that you have re-built the necessary directory structure. **Please do not execute the scripts on your system without looking at them first.**

### Version history

This is the fourth recoding of the analysis for this manuscript.

- The initial one, from June 2015, was incomprehensible for any reader apart from the author and made it complicated to include changes requested by both reviewers.
- The second version of the analysis (16th July 2016) improved on this to some extend, but not enough.
- The subsequent, third re-write (started 23rd August, 2016) used appropriate new transformation techniques which proved to be not down-stream compatible with analyses implemented in R.
- This is the fourth re-code. It was started using cumulative sum scaling (CSS), as implemented in Qiime 1.9., and created on Ubuntu 16.04\. The code has since been moved over to an Apple computer, running GNU and BSD POSIX tools and Qiime 1.9.1 in macOS 10.11.6\. This code used CSS'd 18S phylotype data data (COI has been dropped) generated recently (Feb. 2016) from repository `pcm_modelling`. Since the CSS approach didn't work, the code now uses the Qiime generated files from ported repository `pcm_modelling_mac` and traditional abundance correction methods (as previously available in Qiime 1.8).

### Disclaimer

**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.**

## Analysis documentation

Some shell scripts needed to be ported from Ubuntu 16.04 to macOS as implemented in repository `pcm_modelling_mac`. Check script comments and `./Documentataion` for diagrams.

Each `R` script can generate `.pdf` reports. The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc` and `R` package `rmarkdown` installed. Also check the `.git` commit messages.

## Implemented steps and corresponding `R` and `bash` scripts

### Preparation in in POSIX shell

- `0200_rarefy_alpha_18S.sh` - rarefaction plots to calibrate and control rarefaction in the next steps. Writes to folder `./Zenodo/Rarefaction/` with script number. Summary of input table is also provided. Source file is decontaminated `.biom` table from `bioms18S/18S_btable147_counts_default.biom` of `pcm_modelling` repository. `0000_*` config files in parent directory specify rarefaction parameters and path to Qiime environment. Based on Goods coverage, employing a rarefaction depth of ~1000 sequences will be enough to observe all expected taxa in a sample. Using this low values enables inclusion of samples from Mount Menzies. (`.fdf` renders of plots are stored in `./Zenodo/Documentation`)

### Preparation in R

- `00_functions.R` - Helper functions for analysis.
- `10_import_predictors.R` - Predictor import from `.csv` to `.Rdata`
- `20_format_predictors.R` - Predictor filtering, naming, and type setting.
- `30_format_phyloseq.R` - Integration of `css` abundance-corrected 18S originally from (and documented in) repository `pcm_modelling`. `sample_data()` component is erased and substituted with formatted predictors from above.

### Analysis

- `40_pca_and_ordinations.R` - some useful code exploring PCA and ordination with the data, but no significant results here.
- `50_eda.R` - violin plots implemented to visualize raw data, some analysis trials using the `vegan` package, particularly a CCoA approach as described in Wang _et al._ 2012 looks suitable.

### Change-log and progress

27.09.2016 - created and ran `0200_rarefy_alpha_18S.sh`

### Todo

- [x] It is hard to conceive how the `css` scaled abundance data in `560_psob_18S_css_filtered.RData` is transformed, it looks like `log` transform. This transformation may to be reversed after modelling and before discussing results. To solve this question Paulson _et al._ (2013) or the Qiime developer forum should be consulted. **Resolved by using rarefaction now.**
- [x] Abundance correction should perhaps happen after removal of chimeras, but before any subsequent filtering of blanks etc. This should be discussed, e.g. by contacting the Qiime development team, then implemented appropriately, also using the documentation of repository `pcm_modelling`. **Resolved by using rarefaction instead of cumulative sum scaling (or other abundance correction methods).Rarefaction is performed analogously to CSS after filtering of very low-covered samples. Contaminating reads should be removed, to give the "true" diversity, before rarefaction.**
- [ ] implement rarefaction at suitable depth
- [ ] clean repository for submission (separate code and data as much as possible)
- [ ] extend generate todo list from below
- [ ] resort this file

### Spin-offs

- `60_scar_combined.R` - fork of `50_eda.R` for presentation at SCAR conference. Analysis on species involving species abundance uses `css` abundance data, which might need might be wrongly implemented or not to be used at all (see change-log)
- `61_scar_separate.R` - fork of `40_pca_and_ordinations.R` for presentation at SCAR conference. Analysis on species involving species abundance uses `css` abundance data, which might need might be wrongly implemented or not to be used at all (see change-log). Uses `ggcorplot()` now and adjusts colors, all files are written out to SCAR folder.

## Notes

16.08.2016 - the following code issues need to be addressed before adjusting the manuscript text:

- [ ] The analysis approach of Wang _et al._ 2012 should be tried, as it looks to give promising results. Otherwise perhaps mail Warton?

17.08.2016 - meeting with Mark the following code issues need to be addressed before adjusting the manuscript text:

- [ ] use MDS plots for separate species
- [ ] CSS and CCA look
- [ ] mail plot to Mark

19.08.2016

- [x] Do not remove biologically empty samples in filtering steps, this may remove power from the analysis?
- [ ] Draw NMDS plots in `ggplo2()` as described in bookmarks.

## Manuscript work

### Overview

- See `./160808_inv_env/Scratch/160704_revisions` for all old files used prior to first submission to Royal society.
- See `./pcm_inv_env/160808_inv_env/Scratch/160811_unused_R_code` for code residues from previous attemps.
- See `/160808_inv_env/Scratch/unused_Qiime` for legacy `Qiime` objects.
- See `/160808_inv_env/Text` for the latest stages for manuscript submission, these should be used to continue the work on the manuscript.

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
