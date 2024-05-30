pipeline {
    agent any

    environment {
        DOCKER_USERNAME = credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
        PORT = credentials('PORT')
        TESTENV = credentials('TESTENV')
        SSH_HOST_DNS = credentials('SSH_HOST_DNS')
        USERNAME = credentials('USERNAME')
        EC2_SSH_KEY = credentials('EC2_SSH_KEY')
    }

    stages {
        stage('Checkout source') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/your-project.git'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                }
            }
        }

        stage('Build and tag Docker image') {
            steps {
                script {
                    def commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    sh """
                        docker build -t ${DOCKER_USERNAME}/nodejs-app:latest -t ${DOCKER_USERNAME}/nodejs-app:${commitId} .
                    """
                }
            }
        }

        stage('Push Docker images') {
            steps {
                script {
                    def commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    sh """
                        docker push ${DOCKER_USERNAME}/nodejs-app:latest
                        docker push ${DOCKER_USERNAME}/nodejs-app:${commitId}
                    """
                }
            }
        }

        stage('Create environment file') {
            steps {
                sh """
                    echo "NODE_ENV=development" > .env
                    echo "PORT=${PORT}" >> .env
                    echo "TESTENV=${TESTENV}" >> .env
                    echo "DOCKER_USERNAME=${DOCKER_USERNAME}" >> .env
                """
            }
        }

        stage('Copy environment file to server') {
            steps {
                sshagent(['EC2_SSH_KEY']) {
                    sh """
                        scp -o StrictHostKeyChecking=no .env ${USERNAME}@${SSH_HOST_DNS}:~/dockerComposeFiles/
                    """
                }
            }
        }

        stage('Copy docker-compose-uat.yml to server') {
            steps {
                sshagent(['EC2_SSH_KEY']) {
                    sh """
                        scp -o StrictHostKeyChecking=no docker-compose-uat.yml ${USERNAME}@${SSH_HOST_DNS}:~/dockerComposeFiles/
                    """
                }
            }
        }

        stage('Deploy application') {
            steps {
                sshagent(['EC2_SSH_KEY']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${USERNAME}@${SSH_HOST_DNS} << EOF
                            docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                            docker pull ${DOCKER_USERNAME}/nodejs-app:latest
                            docker rm -f nodejs-app-container || true
                            cd ~/dockerComposeFiles
                            set -a
                            source ./.env
                            docker-compose -f docker-compose-uat.yml up -d --scale web=3
                        EOF
                    """
                }
            }
        }
    }
}
