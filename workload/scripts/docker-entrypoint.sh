#!/bin/sh

export RUST_LOG=info

echo "starting cluster"
./load workload-config.json

echo "workload connected"
# Wait for sometime to start the fault injector and antithesis campaign
sleep 5

echo "starting workload loop"

N=2
for i in $(seq 1 10); do
    echo "starting workload ${i}"
    ./workload workload-config.json &
    # limit parallel jobs
    if (( i % N == 0 )); then
        wait
    fi
done&

while true
do
    echo "validation check"
    ./validation logs
    sleep 20
done