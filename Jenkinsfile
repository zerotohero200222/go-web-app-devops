pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS_ID = 'github-creds'  // Set the credentials ID you used in Jenkins
        GITHUB_REPO = 'https://github.com/Rajaram08950/go-web-app-devops'
        DOCKER_IMAGE_TAG = "build-${env.BUILD_ID}"  // Unique tag based on Jenkins build ID
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: env.GITHUB_CREDENTIALS_ID, url: env.GITHUB_REPO
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image and push to DockerHub or another registry
                    docker.build("rajaram8888/go-web-app:${DOCKER_IMAGE_TAG}").push()
                }
            }
        }

        stage('Update Helm Chart') {
            steps {
                script {
                    // Update Helm chart's tag in values.yaml
                    sh "sed -i 's/tag: .*/tag: \"${DOCKER_IMAGE_TAG}\"/' helm/go-web-app-chart/values.yaml"
                }
            }
        }

        stage('Commit Changes') {
            steps {
                script {
                    // Commit the updated Helm chart back to GitHub
                    sh """
                    git config user.email "rajaram.m2254@gmail.com"
                    git config user.name "Rajaram08950"
                    git add helm/go-web-app-chart/values.yaml
                    git commit -m "Update Helm chart tag to ${DOCKER_IMAGE_TAG}"
                    git push origin main
                    """
                }
            }
        }
    }
}
