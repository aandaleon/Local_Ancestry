#we getting meta up in here
echo bash 02a1_simulate_admixture.sh
bash 02a1_simulate_admixture.sh

echo bash 03a1_make_run_LAMP-LD.sh
bash 03a1_make_run_LAMP-LD.sh

echo bash 03b1_make_run_RFMix.sh
bash 03b1_make_run_RFMix.sh

echo bash 03d_make_run_ELAI.sh
bash 03d_make_run_ELAI.sh

echo python 04c_calc_accuracy.py
python 04c_calc_accuracy.py