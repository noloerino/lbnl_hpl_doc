#!/bin/bash
# (hopefully) automates parameter gathering
CORES_PER_NODE=$(lscpu | awk '/^CPU\(s\)/ { print $2 }')
SPEED_PER_CORE=$(lscpu | awk '/GHz/ { gsub(/GHz/, "", $0); print $NF }')
# assumes in kb
MEM_PER_NODE=$(($(awk '/MemTotal/ { print $2 }' /proc/meminfo) / 1000000))

cat <<EOF
params = {
    # number of nodes to be benchmarked
    'NODE_COUNT': FILL_ME,
    # number of cpu cores in every node
    'CORES_PER_NODE': $CORES_PER_NODE,
    # speed of every cpu core, in GHz (should be same for all cores)
    'SPEED_PER_CORE': $SPEED_PER_CORE,
    # memory available for every cpu core, in GB
    'MEM_PER_NODE': $MEM_PER_NODE,
    # instructions per cycle for cpu
    'INSTR_PER_CYCLE': 32 # just a guess, but most likely does not matter
}
"""
Copy paste this object into the provided iPython notebook.
Be careful with memory units. For reference, the full value in /proc/meminfo was
$(awk '/MemTotal/ { print $2 " " $3 }' /proc/meminfo)
"""
EOF
