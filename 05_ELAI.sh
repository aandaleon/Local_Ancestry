#make files for and run ELAI (using files from the RFMix run)
#bash 05_ELAI.sh --CEU sim_RFMix/CEU_ACB_ref.vcf.gz --YRI sim_RFMix/YRI_ACB_ref.vcf.gz --adm sim_RFMix/ACB.vcf.gz --out ACB

while :
do
    case "$1" in
      --NAT) #path to Native American .vcf reference file (see RFMix output)
	        NAT="$2"  
	        shift 2
	        ;;
      --CEU) #path to European .vcf reference file (see RFMix output)
         	CEU="$2"
	        shift 2
	        ;;
      --YRI) #path to west African .vcf reference file (see RFMix output)
      	 	YRI="$2"
	        shift 2
	        ;;
      --adm) #path to admixed .vcf file
          adm="$2"
	        shift 2
	        ;;
      --out) #output prefix
          out="$2"
	        shift 2
	        ;;
	     *)  # No more options
          shift
	        break
	        ;;
     esac #CEU vcf, NAT vcf if it exists, and YRI vcf if it exists
done

#to store files
mkdir -p sim_ELAI/
mkdir -p sim_ELAI/results/

#convert references to BIMBAM
if [[ -f $NAT ]]; then
  /usr/local/bin/plink --vcf $NAT --recode bimbam --out sim_ELAI/${out}_NAT
fi
if [[ -f $CEU ]]; then
  /usr/local/bin/plink --vcf $CEU --recode bimbam --out sim_ELAI/${out}_CEU
fi
if [[ -f $YRI ]]; then
  /usr/local/bin/plink --vcf $YRI --recode bimbam --out sim_ELAI/${out}_YRI
fi

#convert adm to bimbam
/usr/bin/bcftools convert $adm -Ob -o sim_ELAI/$out.bcf.gz #runs into error when going directly from vcf
/usr/local/bin/plink --bcf sim_ELAI/$out.bcf.gz --recode bimbam --out sim_ELAI/$out

#run ELAI
dir=$(pwd)
echo ELAI is annoying and you have to have a copy you can run locally to write the output, so get your very own ELAI directory to also be annoyed.

if [[ -f $NAT && $CEU && $YRI ]]; then
    echo "Running 3-way admixture between NAT, CEU, and YRI"
    cd /home/angela/BIOI500_Local_Ancestry/elai/
    (/usr/bin/time -v ./elai-lin -g $dir/sim_ELAI/${out}_NAT.recode.geno.txt -p 10 -g $dir/sim_ELAI/${out}_CEU.recode.geno.txt -p 11 -g $dir/sim_ELAI/${out}_YRI.recode.geno.txt -p 12 -g sim_ELAI/${out}.recode.geno.txt -p 1 -pos $dir/sim_ELAI/${out}.recode.pos.txt -o ${out}) 2> $dir/sim_ELAI/results/${out}_benchmarking.txt
elif [[ -f $NAT && $CEU ]]; then
    echo "Running 2-way admixture between NAT and CEU"
    cd /home/angela/BIOI500_Local_Ancestry/elai/
    (/usr/bin/time -v ./elai-lin -g $dir/sim_ELAI/${out}_NAT.recode.geno.txt -p 10 -g $dir/sim_ELAI/${out}_CEU.recode.geno.txt -p 11 -g $dir/sim_ELAI/${out}.recode.geno.txt -p 1 -pos $dir/sim_ELAI/${out}.recode.pos.txt -o ${out}) 2> $dir/sim_ELAI/results/${out}_benchmarking.txt
elif [[ -f $YRI && $CEU ]]; then
    echo "Running 2-way admixture between CEU and YRI"
    cd /home/angela/BIOI500_Local_Ancestry/elai/
    (/usr/bin/time -v ./elai-lin -g $dir/sim_ELAI/${out}_CEU.recode.geno.txt -p 10 -g $dir/sim_ELAI/${out}_YRI.recode.geno.txt -p 11 -g $dir/sim_ELAI/${out}.recode.geno.txt -p 1 -pos $dir/sim_ELAI/${out}.recode.pos.txt -o ${out}) 2> $dir/sim_ELAI/results/${out}_benchmarking.txt
elif [[ -f $NAT && $YRI ]]; then
    echo "Running 2-way admixture between NAT and YRI"
    cd /home/angela/BIOI500_Local_Ancestry/elai/
    (/usr/bin/time -v ./elai-lin -g $dir/sim_ELAI/${out}_NAT.recode.geno.txt -p 10 -g $dir/sim_ELAI/${out}_YRI.recode.geno.txt -p 11 -g $dir/sim_ELAI/${out}.recode.geno.txt -p 1 -pos $dir/sim_ELAI/${out}.recode.pos.txt -o ${out}) 2> $dir/sim_ELAI/results/${out}_benchmarking.txt
else
    echo "Please input a proper combination of reference files for your cohort."
fi

mv output/$out.ps21.txt $dir/sim_ELAI/results/$out.results.txt
cd $dir
echo Output is at sim_ELAI/results/${out}.ps.21.txt. Have a nice day!
