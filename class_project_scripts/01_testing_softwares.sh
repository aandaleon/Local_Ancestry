#Downloading, unpacking, running example data, and generally figuring out the three softwares
mkdir BIOI500_Local_Ancestry/
cd BIOI500_Local_Ancestry/

###LAMP-LD
#Installing
wget http://lamp.icsi.berkeley.edu/lamp/WrGa1F6NYt9KgR2pFgrCAzC3kzVg8kUezTQusIRufF1w2KaL88AqDXla9MSanFjX0tuZYtrP4Iq1kE6tmp/LAMPLD-v1.0.tgz
tar -xvzf LAMPLD-v1.0.tgz
rm LAMPLD-v1.0.tgz
cd LAMPLD-v1.0/
make clean ; make all ; make install #suggested by the README

#Test data
perl run_LAMPPED.pl test_data/chr1.pos test_data/EUR_haps.ref test_data/NA_haps.ref test_data/YRI_haps.ref test_data/trio.gen test_data/lampped.out
  #test_data/chr1.pos - physical pos. of each SNP in the data
  #test_data/EUR_haps.ref, test_data/NA_haps.ref, test_data/YRI_haps.ref - haplotype data w/ one haplotype per line in a 0/1/? format
  #test_data/trio.gen - haplotypes of the admixed sample
  #test_data/lampped.out  - estimation of local ancestries, one diploid sample per line
head test_data/lampld.out #I don't know how to read this
 #00:1803 01:2046 02:2560 01:3561 02:7819 00:11041 02:13499 22:15331 12:18260 01:20211 02:20771 01:22161 02:32575 00:34819 02:37292 01:37817 00:38450 01:38895 11:49553
 #22:681 02:1512 01:2233 11:3463 01:4571 02:7360 01:8074 00:10339 02:11702 00:14739 01:15381 02:16087 01:17382 02:22039 00:22829 02:23480 01:24822 12:27282 00:33162 02:35774 22:36566 02:37078 01:37362 00:37916 02:38366 01:38839 11:49553
 #02:1512 01:3670 00:12508 01:13435 02:14619 12:15331 01:17413 12:18183 02:20723 12:22005 01:22309 02:24549 00:24822 02:27282 00:33009 02:35193 22:36566 02:37292 01:37939 02:38386 11:49553
 #00:1803 01:2046 02:2560 01:3561 02:7819 00:11041 02:13499 22:15331 12:18260 01:20211 02:20771 01:22161 02:32575 00:34819 02:37292 01:37817 00:38450 01:38895 11:49553
 #22:681 02:1512 01:2233 11:3463 01:4571 02:7360 01:8074 00:10339 02:11702 00:14739 01:15381 02:16087 01:17382 02:22039 00:22829 02:23480 01:24822 12:27282 00:33162 02:35774 22:36566 02:37078 01:37362 00:37916 02:38366 01:38839 11:49553
 #02:1512 01:3670 00:12508 01:13435 02:14619 12:15331 01:17413 12:18183 02:20723 12:22005 01:22309 02:24549 00:24822 02:27282 00:33009 02:35193 22:36566 02:37292 01:37939 02:38386 11:49553
perl convertLAMPLDout.pl test_data/lampld.out test_data/lampld.out.long #convert from compact to long format
cd ..

###RFMix
#Installing
wget https://www.dropbox.com/s/cmq4saduh9gozi9/RFMix_v1.5.4.zip #why is this on dropbox
unzip RFMix_v1.5.4.zip
rm -r __MACOSX/ #ew
rm RFMix_v1.5.4.zip
cd RFMix_v1.5.4/
cd PopPhased/ #compile PopPhased
g++ -Wall -O3 -ftree-vectorize -fopenmp main.cpp getdata.cpp randomforest.cpp crfviterbi.cpp windowtosnp.cpp -o RFMix_PopPhased
cd ../TrioPhased/ #compile TrioPhased
g++ -Wall -O3 -ftree-vectorize -fopenmp main.cpp getdata.cpp randomforest.cpp crfviterbi.cpp windowtosnp.cpp -o RFMix_TrioPhased
cd ..

#Test data
python RunRFMix.py TrioPhased ./TestData/alleles1.txt ./TestData/classes.txt ./TestData/markerLocationsChr1.txt -o outputTrioPhased
cd TestData/
Rscript getDiploidAccuraciesTrioPhased.R
cd ..
python RunRFMix.py PopPhased ./TestData/alleles1.txt ./TestData/classes.txt ./TestData/markerLocationsChr1.txt -o outputPopPhased
  #./TestData/alleles1.txt - one row per SNP and one column per haplotype, no delimiters
  #./TestData/classes.txt - one row with one column per haplotype, space delimited
  #./TestData/markerLocationsChr1.txt - one row per SNP and one column, with each row the genetic coordinates in cM
cd TestData/
Rscript getDiploidAccuraciesPopPhased.R
cd ../..

###Loter
git clone https://github.com/bcm-uga/Loter.git
cd Loter/python-package/
python setup.py install
cd ..

#Test data
loter_cli -r data/H_ceu.npy -r data/H_yri.npy -a data/H_mex.npy -f npy -o tmp.npy -n 8 -v #the example command they have doesn't include the -r flag
  #example data is in numpy format; use -f vcf for .vcf files (what even is numpy format?)
  #suggested haplotpye simulator: https://github.com/BioShock38/aede

###ELAI
wget http://www.haplotype.org/download/elai.tar.gz
cd elai/
./elai-lin -g example/hap.ceu.chr22.inp -p 10 -g example/hap.yri.chr22.inp -p 11 -g example/admix-1cm.inp -p 1 -pos example/hgdp.chr22.pos -o test
  #-g: genotypes in BIMBAM format; first line is number of inds and second line is number of SNPs
  #-p: population laber (10 and 11 for CEU and YRI?)
  #-pos: SNP position file
  #-0: output prefix
  


