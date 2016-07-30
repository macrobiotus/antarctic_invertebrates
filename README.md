# Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica.

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica."**  Use `git clone`  to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`.  Please refer to `tree.txt` if you would like to confirm that you have re-built the necessary directory structure. **Please do not execute the scripts on your system without looking at them first.**

### Version history

This is the third recoding of the analysis for this manuscript. The initial one, from June 2015, was incomprehensible for any reader apart from the author and made it complicated to include changes requested by both reviewers. The second version of the analysis  (16th July 2016) improved on this to some extend, but carried over too much of the old code and is not publicly available. This analysis is a subsequent, third re-write.

### Disclaimer
**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.**

## Analysis documentation
Each `R` script can generate `.pdf` reports. The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc` and `R` package `rmarkdown` installed. Also check the `.git` commit messages and the changelog below.

## Implemented steps and corresponding `R` scripts

### Initial fork

* `10_import_data.R` - __Data import and conversion for R analysis__  

  Qiime generated phylotype data and abiotic measurements are imported and saved as `R` objects.

* `20_field_data.R` - __ Preparation of x-ray diffraction and soil geochemical data__

 Retention of variables necessary for analysis, type setting and concise variable naming.

* `30_phylotype_data.R` - __Import and formatting of phylotype data__

 Import of `Phyloseq` objects, retention of Antarctic phylotypes, cleaning of taxonomy information, and conversion to presence / absence.

* `40_merging.R` - __~~Tree agglomeration and~~ Merging of phylotype data, inclusion of sample data__

 ~~Tree tip agglomeration of both data-sets,~~ Erasing the un-needed `sample_data()` components, re-converting to presence / absence, merging of both data-sets, re-creating a `sample_data()` slot from the predictor measurements of `20_field_data.R`, and final checking of the combined sample data. **Tree tip agglomeration is currently not used.**

* `45_ordinations_trial.R` - __PCA's and ordinations on abiotic and biotic data__  

 Implemented here is the correct sub-setting for each analysis method (mostly, see comments in file for what needs doing). Then the script does PCA of X-Ray Values after transformation employing the centered log ratio. (See citation in script). Re-conversion to binary if needed on `spc` matrix in `set_presences()` (and `get_list()`). Checks input `phyloseq` object. **Work in progress.**

### Second fork

 * `50_merging.R` - __Inclusion of sample data into `phyloseq` object__

  Replacement for `40_merging.R`, intended to use with `phyloseq` objects imported from repository  `pcm_modelling`. Erasing the un-needed `sample_data()` components, filtering of everything but the target groups.
  re-creating a `sample_data()` slot from the predictor measurements of `20_field_data.R`. **Work in progress.**

* `55_ordinations_trial.R` - __PCA's and ordinations on abiotic and biotic data__  

   Replacement for `40_merging.R`, intended to use with `phyloseq` objects imported from repository  `pcm_modelling` in conjuction with `50_merging.R`. Implemented here is the correct sub-setting for each analysis method (mostly, see comments in file for what needs doing). Then the script does PCA of X-Ray Values after transformation employing the centered log ratio. (See citation in script). Re-conversion to binary if needed on `spc` matrix in `set_presences()` (and `get_list()`). Checks input `phyloseq` object. **Work in progress.**

## Changelog

* __30.6.2016__ - Updated `readme`. Copied 18S `phyloseq` objects from `/pcm_modelling/objectsR` repository to `/Zenodo/R_Objects` for trials with more recent and abundance-corrected 18S data. Created `50_merging.R` and started working on this. Updated this `readme`.

## Code more on ...
* [x] remove outliers
* [x] Preprocessing of geochemical Values
* [x] Preprocessing of X-Ray Values - used `clr()` transformation
* [x] PCA of geochemical Values
* [x] comment out and omit tree agglomeration
* [x] PCA of combined Values
* [x] modify merging of `phyloseq` objects using binary
* [x] MDS of species data using `vegan()`
* [ ] remove COI data and use read proportions copy of `45_ordinations_trial.R`
    * [ ] in new script `50_merging.R` continue in section ` # Filtering phyloseq data`.   
    * [ ] create new script `55_ordinations_trial.R` to work with `50_merging.R`.
* [ ] MDS environmental fitting
* [ ] request help for transformation and CCA function `vegan` regarding presence-absence data
* [ ] CCA and testing - CCA is not possible with presence-absence data in `vegan` ?
* [ ] get OTU table and needed details
* [ ] Coordinates for `QGIS` map - via `get_list()`
* [ ] output plots with direct dimensions
* [ ] clean out code
* [ ] save plots to correct locations with direct dimensions
* [ ] Look up citations in final code.
* [ ] code in `phyloseq` sub-setting in `45_ordinations_trial` and / or `55_ordinations_trial`.

#### Images to create
* [ ] PCA plots
* [ ] variance plots
* [ ] removal of co-correlated? /
* [ ] removal of outliers for CCA? [Palmer 1993]
* [ ] QGIS map

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
