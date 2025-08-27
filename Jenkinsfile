// Jenkinsfile für eine robuste CI/CD-Pipeline mit Master/Agent-Architektur
pipeline {
    // Definiert, dass die Pipeline auf einem Jenkins-Agenten läuft.
    agent {
        // Verbindet die Pipeline mit dem von uns erstellten dedizierten Agenten.
        label 'jenkins-agent'
    }

    // Definiert die Umgebungsvariablen für die Pipeline.
    environment {
        // Holt die Build-Nummer für das Tagging des Docker-Images.
        IMAGE_TAG = "${BUILD_NUMBER}"
        // Definiert den vollständigen Docker-Image-Namen.
        DOCKER_IMAGE = "kaisteng/devops-test-app:${IMAGE_TAG}"
    }

    // Definiert die Phasen (Stages) der Pipeline.
    stages {
        // Phase 1: Docker-Image bauen
        stage('Build Docker Image') {
            steps {
                echo "Baue das Docker-Image mit dem Tag: ${env.IMAGE_TAG}..."
                // Führt den Docker-Build-Befehl aus.
                // Verwendet die Dockerfile.app im aktuellen Verzeichnis.
                sh "docker build -f Dockerfile.app -t ${env.DOCKER_IMAGE} ."
            }
        }

        // Phase 2: Docker-Image zu Docker Hub pushen
        stage('Push Docker Image') {
            steps {
                echo "Pushe das Docker-Image zu Docker Hub..."
                // Verwendet die Anmeldedaten mit der ID "docker-hub-credentials".
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    // Meldet sich mit den gespeicherten Anmeldedaten bei Docker Hub an.
                    sh "echo \"$DOCKER_PASSWORD\" | docker login -u \"$DOCKER_USERNAME\" --password-stdin"
                    // Pusht das frisch gebaute Image.
                    sh "docker push ${env.DOCKER_IMAGE}"
                }
            }
        }

        // Phase 3: Deployment auf Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploye auf Kubernetes..."
                // Aktualisiert das Image in deinem Kubernetes-Deployment.
                // `kubectl` ist auf dem Agenten verfügbar und greift auf die gemountete Konfiguration zu.
                sh "kubectl set image deployment/devops-test-deployment devops-test-container=${env.DOCKER_IMAGE}"
            }
        }
    }

    // Post-Actions, die nach Abschluss der Pipeline ausgeführt werden.
    post {
        // Wird ausgeführt, wenn die Pipeline erfolgreich war.
        success {
            echo "✅ Pipeline erfolgreich!"
        }
        // Wird ausgeführt, wenn die Pipeline fehlgeschlagen ist.
        failure {
            echo "❌ Pipeline fehlgeschlagen!"
        }
    }
}
