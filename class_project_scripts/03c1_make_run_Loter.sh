#how is this somehow the most annoying software
mkdir sim_Loter
mkdir sim_Loter/80_20_6/
mkdir sim_Loter/80_20_60/
mkdir sim_Loter/50_50_6/
mkdir sim_Loter/50_50_60/

#RUN FROM WITHIN SPYDER CAUSE MY PIP IS BROKEN AND WONT INSTALL ALLEL ON WL3
python 03c2_make_Loter_npy.py

cd Loter/
loter_cli -r ../sim_Loter/80_20_6/YRI.npy -r ../sim_Loter/80_20_6/YRI.npy -a ../sim_Loter/80_20_6/adm.npy -o ../sim_Loter/80_20_6/results.txt
  #weird issues w/ trying to get allel installed (broke pip and now it won't work)
loter_cli -r ../sim_Loter/80_20_60/YRI.npy -r ../sim_Loter/80_20_60/YRI.npy -a ../sim_Loter/80_20_60/adm.npy -o ../sim_Loter/80_20_60/results.txt
loter_cli -r ../sim_Loter/50_50_6/YRI.npy -r ../sim_Loter/50_50_6/YRI.npy -a ../sim_Loter/50_50_6/adm.npy -o ../sim_Loter/50_50_6/results.txt
loter_cli -r ../sim_Loter/50_50_60/YRI.npy -r ../sim_Loter/50_50_60/YRI.npy -a ../sim_Loter/50_50_60/adm.npy -o ../sim_Loter/50_50_60/results.txt
