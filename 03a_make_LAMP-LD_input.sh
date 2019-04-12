mkdir sim_LAMPLD/
cd sim_LAMPLD/
tail -n+2 ../admixture-simulation/admixed_80_20_6_gen.result | awk '{print $2}' > chr22.pos
  #common position file
awk '{if ($2 == "YRI") {print $0}}' ../admixture-simulation/pop_codes_50_50.txt > YRI_50.txt #for extraction of reference pops. later
awk '{if ($2 == "CEU") {print $0}}' ../admixture-simulation/pop_codes_50_50.txt > CEU_50.txt
awk '{if ($2 == "YRI") {print $0}}' ../admixture-simulation/pop_codes_80_20.txt > YRI_80.txt
awk '{if ($2 == "CEU") {print $0}}' ../admixture-simulation/pop_codes_80_20.txt > YRI_20.txt

#80_20_6
mkdir 80_20_6/
cd 80_20_6/





