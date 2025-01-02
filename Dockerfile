FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# Set environment variable for non-interactive apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y wget bzip2 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && bash /tmp/miniconda.sh -b -p /opt/miniconda && rm /tmp/miniconda.sh

ENV PATH=/opt/miniconda/bin:$PATH

RUN apt-get update && apt-get install -y sudo \
    python3 \
    python3-pip \
    build-essential \
    gcc \
    g++ \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev \
    rsync

WORKDIR /