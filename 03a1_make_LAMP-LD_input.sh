mkdir sim_LAMPLD/
cd sim_LAMPLD/
tail -n+2 ../admixture-simulation/admixed_80_20_6_gen.result | awk '{print $2}' > chr22.pos
  #common position file
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > YRI_50.txt #for extraction of reference pops. later
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > CEU_50.txt
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > YRI_80.txt
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > CEU_20.txt

#80_20_6
mkdir 80_20_6/
cd 80_20_6/
bcftools view -S ../YRI_80.txt --force-samples -o YRI_ref.vcf ../../admixture-simulation/admixed_80_20_6_gen.ref.bcf.gz #extract reference pops inds (not founders)
bcftools view -S ../CEU_20.txt --force-samples -o CEU_ref.vcf ../../admixture-simulation/admixed_80_20_6_gen.ref.bcf.gz

bcftools convert --hapsample --vcf-ids ../../admixture-simulation/admixed_80_20_6_gen.query.vcf -o admixed.haps #weird haplotype format; convert to LAMP-LD format externally
bcftools convert --hapsample --vcf-ids YRI_ref.vcf -o YRI.haps
bcftools convert --hapsample --vcf-ids CEU_ref.vcf -o CEU.haps

python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz admixed.haps.hap.gz --haps admixed.haps --adm #admixed haplotypes are special for some reason
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz YRI.haps.hap.gz --haps YRI.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz CEU.haps.hap.gz --haps CEU.haps

../../LAMPLD-v1.0/bin/unolanc2way 300 15 ../chr22.pos CEU.haps YRI.haps admixed.haps admixed_est.txt #version of LAMP-LD for 2-way admixture
 #use default window size of 300 and default number of states HMM 15
perl ../../LAMPLD-v1.0/convertLAMPLDout.pl admixed_est.txt admixed_est.long #convert from compact to long format
cd ..

#80_20_60
mkdir 80_20_60/
cd 80_20_60/
bcftools view -S ../YRI_80.txt --force-samples -o YRI_ref.vcf ../../admixture-simulation/admixed_80_20_60_gen.ref.bcf.gz #extract reference pops inds (not founders)
bcftools view -S ../CEU_20.txt --force-samples -o CEU_ref.vcf ../../admixture-simulation/admixed_80_20_60_gen.ref.bcf.gz
bcftools convert --hapsample --vcf-ids ../../admixture-simulation/admixed_80_20_60_gen.query.vcf -o admixed.haps 
bcftools convert --hapsample --vcf-ids YRI_ref.vcf -o YRI.haps
bcftools convert --hapsample --vcf-ids CEU_ref.vcf -o CEU.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz admixed.haps.hap.gz --haps admixed.haps --adm 
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz YRI.haps.hap.gz --haps YRI.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz CEU.haps.hap.gz --haps CEU.haps
../../LAMPLD-v1.0/bin/unolanc2way 300 15 ../chr22.pos CEU.haps YRI.haps admixed.haps admixed_est.txt
perl ../../LAMPLD-v1.0/convertLAMPLDout.pl admixed_est.txt admixed_est.long
cd ..
 
#50_50_6
mkdir 50_50_6/
cd 50_50_6/
bcftools view -S ../YRI_50.txt --force-samples -o YRI_ref.vcf ../../admixture-simulation/admixed_50_50_6_gen.ref.bcf.gz #extract reference pops inds (not founders)
bcftools view -S ../CEU_50.txt --force-samples -o CEU_ref.vcf ../../admixture-simulation/admixed_50_50_6_gen.ref.bcf.gz
bcftools convert --hapsample --vcf-ids ../../admixture-simulation/admixed_50_50_6_gen.query.vcf -o admixed.haps 
bcftools convert --hapsample --vcf-ids YRI_ref.vcf -o YRI.haps
bcftools convert --hapsample --vcf-ids CEU_ref.vcf -o CEU.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz admixed.haps.hap.gz --haps admixed.haps --adm 
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz YRI.haps.hap.gz --haps YRI.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz CEU.haps.hap.gz --haps CEU.haps
../../LAMPLD-v1.0/bin/unolanc2way 300 15 ../chr22.pos CEU.haps YRI.haps admixed.haps admixed_est.txt
perl ../../LAMPLD-v1.0/convertLAMPLDout.pl admixed_est.txt admixed_est.long
cd ..

#50_50_60
mkdir 50_50_60/
cd 50_50_60/
bcftools view -S ../YRI_50.txt --force-samples -o YRI_ref.vcf ../../admixture-simulation/admixed_50_50_60_gen.ref.bcf.gz #extract reference pops inds (not founders)
bcftools view -S ../CEU_50.txt --force-samples -o CEU_ref.vcf ../../admixture-simulation/admixed_50_50_60_gen.ref.bcf.gz
bcftools convert --hapsample --vcf-ids ../../admixture-simulation/admixed_50_50_60_gen.query.vcf -o admixed.haps 
bcftools convert --hapsample --vcf-ids YRI_ref.vcf -o YRI.haps
bcftools convert --hapsample --vcf-ids CEU_ref.vcf -o CEU.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz admixed.haps.hap.gz --haps admixed.haps --adm 
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz YRI.haps.hap.gz --haps YRI.haps
python ../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz CEU.haps.hap.gz --haps CEU.haps
../../LAMPLD-v1.0/bin/unolanc2way 300 15 ../chr22.pos CEU.haps YRI.haps admixed.haps admixed_est.txt
perl ../../LAMPLD-v1.0/convertLAMPLDout.pl admixed_est.txt admixed_est.long
cd ..
 
