## Testing Different Container Image Build Methods  
  
  This test is performed on native linux, WSL2 with docker-desktop, or mac

#### Pre-Requirements:  
Docker: [Get Started with Docker](https://www.docker.com/get-started)  
Packer: [Installing Packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install)  
  
#### Running the test:
I have provided a bash script designed to take care of building all 4 images and outputting the details of size with the ```docker image``` command.
```bash
$: chmod 700 demo.build.sh flask_demo.build.sh
$: ./demo.build.sh  
$: ./flask_demo.build.sh
```  
