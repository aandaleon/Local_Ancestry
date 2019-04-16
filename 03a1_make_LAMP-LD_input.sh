EUmkdir sim_LAMPLD/
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



