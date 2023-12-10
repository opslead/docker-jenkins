# Jenkins Container Image

[![Docker Stars](https://img.shields.io/docker/stars/opslead/jenkins.svg?style=flat-square)](https://hub.docker.com/r/opslead/jenkins) 
[![Docker Pulls](https://img.shields.io/docker/pulls/opslead/jenkins.svg?style=flat-square)](https://hub.docker.com/r/opslead/jenkins)

#### Docker Images

- [GitHub actions builds](https://github.com/opslead/docker-jenkins/actions) 
- [Docker Hub](https://hub.docker.com/r/opslead/jenkins)


#### Environment Variables

When you start the Jenkins image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. The following environment values are provided to custommize Jenkins:

| Variable                  | Default Value | Description                     |
| ------------------------- | ------------- | ------------------------------- |
| `JAVA_ARGS`               |               | Configure JVM params            |

#### Persisting Jenkins data

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/opt/jenkins/data` path. The above examples define a docker volume namely `jenkins_data`. The Jenkins application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

#### Run the Service

```bash
docker service create --name jenkins \
  -p 8081:8081 \
  -p 50000:50000 \
  -e JAVA_ARGS="-Xms2G -Xmx6G" \
  --mount type=bind,source=/data/jenkins,destination=/opt/jenkins/data \
  opslead/jenkins:latest
```

When running Docker Engine in swarm mode, you can use `docker stack deploy` to deploy a complete application stack to the swarm. The deploy command accepts a stack description in the form of a Compose file.

```bash
docker stack deploy -c jenkins-stack.yml jenkins
```

Compose file example:
```
version: "3.8"
services:
  jenkins:
    image: opslead/jenkins:latest
    ports:
      - 8080:8080
      - 50000:50000
     volumes:
      - jenkins_data:/opt/jenkins/data
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      environment:
        - JAVA_ARGS=-Xms2G -Xmx6G

volumes:
  jenkins_data:
    driver: local
    driver_opts:
      type: "none"
      o: "bind"
      device: "/data/jenkins"
```


# Contributing
We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/opslead/docker-jenkins/issues), or submit a [pull request](https://github.com/opslead/docker-jenkins/pulls) with your contribution.

# Issues
If you encountered a problem running this container, you can file an [issue](https://github.com/opslead/docker-jenkins/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version
- Output of docker info
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
