// Definiert die Pipeline, die in Jenkins ausgeführt wird.
pipeline {
    // "agent any" bedeutet, dass die Pipeline auf jedem verfügbaren Agenten laufen kann.
    agent any

    // Die Stages definieren die Schritte der Pipeline.
    stages {
        // Stage 1: Build - Baut das Docker-Image.
        stage('Build') {
            steps {
                script {
                    // Definiert den Image-Namen und das Tag.
                    // (Wir verwenden die Build-Nummer von Jenkins für ein einzigartiges Tag)
                    def imageName = "kaisteng/devops-test-app:${env.BUILD_NUMBER}"

                    // Führe den Docker Build-Befehl aus.
                    echo "Building Docker image ${imageName}..."
                    // 'docker.build' ist ein Jenkins-spezifischer Befehl.
                    docker.build(imageName)

                    // Pusht das Image in die Docker Registry (z.B. Docker Hub).
                    // Beachte: Du musst zuvor in Jenkins die Docker Hub-Anmeldedaten
                    // in den "Credentials" hinterlegen.
                    echo "Pushing Docker image ${imageName}..."
                    docker.image(imageName).push()
                }
            }
        }

        // Stage 2: Test - Ein einfacher Platzhalter für deine Lasttests.
        // Die Integration von Locust ist etwas komplexer und kann später hinzugefügt werden.
        stage('Test') {
            steps {
                echo "Running tests (placeholder for now)..."
                // Hier würden die Locust-Tests ausgeführt werden, z.B.:
                // sh "docker run --rm locustio/locust -f locustfile.py -H http://localhost:80"
            }
        }

        // Stage 3: Deploy - Bereitstellung in Kubernetes.
        stage('Deploy') {
            steps {
                script {
                    // Verwende kubectl, um das Deployment in Kubernetes zu aktualisieren.
                    echo "Applying Kubernetes manifests..."
                    // Stellt sicher, dass kubectl in Jenkins installiert und konfiguriert ist.
                    // Kubernetes holt dann das neue Image mit dem Build-Nummer-Tag.
                    sh 'kubectl apply -f k8s-deployment.file -f k8s-hpa.yaml'
                }
            }
        }
    }
}
