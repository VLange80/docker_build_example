#! /bin/bash
# ts=$(date +%s%N) ; my_command ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "Time taken: $tt milliseconds"
cd flask_demo
echo "|---------------- Running Speed Tests! -------------|"
ts=$(date +%s%N) ; docker build -t flask_demo:dockerfile.ubuntu -f Dockerfile.flask_demo.ubuntu . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.ubuntu took: $tt milliseconds" >> ../speedtest
docker rmi flask_demo:dockerfile.ubuntu
ts=$(date +%s%N) ; docker build -t flask_demo:dockerfile.python -f Dockerfile.flask_demo.python . ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "dockerfile.python took: $tt milliseconds" >> ../speedtest
docker rmi flask_demo:dockerfile.python
ts=$(date +%s%N) ; packer build python.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "packer.python took: $tt milliseconds" >> ../speedtest
docker rmi flask_demo:packer.python
ts=$(date +%s%N) ; packer build ubuntu.json ; tt=$((($(date +%s%N) - $ts)/1000000)) ; echo "packer.ubuntu took: $tt milliseconds" >> ../speedtest
docker rmi flask_demo:packer.ubuntu
cd ..
cd flask_demo
echo "|---------------- Running Size Tests! -------------|"
docker build -t flask_demo:dockerfile.ubuntu -f Dockerfile.flask_demo.ubuntu .
docker build -t flask_demo:dockerfile.python -f Dockerfile.flask_demo.python .
packer build python.json
packer build ubuntu.json
cd ..
docker images