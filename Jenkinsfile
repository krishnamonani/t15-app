pipeline {
    agent { label 'stage-agent' }

    environment {
        GITHUB_CREDENTIALS = credentials('github-pat')
    }

    stages {
        stage('Down Previous Build') {
            when {
                branch 'stage'
            }
            steps {
                echo "!!!THIS IS STAGING BRANCH!!!"
                echo 'Stopping previous build'
                sh 'docker compose down || true'
                echo 'Previous build stopped.'
            }
        }
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub repository...'
                git url: 'https://github.com/krishnamonani/t15-app.git', branch: 'stage', credentialsId: 'github-pat'
                echo 'Code checkout completed.'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the application'
                sh 'whoami'
                echo 'Build new image'
                sh 'docker compose build --no-cache'
                echo 'up new containers'
                sh 'docker compose up -d'
                echo 'Application started.'
            }
        }
        stage('Cleanup') {
            steps {
                echo 'Cleaning up unused Docker resources...'
                sh 'docker system prune -af'
                echo 'Cleanup completed.'
            }
        }
        stage('Smoke test') {
            steps {
                echo 'Running smoke tests...'
                sh 'curl -f http://localhost:5000 || exit 1'
                echo 'Smoke tests passed.'
            }
        }
    }
}
