# A test of building the same app into containers 4 ways  

I decided to see what the resulting image size for several methods of building the same image (in this case a demo java app) were.  

Here are the resuling size:

| Method | Resulted Size | Added to Base |
| --- | --- | --- |
| base image | 627MB | - |
| dockerfile.single | 736MB | 109MB |
| packer | 718MB | 91MB |
| dockerfile.multi | 645MB | 18MB |
| dockerfile.prebuild | 645MB | 18MB |
| packer.prebuild | 645MB | 18MB |

The layers for each:

dockerfile.single:

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

packer:

| Layer | Command | SIZE |
| --- | --- | --- |
| 8a6cffefd553 | | 90.5MB |

dockerfile.multi:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 9e704c46e232 | ENTRYPOINT ["java" "-jar"… | 0B |
| df0194c67082 | COPY file:67d1c9b0af867f35… | 17.7MB |
| 33b90871b563 | ARG DEPENDENCY=/workspace… | 0B |
| 812251c5bc83 | VOLUME [/tmp] | 0B |

dockerfile.prebuild:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 758c98cdb525 | ENTRYPOINT ["java" "-jar"… | 0B |
| 41e9939f68fe | VOLUME [/tmp] | 0B |
| ee9879c307d3 | WORKDIR /app | 0B |
| aee2644911fe | COPY file:6801256a937fba1b… | 17.7MB |
| 5a7848f3921a | mkdir -p /app | 0B |


packer.prebuild:  

| Layer | Command | SIZE |
| --- | --- | --- |
| 0a2b05de8e04 |  | 17.7MB |

Looking at the results, It seems that even if you have a line in your Cotainer Definition file, be it Dockerfile or packer, there is still a leftover layer that increases the overall size of your image.  
  
[Back to Blog](https://madmages.com)