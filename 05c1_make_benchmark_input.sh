#make input of simulated datasets for benchmarking; for notes on what each step does see the OG simulation steps
mkdir -p benchmarking/
awk '{if ($2 == "YRI") {print $1}}' pop_codes.txt > benchmarking/YRI.txt 
awk '{if ($2 == "CEU") {print $1}}' pop_codes.txt > benchmarking/CEU.txt

#for nind in 10 20 30 40 50 75 100; do #make the differing sizes of input; assuming all the simulation input files are already available in admixture-simulaton/
for nind in 10; do
	echo Making cohort size ${nind}.
	mkdir -p benchmarking/sim_${nind}/
	mkdir -p benchmarking/sim_${nind}/intermediate/
	cd admixture-simulation/
	python do-admixture-simulation.py --input-vcf 1000G_80_20.recode.vcf --sample-map pop_codes_80_20.txt --chromosome 22 --n-output ${nind} --n-generations 6 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename ../benchmarking/sim_${nind}/intermediate/sim_${nind}

  #make LAMP-LD input
    echo Making LAMP-LD input.
	cd ../benchmarking/sim_${nind}/intermediate/
	bcftools view -S ../../YRI.txt --force-samples -o YRI_ref.vcf sim_${nind}.ref.bcf.gz
	bcftools view -S ../../CEU.txt --force-samples -o CEU_ref.vcf sim_${nind}.ref.bcf.gz
	bcftools convert --hapsample --vcf-ids sim_${nind}.query.vcf -o admixed.haps 
	bcftools convert --hapsample --vcf-ids YRI_ref.vcf -o YRI.haps
	bcftools convert --hapsample --vcf-ids CEU_ref.vcf -o CEU.haps
	python ../../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz admixed.haps.hap.gz --haps LAMP-LD_admixed.haps --adm
	python ../../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz YRI.haps.hap.gz --haps LAMP-LD_YRI.haps
	python ../../../03a2_bcftools_haps_to_LAMP-LD_haps.py --hap.gz CEU.haps.hap.gz --haps LAMP-LD_CEU.haps
	###COMMAND: ../../../LAMPLD-v1.0/bin/unolanc2way 300 15 ../../../sim_LAMPLD/chr22.pos LAMP-LD_YRI.haps LAMP-LD_CEU.haps LAMP-LD_admixed.haps LAMP-LD_out.txt; ../../../LAMPLD-v1.0/convertLAMPLDout.pl LAMP-LD_out.txt ../LAMP-LD_out.long #version of LAMP-LD for 2-way admixture

  #make RFMix input
	echo Making RFMix input.
	bgzip YRI_ref.vcf
	bgzip CEU_ref.vcf
	bgzip sim_${nind}.query.vcf
	bcftools index --threads 40 -f --tbi YRI_ref.vcf.gz > YRI_ref.vcf.tbi
	bcftools index --threads 40 -f --tbi CEU_ref.vcf.gz > CEU_ref.vcf.tbi
	bcftools index --threads 40 -f --tbi sim_${nind}.query.vcf.gz > sim_${nind}.query.vcf.tbi
	bcftools merge -Ov YRI_ref.vcf.gz CEU_ref.vcf.gz sim_${nind}.query.vcf.gz -o merged.vcf
	vcf-query -l merged.vcf > merged.vcf_ids.txt
	Rscript ../../../03b2_make_RFMix_classes.R merged.vcf_ids.txt
	bcftools convert --hapsample --vcf-ids merged.vcf -o merged.haps
	zcat merged.haps.hap.gz | awk '{ $1=""; $2=""; $3=""; $4=""; $5=""; print}' | sed 's/\s//g' > RFMix_merged.haps 
	###COMMAND: cd ../../../RFMix_v1.5.4/; RunRFMix.py PopPhased ../benchmarking/sim_${nind}/intermediate/RFMix_merged.haps ../benchmarking/sim_${nind}/intermediate/merged.classes ../sim_RFMix/admixed_chr22.pos -o ../benchmarking/sim_${nind}/RFMIX_out.txt
	
  #make ELAI input
	echo Making ELAI input.
	plink --vcf YRI_ref.vcf.gz --recode bimbam --out YRI
	plink --vcf CEU_ref.vcf.gz --recode bimbam --out CEU
	bcftools convert sim_${nind}.query.vcf.gz -Ob -o admixed.bcf.gz 
	plink --bcf admixed.bcf.gz --recode bimbam --out ELAI_admixed
	###COMMAND: cd ../../../elai; ./elai-lin blah blah blah

	echo Done making cohort size ${nind}.
	cd ../../../
done
echo Done making all sizes of simulated genotypes. Have a nice day :).


