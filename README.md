```
export CPLEX_STUDIO_DIR="/opt/ibm/ILOG/CPLEX_Studio201/"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ibm/ILOG/CPLEX_Studio201/opl/bin/x86-64_linux/

julia --threads=auto --project=. test.jl
```
