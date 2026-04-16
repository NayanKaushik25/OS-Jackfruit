# Multi-Container Runtime

---

## Team Information

| Name | SRN |
|------|-----|
| Nayan Niranjana Kaushik | PES1UG24CS294 |
| Nihar Sureshwar Oak | PES1UG24CS299 |

---

## Project Summary

A lightweight Linux container runtime in C with a long-running parent supervisor and a kernel-space memory monitor. The runtime manages multiple containers concurrently, coordinates logging safely through a bounded-buffer pipeline, exposes a CLI, enforces memory limits via a kernel module, and includes controlled scheduling experiments.

---

## Build, Load, and Run Instructions

### 1. Install Dependencies

```bash
sudo apt update
sudo apt install -y build-essential linux-headers-$(uname -r)
```

### 2. Build

```bash
cd boilerplate
make
```

### 3. Prepare Root Filesystem

```bash
mkdir rootfs-base
wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-minirootfs-3.20.3-x86_64.tar.gz
tar -xzf alpine-minirootfs-3.20.3-x86_64.tar.gz -C rootfs-base
cp -a rootfs-base rootfs-alpha
cp -a rootfs-base rootfs-beta
cp cpu_hog memory_hog rootfs-alpha/
cp cpu_hog io_pulse rootfs-beta/
```

### 4. Load Kernel Module

```bash
sudo insmod monitor.ko
ls -l /dev/container_monitor
dmesg | tail -5
```

### 5. Start Supervisor (Terminal 1)

```bash
sudo ./engine supervisor ./rootfs-base
```

### 6. Use the CLI (Terminal 2)

```bash
# Launch containers
sudo ./engine start alpha ./rootfs-alpha "/memory_hog"
sudo ./engine start beta  ./rootfs-beta  "/memory_hog"

# List containers
sudo ./engine ps

# View logs
sudo ./engine logs alpha

# Stop a container
sudo ./engine stop alpha

# Run and wait for exit
sudo ./engine run alpha ./rootfs-alpha "/memory_hog"
```


## Demo Screenshots



<img width="645" height="96" alt="image" src="https://github.com/user-attachments/assets/fd15c51c-bb14-47a2-82a2-7726a238099a" />  <img width="642" height="157" alt="image" src="https://github.com/user-attachments/assets/7a8f191f-a098-4338-83d9-adbb7c51ddb5" />

