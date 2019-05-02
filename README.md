# Local Ancestry

My final project for Advanced Bioinformatics (BIOI 500) is a comparison of three local ancestry estimation softwares: LAMP-LD, RFMix, and ELAI. The project originally included [Loter](https://academic.oup.com/mbe/article-lookup/doi/10.1093/molbev/msy126), but had difficulty computing. This repository concerns running the actual comparative analysis, with paths directed to those on Wheeler Lab 3 and only concerning chr. 22 for speed purposes. My analyses are included in the paper and presentation links at the end of this README. I hope to have a future Wheeler lab member continue this project in real genotypic and transcriptomic data from the Multi-Ethnic Study of Atherosclerosis (MESA) and Modeling the Epidemiologic Transition Study (METS). Analyses performed include:

* [Downloading the softwares](https://github.com/aandaleon/Local_Ancestry/blob/master/01_testing_softwares.sh)
* [Simulating genotypes from 1000G CEU and YRI](https://github.com/aandaleon/Local_Ancestry/blob/master/02a1_simulate_admixture.sh)
  * 80% YRI/20% CEU, 6 generations, n = 20
  * 80% YRI/20% CEU, 60 generations, n = 20
  * 50% YRI/50% CEU, 6 generations, n = 20
  * 50% YRI/50% CEU, 60 generations, n = 20
* Converting to software format and run
  * [VCF to LAMP-LD](https://github.com/aandaleon/Local_Ancestry/blob/master/03a1_make_run_LAMP-LD.sh)
  * [VCF to RFMix](https://github.com/aandaleon/Local_Ancestry/blob/master/03b1_make_run_RFMix.sh)
  * [VCF to ELAI](https://github.com/aandaleon/Local_Ancestry/blob/master/03d_make_run_ELAI.sh)
* [Measure accuracy of softwares](https://github.com/aandaleon/Local_Ancestry/blob/master/04c_calc_accuracy.py)
* [Benchmarking with simulated genotypes](https://github.com/aandaleon/Local_Ancestry/blob/master/05a_make_benchmark_input.sh)
  * 10, 20, 30, 40, 50, 75, and 100 simulated AFA
    * 80% YRI/20% CEU, 6 generations

## Links
* BIOI 500 summaries
  * [Paper](https://docs.google.com/document/d/1YVKdQc5WmQK9lJFTgaxiBgNVxHsKWZ4x_5nJwLcCf-Q/edit?usp=sharing)
  * [Presentation](https://docs.google.com/presentation/d/1LJXkkStQNTmNCr_zg6MTAqe_HDryur0adjWiqwoM06g/edit?usp=sharing)
* LAMP-LD 
  * [Paper](https://academic.oup.com/bioinformatics/article/28/10/1359/212139)
  * [Software](http://lamp.icsi.berkeley.edu/lamp/lampld/)
* RFMix 
  * [Paper](https://www.sciencedirect.com/science/article/pii/S0002929713002899?via%3Dihub)
  * [Software](https://sites.google.com/site/rfmixlocalancestryinference/)
* ELAI
  * [Paper](http://www.genetics.org/content/196/3/625.long)
  * [Software](http://www.haplotype.org/elai.html)

