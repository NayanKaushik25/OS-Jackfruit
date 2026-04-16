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

### Screenshot 1 - Multi-container supervision

<img width="1305" height="135" alt="image" src="https://github.com/user-attachments/assets/0d972c07-628f-4208-84fd-b67f09ad96ba" />



### Screenshot 2 - Metadata tracking

<img width="1310" height="134" alt="image" src="https://github.com/user-attachments/assets/bf3bdd9e-53e6-4b59-a8d0-f3321475514c" />


### Screenshot 3 - Bounder buffer logging

<img width="1045" height="229" alt="image" src="https://github.com/user-attachments/assets/bde4b1e5-7d67-46df-bd52-d2132ad4e7a5" />

### Screenshot 4 - CLI and IPC

<img width="777" height="194" alt="image" src="https://github.com/user-attachments/assets/2ceeb0bc-b9a2-4806-830b-7eac29e0d1ac" />
<img width="789" height="228" alt="image" src="https://github.com/user-attachments/assets/8a451d19-feda-4945-9652-cf4fb6029b54" />

### Screenshot 5 - Soft-limit warning

<img width="788" height="95" alt="image" src="https://github.com/user-attachments/assets/1bff008b-1225-4948-b2ba-dc09dfbdd03c" />
<img width="760" height="46" alt="image" src="https://github.com/user-attachments/assets/a4abc5b9-5c3a-40c2-9988-1c4199905025" />

### Screenshot 6 - Hard-limit enforcement

<img width="415" height="46" alt="image" src="https://github.com/user-attachments/assets/fef14086-d9e5-4807-bdf5-ef20739e67c7" />
<img width="1590" height="89" alt="image" src="https://github.com/user-attachments/assets/42d2a784-5687-49dd-9583-0fe36beb21a5" />

### Screenshot 7 - Scheduling Experiments

<img width="1611" height="731" alt="image" src="https://github.com/user-attachments/assets/4504a9d6-b492-41b0-aa96-92a7c885d40f" />

### Screenshot 8 - Clean teardown

<img width="1106" height="54" alt="image" src="https://github.com/user-attachments/assets/99211831-b346-4682-bfdc-f808066f6ef7" />



