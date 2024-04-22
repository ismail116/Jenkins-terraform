pipeline {
    agent any
    
    environment {
        PATH = "/var/jenkins_home/bin:$PATH"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY'
                }
            }
        }

        stage('Install Plugins') {
            steps {
                script {
                    // Install Terraform and Ansible plugins
                    def plugins = ['terraform', 'ansible']
                    plugins.each {
                        plugin ->
                            if (!pluginInstalled(plugin)) {
                                println "Installing ${plugin} plugin..."
                                installPlugin(plugin)
                            }
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the code from your version control system (e.g., Git)
                git branch: 'main', url: 'https://github.com/ismail116/Jenkins-terraform.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Make sure Terraform is available in the PATH
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
                sh 'sleep 60'
            }
        }

        stage('Ansible Playbook Execution') {
            steps {
                // Execute Ansible playbook
                sh 'ansible-playbook -i inventory playbook.yml'
            }
        }
    }

    post {
        success {
            // Send success notifications (e.g., Slack, email) if the pipeline succeeds
            echo 'Pipeline succeeded!'
        }
        failure {
            // Send failure notifications (e.g., Slack, email) if the pipeline fails
            echo 'Pipeline failed!'
        }
    }
}

def pluginInstalled(pluginName) {
    def plugins = Jenkins.instance.pluginManager.plugins
    return plugins.any { plugin -> plugin.shortName == pluginName }
}

def installPlugin(pluginName) {
    def pluginManager = Jenkins.instance.pluginManager
    def installJob = pluginManager.installPlugin(pluginName)
    installJob.get()
    pluginManager.restart()
}
