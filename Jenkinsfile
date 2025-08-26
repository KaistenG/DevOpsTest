pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kaisteng/devops-test-app"
        IMAGE_TAG = "latest"
        DEPLOYMENT_NAME = "devops-test-deployment"
        CONTAINER_NAME = "devops-test-container"
        K8S_NAMESPACE = "default"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/KaistenG/DevOpsTest.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('','') { // leer, da Docker Desktop lokal läuft
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=${DOCKER_IMAGE}:${IMAGE_TAG} -n ${K8S_NAMESPACE}
                    kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${K8S_NAMESPACE}
                    """
                }
            }
        }
    }
}