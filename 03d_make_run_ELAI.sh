cd elai/
mkdir ../sim_ELAI/

#80_20_6
mkdir ../sim_ELAI/80_20_6/
plink --vcf ../sim_LAMPLD/80_20_6/CEU_ref.vcf --recode bimbam --out ../sim_ELAI/80_20_6/CEU
plink --vcf ../sim_LAMPLD/80_20_6/YRI_ref.vcf --recode bimbam --out ../sim_ELAI/80_20_6/YRI
bcftools convert ../admixture-simulation/admixed_80_20_6_gen.query.vcf -Ob -o ../sim_ELAI/80_20_6/admixed.bcf.gz #runs into error when going directly from vcf
plink --bcf ../sim_ELAI/80_20_6/admixed.bcf.gz --recode bimbam --out ../sim_ELAI/80_20_6/admixed
./elai-lin -g ../sim_ELAI/80_20_6/CEU.recode.geno.txt -p 10 -g ../sim_ELAI/80_20_6/YRI.recode.geno.txt -p 11 -g ../sim_ELAI/80_20_6/admixed.recode.geno.txt -p 1 -pos ../sim_ELAI/80_20_6/admixed.recode.pos.txt -o results_80_20_6
mv output/results_80_20_6.ps21.txt ../sim_ELAI/80_20_6/results.txt

#80_20_60
mkdir ../sim_ELAI/80_20_60/
plink --vcf ../sim_LAMPLD/80_20_60/CEU_ref.vcf --recode bimbam --out ../sim_ELAI/80_20_60/CEU
plink --vcf ../sim_LAMPLD/80_20_60/YRI_ref.vcf --recode bimbam --out ../sim_ELAI/80_20_60/YRI
bcftools convert ../admixture-simulation/admixed_80_20_60_gen.query.vcf -Ob -o ../sim_ELAI/80_20_60/admixed.bcf.gz #runs into error when going directly from vcf
plink --bcf ../sim_ELAI/80_20_60/admixed.bcf.gz --recode bimbam --out ../sim_ELAI/80_20_60/admixed
./elai-lin -g ../sim_ELAI/80_20_60/CEU.recode.geno.txt -p 10 -g ../sim_ELAI/80_20_60/YRI.recode.geno.txt -p 11 -g ../sim_ELAI/80_20_60/admixed.recode.geno.txt -p 1 -pos ../sim_ELAI/80_20_60/admixed.recode.pos.txt -o results_80_20_60
mv output/results_80_20_60.ps21.txt ../sim_ELAI/80_20_60/results.txt

#50_50_6
mkdir ../sim_ELAI/50_50_6/
plink --vcf ../sim_LAMPLD/50_50_6/CEU_ref.vcf --recode bimbam --out ../sim_ELAI/50_50_6/CEU
plink --vcf ../sim_LAMPLD/50_50_6/YRI_ref.vcf --recode bimbam --out ../sim_ELAI/50_50_6/YRI
bcftools convert ../admixture-simulation/admixed_50_50_6_gen.query.vcf -Ob -o ../sim_ELAI/50_50_6/admixed.bcf.gz #runs into error when going directly from vcf
plink --bcf ../sim_ELAI/50_50_6/admixed.bcf.gz --recode bimbam --out ../sim_ELAI/50_50_6/admixed
./elai-lin -g ../sim_ELAI/50_50_6/CEU.recode.geno.txt -p 10 -g ../sim_ELAI/50_50_6/YRI.recode.geno.txt -p 11 -g ../sim_ELAI/50_50_6/admixed.recode.geno.txt -p 1 -pos ../sim_ELAI/50_50_6/admixed.recode.pos.txt -o results_50_50_6
mv output/results_50_50_6.ps21.txt ../sim_ELAI/50_50_6/results.txt

#50_50_60
mkdir ../sim_ELAI/50_50_60/
plink --vcf ../sim_LAMPLD/50_50_60/CEU_ref.vcf --recode bimbam --out ../sim_ELAI/50_50_60/CEU
plink --vcf ../sim_LAMPLD/50_50_60/YRI_ref.vcf --recode bimbam --out ../sim_ELAI/50_50_60/YRI
bcftools convert ../admixture-simulation/admixed_50_50_60_gen.query.vcf -Ob -o ../sim_ELAI/50_50_60/admixed.bcf.gz #runs into error when going directly from vcf
plink --bcf ../sim_ELAI/50_50_60/admixed.bcf.gz --recode bimbam --out ../sim_ELAI/50_50_60/admixed
./elai-lin -g ../sim_ELAI/50_50_60/CEU.recode.geno.txt -p 10 -g ../sim_ELAI/50_50_60/YRI.recode.geno.txt -p 11 -g ../sim_ELAI/50_50_60/admixed.recode.geno.txt -p 1 -pos ../sim_ELAI/50_50_60/admixed.recode.pos.txt -o results_50_50_60
mv output/results_50_50_60.ps21.txt ../sim_ELAI/50_50_60/results.txt
