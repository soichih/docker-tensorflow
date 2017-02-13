# docker-tensorflow

Tensorflow Container for IU BigRed 2

> This is an experimental container - only available to IU BigRed II administrators

This container uses nvidia/cuda:7.5-cudnn5-devel-centos7 container with the latest tensorflow installed.  This container relies on following configuration to be able to access various BigRed II mount points.

```
mount home: no
bind /opt/cray/nvidia #for nvidia driver
bind /N/u
bind /N/home
bind /N/soft
bind /N/dc2
```

## Running

1. ssh to tds (with -X if you want to use X window)
2. qsub -I -q gpu (with -X if you want to use X window)
2. module load ccm && ccmlogin
3. singularity shell docker://soichih/tensorflow-bigred2
4. python mytensorflow.py


