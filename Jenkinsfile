// Pipeline-Skript für die DevOps-CI/CD-Pipeline
pipeline {
    // Pipeline-Agent: Hier läuft das Build auf einem Docker-Agenten.
    agent any

    // Umgebungsvariablen, die in der gesamten Pipeline genutzt werden können.
    environment {
        // Der Name deines Docker-Images auf Docker Hub.
        IMAGE_NAME = "kaisteng/devops-test-app"
        // Der Tag wird dynamisch basierend auf der Build-Nummer vergeben.
        IMAGE_TAG = "${env.BUILD_ID}"
        // Hier kommunizieren wir mit dem Docker-Daemon über TCP.
        // host.docker.internal ist der Host-Rechner aus der Sicht des Containers.
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
    }

    // Die verschiedenen Phasen (Stages) deiner Pipeline.
    stages {
        // Stage 1: Build des Docker-Images
        stage('Build Docker Image') {
            steps {
                echo "Baue das Docker-Image mit dem Tag: ${env.IMAGE_TAG}..."
                // Befehl zum Bauen des Images.
                // Verwende das umbenannte Dockerfile.app, um die Anwendung zu bauen.
                sh "docker build -f Dockerfile.app -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        // Stage 2: Authentifizierung und Push des Images zu Docker Hub
        stage('Push Docker Image') {
            steps {
                echo "Pushe das Docker-Image zu Docker Hub..."
                // Dieser Block stellt sicher, dass die Authentifizierungsdaten (Credentials)
                // sicher aus Jenkins geladen werden, ohne sie im Skript zu hinterlegen.
                // Ersetze 'docker-hub-credentials' mit der ID, die du in Jenkins vergibst.
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]) {
                    // Login bei Docker Hub
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USER} --password-stdin"
                    // Push des Images
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        // Stage 3: Deployment auf Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploye auf Kubernetes..."
                // Ändere das Image im Deployment-Manifest, um das neue Image zu verwenden
                // Oder du machst es einfacher und nutzt `kubectl set image`.
                sh "kubectl set image deployment/devops-test-deployment devops-test-container=${IMAGE_NAME}:${IMAGE_TAG}"

                // Überprüfe, ob das Deployment erfolgreich ist.
                sh "kubectl rollout status deployment/devops-test-deployment"

                // Apply des HPA, falls sich die Konfiguration geändert hat.
                // Du könntest dies auch in einem separaten Schritt machen.
                sh "kubectl apply -f k8s-hpa.yaml"
            }
        }
    }

    // Post-Build-Aktionen, die immer nach Abschluss der Stages ausgeführt werden.
    post {
        // Wird ausgeführt, wenn die Pipeline erfolgreich war.
        success {
            echo "✅ Pipeline erfolgreich durchgelaufen!"
            echo "App ist unter der neuen Version ${env.IMAGE_TAG} deployed."
        }
        // Wird ausgeführt, wenn die Pipeline fehlgeschlagen ist.
        failure {
            echo "❌ Pipeline fehlgeschlagen!"
        }
    }
}
