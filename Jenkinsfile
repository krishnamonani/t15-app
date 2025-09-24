pipeline {
    agent { label 'prod-agent' }

    environment {
        GITHUB_CREDENTIALS = credentials('github-pat')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub repository..."
                git url: "https://github.com/krishnamonani/t15-app.git", branch: "main", credentialsId: 'github-pat'
                echo "Code checkout completed."
            }
        }
        stage("Build") {
            steps {
                echo "Starting the application..."
                sh "whoami"
                sh "docker compose up -d"
                echo "Application started."
            }
        }
    }
}
