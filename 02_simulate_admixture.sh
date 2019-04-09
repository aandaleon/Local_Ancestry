#simulate African-American admixture using 1000 Genomes Project genotypes populations YRI (Yoruba in Ibadan, Nigeria) and CEU (Utah Residents (CEPH) with Northern and Western European Ancestry)

awk -F',' '{if ($3 == "YRI" || $3 == "CEU") {print $1,$3}}' /home/angela/1000G/fams/1000G_pops_fam.csv | tail -n +2 > pop_codes.txt #get IDs and population codes of 1000G data that match YRI or CEU; also I'm semi-proud of doing this in awk
head -n 3 pop_codes.txt
  #NA06985 CEU
  #NA06986 CEU
  #NA06989 CEU
git clone https://github.com/slowkoni/admixture-simulation.git #repo by the maintainer of RFMix




