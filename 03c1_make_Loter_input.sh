#thankfully Loter seems deceptively easy (jk it never is)
mkdir sim_Loter/
mkdir sim_Loter/80_20_6/

cd Loter/
loter_cli -r ../sim_LAMPLD/80_20_6/YRI_ref.vcf -r ../sim_LAMPLD/80_20_6/CEU_ref.vcf -a ../admixture-simulation/admixed_80_20_6_gen.query.vcf -f vcf -o ../sim_Loter/80_20_6/results.txt
  #this command doesn't work so I guess I'm running this in Spyder




















