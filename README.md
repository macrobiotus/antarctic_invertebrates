# Environmental gradients and invertebrate distribution in the Prince Charles Mountains, East Antarctica.

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica."**  Use `git clone`  to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`.  Please refer to `tree.txt` if you would like to confirm that you have re-built the necessary directory structure. **Please do not execute the scripts on your system without looking at them first.**

### Version history

This is the fourth recoding of the analysis for this manuscript. The initial one, from June 2015, was incomprehensible for any reader apart from the author and made it complicated to include changes requested by both reviewers. The second version of the analysis  (16th July 2016) improved on this to some extend, but carried over too much of the old code and is not publicly available. The subsequent, third re-write (23rd August, 2016) used appropriate
trasnformation techniques an could not retrieve any new results, nor corroborate the old results. This is the fourth re-code - this code uses the recently (Feb. 2016) reprocessed 18S data from repository `pcm_modelling` which used cumulative sum scaling for abundance correction. Predictors are re-added.

### Disclaimer
**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.**

## Analysis documentation
Each `R` script can generate `.pdf` reports. The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc` and `R` package `rmarkdown` installed. Also check the `.git` commit messages and the changelog below.

## Implemented steps and corresponding `R` scripts

* `00_functions.R` - Helper functions for analysis.
* `10_import_predictors.R` - Predictor import from `.csv` to `.Rdata`
* `20_format_predictors.R` - Predictor filtering, naming, and type setting.
* `30_format_phyloseq.R` - Integration of  `css` abundance-corrected 18S originally from (and documented in) repository `pcm_modelling`. `sample_data()` component is erased and substituted with formatted predictors from above.
* `40_pca_and_ordinations.R` - some useful code exploring PCA and ordination with the data, but no significant results here. 

## Changelog

* Nothing changed since creation of this `readme.md`.

## Manuscript work

### Overview
*  See `./160808_inv_env/Scratch/160704_revisions` for all old files used prior to first submission to Royal society.
* See  `./pcm_inv_env/160808_inv_env/Scratch/160811_unused_R_code` for code residues from previous attemps.
*  See `/160808_inv_env/Scratch/unused_Qiime` for legacy `Qiime` objects.
*  See `/160808_inv_env/Text` for the latest stages for manuscript submission, these should be used to continue the work on the manuscript.

### Comment to address in by code and manuscript text
* [ ]  __Seasonal variation__ _"Thinking about seasonal variation, were Chromadorea less abundant, or were they absent from areas with below average conductivity? If they were absent, then less likely to be influenced by seasonal variation (as you’d detect with eDNA)."_
* [ ] __Seasonal variation__ _"Another angle would be if you see the same patterns with presence/absence and abundance data. Presence/absence patterns are less likely to show seasonal changes (see second paragraph of discussion in my Arid Recovery paper)."_

### Comments to address by text only
* [ ] __Spatial variability__ "Does increased salinity decrease mite / invertebrate diversity in other regions, or does it vary between studies? Show how comparable your findings are to previous work."_
* [ ] _Shorten the conclusion section_
* [ ] __Seasonal variation__ _"Do you think the communities are likely to vary over the season, or do you think the same patterns would apply e.g. whole classes absent / much less abundant? ‘Temporal bias’ is different to seasonal variation"_
* [ ] __ Seasonal variation__ _"What is the generation time of these invertebrates? Would the community change over a season?"_
* [ ] __Global context and salinity"__ _"But why do you think your results are important / could be applicable to global ecosystems?"_
* [ ] Update methods and results in main text
* [ ] Update methods and results in SI
* [ ] Check if PCM and Fig, and Software names are ok
* [ ] Check reference formatting again
* [ ] Update software versions
* [ ] Update repository information
* [ ] Check for COI C97 T75
* [ ] Check for 18S C97 T90
* [ ] SI check "metabarcoding" has been inserted everywhere
* [ ] SI check references are inserted properly
* [ ] SI check if tables are inserted properly
