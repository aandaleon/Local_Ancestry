#simulate African-American admixture using 1000 Genomes Project genotypes populations YRI (Yoruba in Ibadan, Nigeria) and CEU (Utah Residents (CEPH) with Northern and Western European Ancestry)

#filter input VCF and randomly sample for proportions
awk -F',' '{if ($3 == "YRI" || $3 == "CEU") {print $1,$3}}' /home/angela/1000G/fams/1000G_pops_fam.csv | tail -n +2 > pop_codes.txt #get IDs and population codes of 1000G data that match YRI or CEU; also I'm semi-proud of doing this in awk
head -n 3 pop_codes.txt
  #NA06985 CEU
  #NA06986 CEU
  #NA06989 CEU
git clone https://github.com/slowkoni/admixture-simulation.git #repo by the maintainer of RFMix
cd admixture-simulation/

vcftools --vcf /home/angela/1000G/1000G.vcf --out 1000G_CEU_YRI_22 --keep ../pop_codes.txt --chr 22 --recode
  #Keeping individuals in 'keep' list
  #After filtering, kept 205 out of 2504 individuals
  #Outputting VCF file...
  #After filtering, kept 170949 out of a possible 1257350 Sites
  #Run Time = 573.00 seconds
bcftools +prune -l 0.6 -w 1000 1000G_CEU_YRI_22.recode.vcf -Ov -o 1000G_CEU_YRI_22.pruned.vcf #LAMP-LD doesn't work w/ over 50,000 SNPs, so LD-prune until chr. 22 is < 50,000; https://www.biostars.org/p/338289/
vcf-query -l 1000G_CEU_YRI_22.pruned.vcf > 1000G_CEU_YRI_22.pruned.vcf_ids.txt
Rscript ../02b_sample_1000G.R #outputs splits of 80 YRI/20 CEU or 50/50 to subset vcf to
vcftools --vcf 1000G_CEU_YRI_22.pruned.vcf --out 1000G_80_20 --keep pop_codes_80_20.txt --chr 22 --recode
vcftools --vcf 1000G_CEU_YRI_22.pruned.vcf --out 1000G_50_50 --keep pop_codes_50_50.txt --chr 22 --recode

#FIX GENETIC MAP 4-16-19
wget https://github.com/joepickrell/1000-genomes-genetic-maps/raw/master/interpolated_from_hapmap/chr22.interpolated_genetic_map.gz
gunzip chr22.interpolated_genetic_map.gz
grep -v "^##" 1000G_CEU_YRI_22.pruned.vcf | cut -f1-3 > chr22.interpolated_genetic_map.snps.txt #pull SNPs in file
cd ..  #give genetic positions to SNPs in file and save as map
Rscript 02a2_fix_genetic_map.R
cd admixture-simulation/
#tail -n+2 /home/angela/1000GP_Phase3_combined/genetic_map_chr22_combined_b37.txt | awk -F' ' '{print "22",$1,$3}' | awk -v OFS="\t" '$1=$1' > genetic_map_chr22.txt #genetic map w/o "chr"

#four combinations of admixed pops to test
python do-admixture-simulation.py --input-vcf 1000G_80_20.recode.vcf --sample-map pop_codes_80_20.txt --chromosome 22 --n-output 20 --n-generations 6 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename admixed_80_20_6_gen
python do-admixture-simulation.py --input-vcf 1000G_80_20.recode.vcf --sample-map pop_codes_80_20.txt --chromosome 22 --n-output 20 --n-generations 60 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename admixed_80_20_60_gen
python do-admixture-simulation.py --input-vcf 1000G_50_50.recode.vcf --sample-map pop_codes_50_50.txt --chromosome 22 --n-output 20 --n-generations 6 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename admixed_50_50_6_gen
python do-admixture-simulation.py --input-vcf 1000G_50_50.recode.vcf --sample-map pop_codes_50_50.txt --chromosome 22 --n-output 20 --n-generations 60 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename admixed_50_50_60_gen
cd ..
