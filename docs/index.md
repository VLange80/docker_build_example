# A test of building the same app into containers 4 ways  

I decided to see what the resulting image size for several methods of building the same java image (in this case a demo java app) were.  

Here are the resuling size:

| Method | Resulted Size | Added to Base | - Size of Jar | = Total Layer added | Time to Build |
| --- | --- | --- | --- | --- | --- |
| base image | 627MB | - | - | - | - |
| dockerfile.demo.single | 736MB | 109MB | 17MB | 102MB | 41.692s |
| packer.demo.build | 718MB | 91MB | 17MB | 74MB | 54.691s |
| dockerfile.demo.multi | 645MB | 18MB | 17MB | 1MB | 39.781s |
| dockerfile.demo.prebuild | 645MB | 18MB | 17MB | 1MB | 6.619s |
| packer.demo.prebuild | 645MB | 18MB | 17MB | 1MB | 9.946s |
| demo.maven.spotify | 645MB | 18MB| 17MB | 1MB | 59.813s |

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

demo.maven.spotify:  
  
| Layer | Command | SIZE |
| --- | --- | --- |
| eaaba6b37a75 | ENTRYPOINT ["/usr/bin/jav… | 0B |
| 9f68489f85c5 | ARG JAR_FILE | 0B |
| 2af6f0c76ecc | ADD file:cd8316d66102483ab… | 17.7MB |


Looking at the results, It seems that even if you have a line in your Cotainer Definition file, be it Dockerfile or packer, there is still a leftover layer that increases the overall size of your image. This leftover layer contains all the data and instructions that occured in it that is part of the ```docker history``` protocol and allows you to roll back to a previous setp in the Docker setup.  

Next up I will perform this with a Python/Flask application since it requires libraries as well in the image.
  
| Method | Resulted Size | Added to Base | Time to Build |
| --- | --- | --- | --- |
| python:3.8.5 | 882MB | - | - |
| ubuntu:20.04 | 73.9MB | - |  - |
| dockerfile.ubuntu | 393MB | 319.1MB | 44.786s |
| dockerfile.python | 892MB | 10MB | 4.883s |
| packer.ubuntu | 393MB | 319.1MB | 207.921 |
| packer.python | 892MB | 10MB | 7.921s |

This one is pretty obvious the more complete the base image is, the less time it takes to build the final image. In this case using a larger base image that already has the base libraries and application installed for Python and Pip enables us to build a Docker image with our app running faster. However the Resulting Image can be much larger that if we took the time to build it ourselves. there are tradeoffs.

Overall it is clear that building with Native Dockerfiles is faster than packer, but compiled languages see a reduced overall build time by building them prior to installing the artifacts into the Docker image.

[Back to Blog](https://madmages.com)