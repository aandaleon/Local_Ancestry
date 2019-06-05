mkdir sim_RFMix/
cd sim_RFMix/

#common files
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > YRI_50.txt #for extraction of reference pops. later
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_50_50.txt > CEU_50.txt
awk '{if ($2 == "YRI") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > YRI_80.txt
awk '{if ($2 == "CEU") {print $1}}' ../admixture-simulation/pop_codes_80_20.txt > CEU_20.txt

#make cM map

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

#make cM map
sed  '/##/d' merged.vcf | cut -f3 > admixed.snps #get snps that are in admixed
cd ../..
Rscript 03b3_make_RFMix_genetic_map.R
cd sim_RFMix/
echo "$(tail -n +2 admixed_chr22.pos)" > admixed_chr22.pos

#run RFMix
cd ../RFMix_v1.5.4/ #it has to be run from the directory for some stupid reason
python RunRFMix.py PopPhased ../sim_RFMix/80_20_6/merged.haps ../sim_RFMix/80_20_6/merged.classes ../sim_RFMix/admixed_chr22.pos -o ../sim_RFMix/80_20_6/results
cd ../sim_RFMix/

#80_20_60
mkdir 80_20_60/
cd 80_20_60/
bcftools view -S ../YRI_80.txt --force-samples -Oz -o YRI_ref.vcf.gz ../../admixture-simulation/admixed_80_20_60_gen.ref.bcf.gz
bcftools view -S ../CEU_20.txt --force-samples -Oz -o CEU_ref.vcf.gz ../../admixture-simulation/admixed_80_20_60_gen.ref.bcf.gz
cp ../../admixture-simulation/admixed_80_20_6_gen.query.vcf admixed.vcf; bgzip admixed.vcf
bcftools index --threads 40 -f --tbi YRI_ref.vcf.gz > YRI_ref.vcf.tbi
bcftools index --threads 40 -f --tbi CEU_ref.vcf.gz > CEU_ref.vcf.tbi
bcftools index --threads 40 -f --tbi admixed.vcf.gz > admixed.vcf.tbi
bcftools merge -Ov YRI_ref.vcf.gz CEU_ref.vcf.gz admixed.vcf.gz -o merged.vcf
vcf-query -l merged.vcf > merged.vcf_ids.txt
Rscript ../../03b2_make_RFMix_classes.R merged.vcf_ids.txt
bcftools convert --hapsample --vcf-ids merged.vcf -o merged.haps
zcat merged.haps.hap.gz | awk '{ $1=""; $2=""; $3=""; $4=""; $5=""; print}' | sed 's/\s//g' > merged.haps 
cd ../../RFMix_v1.5.4/
python RunRFMix.py PopPhased ../sim_RFMix/80_20_60/merged.haps ../sim_RFMix/80_20_60/merged.classes ../sim_RFMix/admixed_chr22.pos -o ../sim_RFMix/80_20_60/results
cd ../sim_RFMix/
 
#50_50_6
mkdir 50_50_6/
cd 50_50_6/
bcftools view -S ../YRI_80.txt --force-samples -Oz -o YRI_ref.vcf.gz ../../admixture-simulation/admixed_50_50_6_gen.ref.bcf.gz
bcftools view -S ../CEU_20.txt --force-samples -Oz -o CEU_ref.vcf.gz ../../admixture-simulation/admixed_50_50_6_gen.ref.bcf.gz
cp ../../admixture-simulation/admixed_80_20_6_gen.query.vcf admixed.vcf; bgzip admixed.vcf
bcftools index --threads 40 -f --tbi YRI_ref.vcf.gz > YRI_ref.vcf.tbi
bcftools index --threads 40 -f --tbi CEU_ref.vcf.gz > CEU_ref.vcf.tbi
bcftools index --threads 40 -f --tbi admixed.vcf.gz > admixed.vcf.tbi
bcftools merge -Ov YRI_ref.vcf.gz CEU_ref.vcf.gz admixed.vcf.gz -o merged.vcf
vcf-query -l merged.vcf > merged.vcf_ids.txt
Rscript ../../03b2_make_RFMix_classes.R merged.vcf_ids.txt
bcftools convert --hapsample --vcf-ids merged.vcf -o merged.haps
zcat merged.haps.hap.gz | awk '{ $1=""; $2=""; $3=""; $4=""; $5=""; print}' | sed 's/\s//g' > merged.haps 
cd ../../RFMix_v1.5.4/
python RunRFMix.py PopPhased ../sim_RFMix/50_50_6/merged.haps ../sim_RFMix/50_50_6/merged.classes ../sim_RFMix/admixed_chr22.pos -o ../sim_RFMix/50_50_6/results
cd ../sim_RFMix/

#50_50_60
mkdir 50_50_60/
cd 50_50_60/
bcftools view -S ../YRI_80.txt --force-samples -Oz -o YRI_ref.vcf.gz ../../admixture-simulation/admixed_50_50_60_gen.ref.bcf.gz
bcftools view -S ../CEU_20.txt --force-samples -Oz -o CEU_ref.vcf.gz ../../admixture-simulation/admixed_50_50_60_gen.ref.bcf.gz
cp ../../admixture-simulation/admixed_80_20_6_gen.query.vcf admixed.vcf; bgzip admixed.vcf
bcftools index --threads 40 -f --tbi YRI_ref.vcf.gz > YRI_ref.vcf.tbi
bcftools index --threads 40 -f --tbi CEU_ref.vcf.gz > CEU_ref.vcf.tbi
bcftools index --threads 40 -f --tbi admixed.vcf.gz > admixed.vcf.tbi
bcftools merge -Ov YRI_ref.vcf.gz CEU_ref.vcf.gz admixed.vcf.gz -o merged.vcf
vcf-query -l merged.vcf > merged.vcf_ids.txt
Rscript ../../03b2_make_RFMix_classes.R merged.vcf_ids.txt
bcftools convert --hapsample --vcf-ids merged.vcf -o merged.haps
zcat merged.haps.hap.gz | awk '{ $1=""; $2=""; $3=""; $4=""; $5=""; print}' | sed 's/\s//g' > merged.haps 
cd ../../RFMix_v1.5.4/
python RunRFMix.py PopPhased ../sim_RFMix/50_50_60/merged.haps ../sim_RFMix/50_50_60/merged.classes ../sim_RFMix/admixed_chr22.pos -o ../sim_RFMix/50_50_60/results
cd ..
 
