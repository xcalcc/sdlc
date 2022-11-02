pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    environment {
      branch = "$FILE_SERVICE_BRANCH_NAME"
      version = "$VERSION"
      registry = "$REGISTRY"
      image_name = "$IMAGE_NAME"
      NOTIFY_EMAILS = "$NOTIFY_EMAILS"
    }

    stages {
        stage('trace') {
           steps {
            sh "echo $PWD && ls -alF"
           }
        }
        stage('build image') {
            steps {
              echo 'Building image..'
              sh "echo $PWD && ls -alF"
              dir('modules/file-service') {
                sh "bash InHouseBuild.sh $image_name $version $branch"
              }
            }
        }
        stage('push') {
            steps {
                echo 'Pushing....'
                withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                  sh """
                  docker login -u $user -p $password $registry
                  docker push $image_name:$VERSION
                  """
               }

            }
        }
        stage('versys') {
            steps {
                echo 'Register in version control system....'
                sh """
                curl -X POST -F 'commitid=$VERSION' -F 'module=fileservice' http://127.0.0.1:6200/new
                """
            }
        }
    }
    
    post ('Email notification') {
        success {
            echo "Image building success for file service, sending email to $NOTIFY_EMAILS"
            notifyBuild('SUCCESS')
        }
        failure {
            echo "Image building failed for file service, sending email to $NOTIFY_EMAILS"
            notifyBuild('FAILED')
        }
    }
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  def notifyEmails = "$NOTIFY_EMAILS"
  if (notifyEmails) {
    buildStatus = buildStatus ?: 'SUCCESS'
    attachLogs = buildStatus == 'SUCCESS' ? false: true

    // Default values
    def subject = "${buildStatus}: Job '${AGENT} - ${env.JOB_NAME} [${env.BUILD_NUMBER}] '"
    def details = '${SCRIPT, template="groovy-html.template"}'

    emailext (
        subject: subject,
        body: details,
        attachLog: attachLogs,
        mimeType: 'text/html',
        compressLog: true,
        from: 'Jenkins',
        to: notifyEmails
    )
  } else {
    echo "No NOTIFY_EMAILS specified, skip sending email notifiactions..."
  }
}
