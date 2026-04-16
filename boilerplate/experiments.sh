#!/bin/bash
# Task 5: Scheduler Experiments

SOCKET=/tmp/mini_runtime.sock
ENGINE=./engine

wait_for_exit() {
    local id=$1
    while sudo $ENGINE ps | grep -q "^$id.*running"; do
        sleep 0.5
    done
}

echo "============================================"
echo "EXPERIMENT 1: CPU-bound with different nice"
echo "============================================"

# Prepare fresh rootfs
rm -rf rootfs-exp1a rootfs-exp1b
cp -a rootfs-base rootfs-exp1a
cp -a rootfs-base rootfs-exp1b
cp cpu_hog rootfs-exp1a/
cp cpu_hog rootfs-exp1b/
chmod +x rootfs-exp1a/cpu_hog rootfs-exp1b/cpu_hog

# Check supervisor
if ! [ -S $SOCKET ]; then
    echo "ERROR: Start supervisor first:"
    echo "sudo ./engine supervisor ./rootfs-base"
    exit 1
fi

echo "[Exp1] Starting containers..."

T1_START=$(date +%s%N)
sudo $ENGINE start exp1a ./rootfs-exp1a /cpu_hog --nice 0

T2_START=$(date +%s%N)
sudo $ENGINE start exp1b ./rootfs-exp1b /cpu_hog --nice 10

# Measure completion independently
while true; do
    if ! sudo $ENGINE ps | grep -q "^exp1a.*running"; then
        T1_END=$(date +%s%N)
        break
    fi
    sleep 0.5
done

while true; do
    if ! sudo $ENGINE ps | grep -q "^exp1b.*running"; then
        T2_END=$(date +%s%N)
        break
    fi
    sleep 0.5
done

T1_MS=$(( (T1_END - T1_START) / 1000000 ))
T2_MS=$(( (T2_END - T2_START) / 1000000 ))

echo ""
echo "Results - Experiment 1:"
echo "  exp1a (nice 0): completed in ${T1_MS} ms"
echo "  exp1b (nice 10): completed in ${T2_MS} ms"

echo "============================================"
echo "EXPERIMENT 2: CPU-bound vs I/O-bound"
echo "============================================"

rm -rf rootfs-exp2a rootfs-exp2b
cp -a rootfs-base rootfs-exp2a
cp -a rootfs-base rootfs-exp2b
cp cpu_hog rootfs-exp2a/
cp io_pulse rootfs-exp2b/
chmod +x rootfs-exp2a/cpu_hog rootfs-exp2b/io_pulse

echo "[Exp2] Starting containers..."

CPU_START=$(date +%s%N)
sudo $ENGINE start exp2a ./rootfs-exp2a /cpu_hog

IO_START=$(date +%s%N)
sudo $ENGINE start exp2b ./rootfs-exp2b /io_pulse

while true; do
    if ! sudo $ENGINE ps | grep -q "^exp2a.*running"; then
        CPU_END=$(date +%s%N)
        break
    fi
    sleep 0.5
done

while true; do
    if ! sudo $ENGINE ps | grep -q "^exp2b.*running"; then
        IO_END=$(date +%s%N)
        break
    fi
    sleep 0.5
done

CPU_MS=$(( (CPU_END - CPU_START) / 1000000 ))
IO_MS=$(( (IO_END - IO_START) / 1000000 ))

echo ""
echo "Results - Experiment 2:"
echo "  exp2a (cpu_hog): completed in ${CPU_MS} ms"
echo "  exp2b (io_pulse): completed in ${IO_MS} ms"

echo "============================================"
echo "Done. Check logs/ for per-container output."
echo "============================================"