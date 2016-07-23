# Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica.

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients determine invertebrate distribution in the Prince Charles Mountains, East Antarctica."**  Use `git clone`  to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`.  Please refer to `tree.txt` if you would like to confirm that you have re-built the necessary directory structure. **Please do not execute the scripts on your system without looking at them first.**

### Version history

This is the third recoding of the analysis for this manuscript. The initial one, from June 2015, was incomprehensible for any reader apart from the author and made it complicated to include chenges requested by both reviwers. The second version of the analysis  (16th July 2016) improved on this to some extend, but carried over too much of the old code and is not publicly available. This analysis is a subsequent, thrird re-write. 

### Disclaimer
**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.**

## Analysis documentation
Each `R` script can generate `.pdf` reports. The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc` and `R` package `rmarkdown` installed.

## `R` scripts used
`10_import_data.R` --  __Data import and conversion for R analysis__
Qiime generated data is imported and saved as `R` object
`20_field_data.R` --  __ Preparation of x-ray diffraction and soil geochemical data__

`30_phylotype_data.R` -- __Import and formatting of phylotype data__

`40_merging.R` -- __Tree agglomeration and merging of phylotype data, inclusion of sample data__




###  Biotic data preparation

* __Import Qiime files as `Phyloseq` objects --__ Qiime generated data is imported and saved as `R` object by `10_import_data.R`.

* __Preparation of `Phyloseq` objects for merging --__ Import of `Phyloseq` objects, retention of Antarctic phylotypes, cleaning of taxonomy information,  and conversion to half of the relative abundances are done in script `30_phylotype_data.R`. 

###  Abiotic data preparation

 * __Import abiotic data --__  Soil geochemical and X-Ray diffraction data  is imported and saved as `R` object by `10_import_data.R`.

* __Cleaning  predictor  variables --__ Retention of variables necessary for analysis, type setting and concise variable naming are done in `20_field_data.R`. 

### Combining biotic data sets and inluding abiotic data

* __Agglomerations and merging of phylotype data, inclusion of sample data -- __ Tree tip agglomeration of both data-sets, erasing the un-needed `sample_data()` components, merging of both data-sets, re-creating a `sample_data()` slot from the predictor measurements of `20_field_data.R`, and final checking of the combined sample data are done in `40_merging.R`.
 

* __Save data frame as object__




* __Prepare merging of biotic data by altering data slots of the Phyloseq objects__
 * __Save data frame as object__


 * __Keep categories__
      * __Plate position__
      * __Sampling location__
      * __Geochemical variables__
      * __Mineral variables__
      * __Spatial information (Geopgraphic position, Slope and Elevation)__
      * __Markers__
 * __Save list with each categorie as a `data.frame` __
    
       
