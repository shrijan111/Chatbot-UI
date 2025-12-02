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
                npm set fetch-retries 5
                npm set fetch-retry-mintimeout 20000
                npm set fetch-retry-maxtimeout 120000
                rm -rf node_modules package-lock.json
                sh 'npm install --legacy-peer-deps'
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
