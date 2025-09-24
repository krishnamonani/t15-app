pipeline {
    agent { label 'prod-agent' }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub repository..."
                git url: "https://github.com/krishnamonani/t15-app.git", branch: "main"
                echo "Code checkout completed."
            }
        }
        stage("Build") {
            steps {
                echo "Starting the application..."
                sh "whomi"
                sh "docker compose up -d"
                echo "Application started."
            }
        }
    }
}
