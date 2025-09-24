pipeline {
    agent { label 'sample-agent' }

    environment {
        APP_NAME   = 'sample-app'
        DOCKERHUB  = 'krishnamonani'
        BRANCH_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB}/${APP_NAME}:${BRANCH_TAG}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                withCredentials([string(credentialsId: 'github-pat', variable: 'GITHUB_PAT')]) {
                    git branch: "dev",
                        url: "https://${GITHUB_PAT}@github.com/krishnamonani/t15-app.git"
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo 'Running tests inside Docker container...'
                sh 'docker compose -f docker-compose.test.yml up --build --abort-on-container-exit'
            }
        }
    }
}
