pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Install Plugins') {
            steps {
                // Install Terraform and Ansible plugins
                script {
                    def plugins = ['terraform', 'ansible']
                    plugins.each {
                        plugin -> 
                            if (!jenkins.model.Jenkins.instance.getPluginManager().getPlugin(plugin)) {
                                println "Installing ${plugin} plugin..."
                                jenkins.model.Jenkins.instance.getPluginManager().installPlugin(plugin)
                            }
                    }
                }

                // Restart Jenkins to apply plugin changes
                script {
                    println "Restarting Jenkins..."
                    jenkins.model.Jenkins.instance.safeRestart()
                }
                // Wait for Jenkins to restart
                sleep 60
            }
        }

        stage('Set AWS Credentials') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY'
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the code from your version control system (e.g., Git)
                git 'https://github.com/ismail116/Jenkins-terraform.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Run Terraform to provision EC2 instances
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        // stage('Ansible Playbook Execution') {
        //     steps {
        //         // Run Ansible playbook to install and configure Nginx
        //         sh 'ansible-playbook -i inventory playbook.yml'
        //     }
        // }

        stage('Post-Deployment Checks') {
            steps {
                // Perform any post-deployment tests or checks
                // This step is optional and can be customized based on your requirements
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
