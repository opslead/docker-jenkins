FROM azul/zulu-openjdk:11

LABEL maintainer="opslead"
LABEL repository="https://github.com/opslead/docker-jenkins"

WORKDIR /opt/jenkins

ENV JENKINS_USER="jenkins" \
    JENKINS_UID="8983" \
    JENKINS_GROUP="jenkins" \
    JENKINS_GID="8983" \
    JENKINS_DIST_URL="http://mirrors.jenkins.io/war-stable/latest/jenkins.war"

RUN groupadd -r --gid "$JENKINS_GID" "$JENKINS_GROUP"
RUN useradd -r --uid "$JENKINS_UID" --gid "$JENKINS_GID" "$JENKINS_USER" -d /opt/jenkins
RUN mkdir -p /opt/jenkins/data
COPY entrypoint /opt/jenkins
RUN chmod +x /opt/jenkins/entrypoint

RUN apt-get update && apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
        apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin git && \
        curl -f -L $JENKINS_DIST_URL -o /opt/jenkins/jenkins.war && \
        chown -R $JENKINS_USER:$JENKINS_GROUP /opt/jenkins && \
        apt-get -y clean

VOLUME /opt/jenkins/data
USER $JENKINS_USER

ENTRYPOINT ["/opt/jenkins/entrypoint"]
