# A test of building the same app into containers 4 ways  

I decided to see what the resulting image size for several methods of building the same java image (in this case a demo java app) were.  

Here are the resuling size:

| Method | Resulted Size | Added to Base | - Size of Jar | = Total Layer added |
| --- | --- | --- | --- | --- |
| base image | 627MB | - | - | - |
| dockerfile.demo.single | 736MB | 109MB | 17MB | 102MB |
| packer.demo.build | 718MB | 91MB | 17MB | 74MB |
| dockerfile.demo.multi | 645MB | 18MB | 17MB | 1MB |
| dockerfile.demo.prebuild | 645MB | 18MB | 17MB | 1MB |
| packer.demo.prebuild | 645MB | 18MB | 17MB | 1MB |

The layers for each:

dockerfile.demo.single:

| Layer | Command | SIZE |
| --- | --- | --- |
| f059b56620bc |  ENTRYPOINT ["java" "-jar"…  | 0B |
| e41a83f92361 |  VOLUME [/tmp] | 0B |
| 2aa068673e6b | WORKDIR /app | 0B |
| 85541b1a1325 | rm -rf /workspace/app | 0B |
| 05d3a8954a30 | cp -r target/restservice-0.0.1-SN… | 17.7MB |
| 15067c23e548 | mkdir -p /app | 0B |
| 181f1d68525f | ./mvnw package verify | 90.5MB |
| a511aabb16c2 | COPY dir:d642341a3926b5dea… | 3.2kB |
| d98bf234f58a | COPY file:952070ce0d79b50d… | 1.4kB |
| cf6378b9efa7 | COPY dir:20e83aadf99c4d107… | 55.9kB |
| 05d4425ffb07 | COPY file:61803a078a81d61d… | 10.1kB |
| ec03949916a6 | WORKDIR /workspace/app | 0B |

packer.demo.build:

| Layer | Command | SIZE |
| --- | --- | --- |
| 8a6cffefd553 | | 90.5MB |

dockerfile.demo.multi:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 9e704c46e232 | ENTRYPOINT ["java" "-jar"… | 0B |
| df0194c67082 | COPY file:67d1c9b0af867f35… | 17.7MB |
| 33b90871b563 | ARG DEPENDENCY=/workspace… | 0B |
| 812251c5bc83 | VOLUME [/tmp] | 0B |

dockerfile.demo.prebuild:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 758c98cdb525 | ENTRYPOINT ["java" "-jar"… | 0B |
| 41e9939f68fe | VOLUME [/tmp] | 0B |
| ee9879c307d3 | WORKDIR /app | 0B |
| aee2644911fe | COPY file:6801256a937fba1b… | 17.7MB |
| 5a7848f3921a | mkdir -p /app | 0B |


packer.demo.prebuild:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 0a2b05de8e04 |  | 17.7MB |

Looking at the results, It seems that even if you have a line in your Cotainer Definition file, be it Dockerfile or packer, there is still a leftover layer that increases the overall size of your image. This leftover layer contains all the data and instructions that occured in it that is part of the ```docker history``` protocol and allows you to roll back to a previous setp in the Docker setup.  

Next up I will perform this with a Python/Flask application since it requires libraries as well in the image.
  
[Back to Blog](https://madmages.com)