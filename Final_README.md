# Multi-Container Runtime

---

## Team Information

| Name | SRN |
|------|-----|
| Nayan Niranjana Kaushik | PES1UG24CS294 |
| Nihar Sureshwar Oak | PES1UG25CS299 |

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

