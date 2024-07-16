pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-nginx-image' // Name for the Docker image
        DOCKER_REGISTRY = 'your-docker-registry' // Your Docker registry URL (optional)
        GIT_REPO_URL = 'https://github.com/your-username/your-repo.git' // Your Git repository URL
        GIT_BRANCH = 'main' // Branch to commit changes to
        GIT_CREDENTIALS_ID = 'your-git-credentials-id' // Jenkins credentials ID for Git
        DOCKER_CREDENTIALS_ID = 'your-docker-credentials-id' // Jenkins credentials ID for Docker registry
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${env.GIT_BRANCH}", url: "${env.GIT_REPO_URL}", credentialsId: "${env.GIT_CREDENTIALS_ID}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}", '.')
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    docker.image("${env.DOCKER_IMAGE}").inside {
                        sh 'nginx -t'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { env.DOCKER_REGISTRY != null && env.DOCKER_REGISTRY != '' }
            }
            steps {
                script {
                    docker.withRegistry("https://${env.DOCKER_REGISTRY}", "${env.DOCKER_CREDENTIALS_ID}") {
                        docker.image("${env.DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    // Pull the latest image
                    sh "docker pull ${env.DOCKER_IMAGE}"

                    // Stop and remove the current container if it's running
                    sh "docker stop my-nginx || true"
                    sh "docker rm my-nginx || true"

                    // Run the new container
                    sh "docker run -d --name my-nginx -p 80:80 ${env.DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
