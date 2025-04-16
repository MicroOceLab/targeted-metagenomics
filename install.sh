docker build --file assets/python.Dockerfile --tag MicroOceLab/python:1.0 .
docker build --file assets/r.Dockerfile --tag MicroOceLab/r:1.1 .
docker pull quay.io/biocontainers/fastqc:0.11.7--4
docker pull quay.io/biocontainers/multiqc:1.28--pyhdfd78af_0
docker pull quay.io/qiime2/amplicon:2024.10

mkdir -p data
mkdir -p results

cd ..