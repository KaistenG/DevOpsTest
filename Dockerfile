(venv) PS C:\Users\49160\IdeaProjects\DevOpsTest> docker-compose down
yaml: unmarshal errors:
  line 3: cannot unmarshal !!str `FROM je...` into cli.named
# Jenkins-Dockerfile
# Nutze das offizielle Jenkins LTS-Image als Basis.
FROM jenkins/jenkins:lts

# Wechsel zu Root, um System-Pakete zu installieren und die Docker-Gruppe anzupassen.
USER root

# Hier passen wir die Docker-Gruppe an.
# Finde die GID der Docker-Gruppe auf deiner Host-Maschine (z.B. mit 'grep docker /etc/group').
# Diese GID muss der GID der Docker-Gruppe im Container entsprechen.
RUN groupadd -g 197615 docker || true \
    && usermod -aG docker jenkins

# Installiere notwendige Pakete für Docker und Kubectl.
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    docker.io

# Lade und installiere Kubectl.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Wechsel zurück zum Jenkins-Benutzer.
USER jenkins
