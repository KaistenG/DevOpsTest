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
    lsb-release

# Füge den Docker GPG-Key hinzu.
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Füge das Docker-Repository hinzu.
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Aktualisiere die Paketliste und installiere Docker.
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Lade und installiere Kubectl.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Wechsel zurück zum Jenkins-Benutzer.
USER jenkins
