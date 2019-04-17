mkdir sim_RFMix/
cd sim_RFMix/

#common files
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > YRI_50.txt #for extraction of reference pops. later
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > CEU_50.txt
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > YRI_80.txt
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > CEU_20.txt

#4-16-19 #INCORRECT MAP FIX THIS ASAP
awk '{print $3}' ../admixture-simulation/genetic_map_chr22.txt > chr22.snp_locations

#80_20_6/
mkdir 80_20_6/
cd 80_20_6/

#merge ref and query
bcftools view -S ../YRI_80.txt --force-samples -Oz -o YRI_ref.vcf.gz ../../admixture-simulation/admixed_80_20_6_gen.ref.bcf.gz #extract reference pops inds (not founders)
bcftools view -S ../CEU_20.txt --force-samples -Oz -o CEU_ref.vcf.gz ../../admixture-simulation/admixed_80_20_6_gen.ref.bcf.gz
cp ../../admixture-simulation/admixed_80_20_6_gen.query.vcf admixed.vcf; bgzip admixed.vcf
bcftools index --threads 40 -f --tbi YRI_ref.vcf.gz > YRI_ref.vcf.tbi
bcftools index --threads 40 -f --tbi CEU_ref.vcf.gz > CEU_ref.vcf.tbi
bcftools index --threads 40 -f --tbi admixed.vcf.gz > admixed.vcf.tbi
bcftools merge -Ov YRI_ref.vcf.gz CEU_ref.vcf.gz admixed.vcf.gz -o merged.vcf
vcf-query -l merged.vcf > merged.vcf_ids.txt

#make classes file
Rscript ../../03b2_make_RFMix_classes.R merged.vcf_ids.txt

#make haplotypes file
bcftools convert --hapsample --vcf-ids merged.vcf -o merged.haps
zcat merged.haps.hap.gz | awk '{ $1=""; $2=""; $3=""; $4=""; $5=""; print}' | sed 's/\s//g' > merged.haps #I'm impressed I could do this in one line tbh

