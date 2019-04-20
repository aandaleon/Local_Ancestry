#make input of simulated datasets for benchmarking
#make the differing sizes of input; assuming all the simulation input files are already available in admixture-simulaton/
mkdir -p benchmarking/
cd admixture-simulation/
for nind in {10 20 30 40 50 75 100}; do
  python do-admixture-simulation.py --input-vcf 1000G_80_20.recode.vcf --sample-map pop_codes_80_20.txt --chromosome 22 --n-output ${nind} --n-generations 6 --genetic-map chr22.interpolated_genetic_map.pruned --output-basename ../benchmarking/${nind}_nind
done

#make LAMP-LD input

#make RFMix input

#make ELAI input

