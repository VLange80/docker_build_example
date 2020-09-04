#! /bin/bash
packer build packer.build.json
docker build -f Dockerfile.single -t demo:dockerfile.single .
docker build -f Dockerfile.multi -t demo:dockerfile.multi .
cd demo
./mvnw package verify
cd ..
docker build -f Dockerfile.prebuild -t demo:dockerfile.prebuild .
packer build packer.prebuild.json
cd demo
./mvnw clean
cd ..
docker images
