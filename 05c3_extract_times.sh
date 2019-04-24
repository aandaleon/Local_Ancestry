#I like doing overkill so I pulled all the results using the command line
cd benchmarking/
echo nind,software,cmd_time,cmd_size > benchmarking_results.csv
for nind in 10 20 30 40 50 75 100; do
  for software in LAMP-LD RFMix ELAI; do  
    cmd_time=`sed -n -e 's/^.*Elapsed (wall clock) time (h:mm:ss or m:ss): //p' ${software}_sim_${nind}.txt`
    cmd_size=`sed -n -e 's/^.*Maximum resident set size (kbytes): //p' ${software}_sim_${nind}.txt`
    echo "$nind","$software","$cmd_time","$cmd_size" >> benchmarking_results.csv
  done
done
cd ..



