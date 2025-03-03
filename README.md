# targeted-metagenomics
End-to-end targeted (16S) metagenomics pipeline

## Installation Guide

Install the necessary Docker images by running the ff. code:

```bash
docker build --file assets/python.Dockerfile --tag MicroOceLab/python:1.0 .
```

Create the necessary input and output directories:

```bash
./install.sh
```