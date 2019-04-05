# Local Ancestry

My final project for Advanced Bioinformatics (BIOI 500) is a comparison of three local ancestry estimation softwares: LAMP-LD, RFMix, and Loter. This repository concerns running the actual comparative analysis, with paths directed to those on WheelerLab3 and only concerning chr. 22 for speed purposes. These analyses include:

* Downloading the softwares
* Converting from PLINK format to software format
  * PLINK to LAMP-LD
  * PLINK to RFMix - see [Ad_PX_pipe steps 12-14](https://github.com/aandaleon/Ad_PX_pipe)
  * PLINK to Loter
* Simulating genotypes
  * 80% YRI/20% CEU, 6 generations, n = 20?
  * 80% YRI/20% CEU, 60 generations, n = 20?
  * 50% YRI/50% CEU, 6 generations, n = 20?
  * 50% YRI/50% CEU, 60 generations, n = 20?
* Measure accuracy of softwares
  * Convert output to similar formats
* Real genotypes
  * 1000G ASW (African-Americans in the Southwest US, n = NUMBER)
  * 1000G ACB (Afro-Carribeans in Barbados, n = NUMBER)

## Links
* LAMP-LD 
  * Paper: https://academic.oup.com/bioinformatics/article/28/10/1359/212139
  * Software: http://lamp.icsi.berkeley.edu/lamp/lampld/
* RFMix 
  * Paper: https://www.sciencedirect.com/science/article/pii/S0002929713002899?via%3Dihub
  * Software: https://sites.google.com/site/rfmixlocalancestryinference/
* Loter 
  * Paper: https://academic.oup.com/mbe/article/35/9/2318/5040668
  * Software: https://github.com/bcm-uga/Loter
* Comparison of local ancestry methods as of March 2018: https://academic.oup.com/bib/advance-article-abstract/doi/10.1093/bib/bby044/5047382
* Final class paper: https://docs.google.com/document/d/1QlbrgiLKPkVy-Au-3ti5TW6fP4YClN7w_6jRQNw7rGs/edit
* Final class presentation: https://docs.google.com/presentation/d/1LJXkkStQNTmNCr_zg6MTAqe_HDryur0adjWiqwoM06g/edit#slide=id.p
