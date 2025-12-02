pipeline {
    agent any
    tools {
        nodejs 'node20'
    }
    environment {
        DOCKER_IMAGE = "la000la/chatbot-ui:latest"
        DOCKER_CREDENTIALS = "dockerhub-creds"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'staging', url: 'https://github.com/shrijan111/Chatbot-UI.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh '''
                # Increase npm fetch retries in case of network hiccups
                npm set fetch-retries 5
                npm set fetch-retry-mintimeout 20000
                npm set fetch-retry-maxtimeout 120000
                
                # Optional: clean old node_modules and lock file for a fresh install
                rm -rf node_modules package-lock.json

                # Install dependencies with legacy peer deps
                npm install --legacy-peer-deps
                '''
            }
        }
        stage('Build App') {
            steps {
                sh 'npm run build -- --webpack'
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose up -d'
            }
        }
    }
    post {
        success {
            echo 'Build and Deployment Successful!'
        }
        failure {
            echo 'Build Failed. Check the logs.'
        }
    }
}
