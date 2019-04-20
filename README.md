# Local Ancestry

My final project for Advanced Bioinformatics (BIOI 500) is a comparison of three local ancestry estimation softwares: LAMP-LD, RFMix, and ELAI. The project originally included [Loter](https://academic.oup.com/mbe/article-lookup/doi/10.1093/molbev/msy126), but had difficulty computing, and all scripts from Loter analyses have been preserved. This repository concerns running the actual comparative analysis, with paths directed to those on wheelerlab3 and only concerning chr. 22 for speed purposes. These analyses include:

* [Downloading the softwares](https://github.com/aandaleon/Local_Ancestry/blob/master/01_testing_softwares.sh)
* [Simulating genotypes from 1000G CEU and YRI](https://github.com/aandaleon/Local_Ancestry/blob/master/02a1_simulate_admixture.sh)
  * 80% YRI/20% CEU, 6 generations, n = 20
  * 80% YRI/20% CEU, 60 generations, n = 20
  * 50% YRI/50% CEU, 6 generations, n = 20
  * 50% YRI/50% CEU, 60 generations, n = 20
* Converting to software format and run
  * [VCF to LAMP-LD](https://github.com/aandaleon/Local_Ancestry/blob/master/03a1_make_run_LAMP-LD.sh)
  * [VCF to RFMix](https://github.com/aandaleon/Local_Ancestry/blob/master/03b1_make_run_RFMix.sh)
  * [VCF to ELAI](https://github.com/aandaleon/Local_Ancestry/)
* Measure accuracy of softwares
* Benchmarking (time & memory) with real genotypes (may do simulated if I run out of time)
  * 1000G ASW (African-Americans in the Southwest US, n = NUMBER)
  * 1000G ACB (Afro-Carribeans in Barbados, n = NUMBER)
  * MESA AFA (African-American, n = 233)

## Links
* LAMP-LD 
  * [Paper](https://academic.oup.com/bioinformatics/article/28/10/1359/212139)
  * [Software](http://lamp.icsi.berkeley.edu/lamp/lampld/)
* RFMix 
  * [Paper](https://www.sciencedirect.com/science/article/pii/S0002929713002899?via%3Dihub)
  * [Software](https://sites.google.com/site/rfmixlocalancestryinference/)
* ELAI
  * [Paper](http://www.genetics.org/content/196/3/625.long)
  * [Software](http://www.haplotype.org/elai.html)
* [Comparison of local ancestry methods as of March 2018](https://academic.oup.com/bib/advance-article-abstract/doi/10.1093/bib/bby044/5047382)
* Final for class
  * [Paper](https://docs.google.com/document/d/1QlbrgiLKPkVy-Au-3ti5TW6fP4YClN7w_6jRQNw7rGs/edit?usp=sharing)
  * [Presentation](https://docs.google.com/presentation/d/1LJXkkStQNTmNCr_zg6MTAqe_HDryur0adjWiqwoM06g/edit?usp=sharing)
