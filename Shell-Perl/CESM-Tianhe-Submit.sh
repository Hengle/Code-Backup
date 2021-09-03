#!/bin/bash
cat << EOF > run.sh
#!/bin/bash
yhrun -n 140 -N 5 -p TH_HPC1 ./cesm.exe
EOF

chmod u+x run.sh

yhbatch -n 140 -N 5 -p TH_HPC1 -J qqf ./run.sh
