# Environmental gradients and invertebrate distribution in the Prince Charles Mountains, East Antarctica.

### Disclaimer

**THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.**

## Introduction

The following code represents analyses conducted for the manuscript titled **"Age-related environmental gradients influence invertebrate distribution in the Prince Charles Mountains, East Antarctica."** Use `git clone` to download this repository to your system. Also include all elements from the Zenodo repository in your local copy of the repository, by moving them into a folder named `Zenodo`. **Please do not execute any of the the scripts on your system without looking at them first.** This code was implemented using cumulative sum scaling (CSS) of phylotype abundances, as implemented in Qiime 1.9., and was created on Ubuntu 16.04. The code has since been moved to an Apple computer, running GNU and BSD POSIX tools and Qiime 1.9.1 in macOS 10.11.6. COI data has been dropped. Used 18S data was generated recently (Feb. 2016) as described in the manuscript and sequences are associated with the input `phyloseq` objects. While CSS'd abundance has been used, the code was also tested using abundance correction by rarefaction, `DeSeq2` and without abundance correction. Feel free to report bugs.

## Data files

Release data and code files are available from
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.162484.svg)](https://doi.org/10.5281/zenodo.162484) and [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.190926.svg)](https://doi.org/10.5281/zenodo.190926). Please reconstitue theformer archieve as a folder `Zenodo` into your locally cloned repository (latter file set).

## Analysis documentation

Please check script comments and design diagrams initially. Each `R` script can generate `.pdf` reports (which are moved to the `./Documentation` folder). The code to generate those reports is contained within each `R` script. The `.pdf` files were moved to the Zenodo target folder via `./move_documentation.sh`. You can re-create these reports if you have `pandoc`, `R` package `rmarkdown`, and `pdflatex` installed.

## Script overview

Check rendered `.pdf`s, diagrams and script comments for further information.

- `00_functions.R` - Helper functions for analysis.
- `10_import_predictors.r` - Predictor import from `.csv` to `.Rdata`
- `20_format_predictors.r` - Predictor filtering, naming, and type setting. Export to `.Rdata`.
- `35_format_phyloseq.r` - Reads in `./Zenodo/R_Objects/560_psob_18S_css_filtered.RData`, and writes out `.Rdata`with with script number. Non-invertebrates and invertebrates not pertinent to the analysis are removed, sampling sites not pertinent to the analysis are removed. Formatted predictors are included, `phyloseq` slots are slighlty renamed for clarity in charts and code of downstream analysis. Some counting and basic numbers are available from here.
- `40_main_analysis.r` - The main analysis.
- `37_format_uncrtd_phyloseq.r` - derivative of `35_format_phyloseq.r` using uncorrcted data, to allow plotting with script `42_plot_uncorrected.r`.
- `42_plot_uncorrected.r` plotting of uncorrected bar plots, for manuscript (derived from `40_main_analysis.r`).
