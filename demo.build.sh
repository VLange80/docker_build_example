#! /bin/bash
packer build packer.demo.build.json
docker build -f Dockerfile.demo.single -t demo:dockerfile.single .
docker build -f Dockerfile.demo.multi -t demo:dockerfile.multi .
cd demo
./mvnw package verify
cd ..
docker build -f Dockerfile.demo.prebuild -t demo:dockerfile.prebuild .
packer build packer.demo.prebuild.json
cd demo
./mvnw clean
cd ..
docker images
