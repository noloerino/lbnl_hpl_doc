#!/bin/bash
# instructions courtesy of Matthew Li
# https://github.com/matthew-li/lbnl_hpl_doc
#
# runs LINPAC test on this node
#
# this can be submitted as a SLURM job once HPL.dat is configured,
# although since this is usually used on nodes not yet in the SLURM rotation, this
# usually should just be run as a shell script)
# furthermore, caution should be exercised to make sure that the parameters are appropriate
# for the node that SLURM assigns the job to
#
#SBATCH --job-name=linpac
#SBATCH --account=ac_scsguest
# CHANGE PARTITION AS APPROPRIATE
#SBATCH --partition=savio2
#SBATCH --time=08:30:00
# CHANGE NODES AS APPROPRIATE
#SBATCH --nodes=1
#SBATCH --exclusive

module load intel/2018.1.163
module load openmpi/2.0.2-intel
module load mkl/2018.1.163

EXEC_DIR="hpl-2.2/bin/intel64/"
PARAMS_FILE="HPL.dat"
ln -sf "$EXEC_DIR/HPL.dat" $PARAMS_FILE
ln -sf "$EXEC_DIR/xhpl" xhpl

P=$(awk '/Ps/ { print $1 }' $PARAMS_FILE)
Q=$(awk '/Qs/ { print $1 }' $PARAMS_FILE)
PQ=$(($P * $Q))

OUTPUT_DIR="$HOME/scratch/benchmarks"
mkdir -p $OUTPUT_DIR

STARTTIME=$(date '+%s')
if [ $# -eq 1 ]; then
    TESTNAME="test-$1-$STARTTIME"
else
    TESTNAME="test-$(hostname)-$STARTTIME"
fi

echo "Started $TESTNAME at $(date -d @$STARTTIME) with P=$P, Q=$Q" >> "$OUTPUT_DIR/testtimes.log"
echo "Starting test $TESTNAME. See output by running 'tail -f $OUTPUT_DIR/$TESTNAME.out'"
mpirun -np $PQ -hostfile nodelist ./xhpl > "$OUTPUT_DIR/$TESTNAME.out"
echo "Finished $TESTNAME at $(date)" >> "$OUTPUT_DIR/testtimes.log"
