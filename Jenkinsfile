pipeline {
    agent { label 'sample-agent' } //dev infra

    environment {
        GITHUB_CREDENTIALS = credentials('github-pat')
    }

    stages {
        stage('Down Previous Build') {
            when {
                branch 'dev'
            }
            steps {
                echo '!!!THIS IS DEV BRANCH!!!'
                echo 'Stopping previous build'
                sh 'docker compose down || true'
                echo 'Previous build stopped.'
            }
        }
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub repository...'
                git url: 'https://github.com/krishnamonani/t15-app.git', branch: 'dev', credentialsId: 'github-pat'
                echo 'Code checkout completed.'
            }
        }
        stage('Run Unit Test') {
            steps {
                echo 'Running unit tests inside a Docker container...'
                sh 'docker-compose -f docker-compose.test.yml up --build --abort-on-container-exit --exit-code-from app'
                echo 'Unit tests completed.'
            }
            post {
                always {
                    sh 'docker system prune -af || true'
                    echo ('Cleaned up Docker resources.')
                }
            }
        }
    }
}
