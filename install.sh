docker build --file assets/python.Dockerfile --tag MicroOceLab/python:1.0 .
docker pull quay.io/qiime2/amplicon:2024.10

mkdir -p data
mkdir -p results

cd ..