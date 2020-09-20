#! /bin/bash
# ts=$(date +%s%N) ; my_command ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "Time taken: $tt milliseconds"
echo "|---------------- Cleaning out Maven Repository ----|"
rm -rf ~/.m2/repository
echo "|---------------- Downloading Base Images ----------|"
docker pull openjdk:11.0.8-jdk
echo "|---------------- Running Speed Tests! -------------|"
ts=$(date +%s%N) ; packer build packer.demo.build.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "packer.demo.build took: $tt milliseconds" > docs/speedtest
docker rmi demo:packer.demo.build
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.single -t demo:dockerfile.demo.single . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.demo.single took: $tt milliseconds" >> docs/speedtest
docker rmi demo:dockerfile.demo.single
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.multi -t demo:dockerfile.demo.multi . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.demo.multi took: $tt milliseconds" >> docs/speedtest
docker rmi demo:dockerfile.demo.multi
cd demo
ts=$(date +%s%N) ; ./mvnw -f spotify.xml package ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "demo.maven.spotify took: $tt milliseconds" >> ../docs/speedtest
docker rmi demo:demo.maven.spotify
./mvnw clean
echo "|----prebuild----|"
ts=$(date +%s%N) ; ./mvnw package verify ; tt=$((($(date +%s%N) - $ts)/1000000)) ; export PREBUILD=$tt ;echo "prebuild took: $tt milliseconds" >> ../docs/speedtest
cd ..
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.prebuild -t demo:dockerfile.demo.prebuild . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; c=$((tt+PREBUILD)); echo "dockerfile.demo.prebuild took: $tt + $PREBUILD = $c milliseconds" >> docs/speedtest
docker rmi demo:dockerfile.demo.prebuild
ts=$(date +%s%N) ; packer build packer.demo.prebuild.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; c=$((tt+PREBUILD)) ; echo "packer.demo.prebuild took: $tt + $PREBUILD = $c milliseconds" >> docs/speedtest
docker rmi demo:packer.demo.prebuild
cd demo
./mvnw clean
cd ..
echo "|-------------- Running Size Tests! ---------------|"
ts=$(date +%s%N) ; packer build packer.demo.build.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "packer.demo.build took: $tt milliseconds"
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.single -t demo:dockerfile.demo.single . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.demo.single took: $tt milliseconds"
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.multi -t demo:dockerfile.demo.multi . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.demo.multi took: $tt milliseconds"
cd demo
ts=$(date +%s%N) ; ./mvnw -f spotify.xml package clean ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "demo.maven.spotify took: $tt milliseconds"
ts=$(date +%s%N) ; ./mvnw package verify ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "prebuild took: $tt milliseconds"
cd ..
ts=$(date +%s%N) ; docker build -f Dockerfile.demo.prebuild -t demo:dockerfile.demo.prebuild . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.demo.prebuild took: $tt milliseconds"
ts=$(date +%s%N) ; packer build packer.demo.prebuild.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "packer.demo.prebuild took: $tt milliseconds"
cd demo
./mvnw clean
cd ..
docker images
