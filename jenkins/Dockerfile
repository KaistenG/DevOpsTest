# Jenkins-Dockerfile
# Nutze das offizielle Jenkins LTS-Image als Basis.
FROM jenkins/jenkins:lts

# Wechsel zum Root-Benutzer, um die Docker-CLI und Git zu installieren.
USER root

# Installiere Git, die Docker-CLI und Kubectl.
RUN apt-get update && apt-get install -y git docker.io \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Füge den Jenkins-Benutzer zur Docker-Gruppe hinzu, um Docker-Befehle ausführen zu können.
RUN usermod -aG docker jenkins

# Setze die Docker-CLI so auf, dass sie auf das Docker-Daemon zugreift.
ENV DOCKER_HOST=tcp://docker:2376

# Setze die Docker-Umgebungsvariablen.
ENV DOCKER_CERT_PATH=/certs/client
ENV DOCKER_TLS_VERIFY=1

# Wechsle zurück zum Jenkins-Benutzer.
USER jenkins
