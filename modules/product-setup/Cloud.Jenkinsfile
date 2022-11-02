pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    environment {
        IMAGE_COMMITID = "$COMMITID"
        IMAGE_VERSION = "$VERSION"
        DOCKER_IMAGE_NAME = "$IMAGE_NAME"
        DOCKER_IMAGE_NAME_REMOTE = "$IMAGE_NAME_HUB"
        DOCKER_REGISTRY = "$REGISTRY"
        MODULE_NAME = "$MODULE_NAME"
        APIURL = "$APIURL"
        NOTIFY_EMAILS = "$NOTIFY_EMAILS"
    }
    
    stages {
        stage('Intial Env') {
            steps {
                echo '========= Intial Env =========='
                script {
                    if (env.APIURL!=null)
                    {
                        echo "API_URL:${APIURL}"
                    } else
                    {
                        APIURL="http://127.0.0.1:6200"
                        echo "API_URL:${APIURL}"
                    }
                    if (env.IMAGE_COMMITID!=null)
                    {
                        echo "${DOCKER_IMAGE_NAME_REMOTE}:${IMAGE_COMMITID}"
                        echo "COMMITID:${IMAGE_COMMITID}"
                    } else
                    {
                        if (env.MODULE_NAME == 'protectverify')
                        {
                          IMAGE_COMMITID=getXVSACommitID()
                        } else {
                          IMAGE_COMMITID=getCommitID()
                        }
                        echo "${DOCKER_IMAGE_NAME_REMOTE}:${IMAGE_COMMITID}"
                        echo "COMMITID:${IMAGE_COMMITID}"
                    }
                }
            }
        }

        stage('pull') {
            steps {
                echo '========= pull image =========='
                script {
                    echo "COMMITID:${IMAGE_COMMITID}"               
                    withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                        sh """                        
                        docker login -u $user -p $password ${DOCKER_REGISTRY}
                        docker pull ${DOCKER_IMAGE_NAME_REMOTE}:${IMAGE_COMMITID}
                        """
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                echo '======= deploy ======='
                echo 'N.B. The process is tagging new image -> removing container -> removing old image, docker swam will automatically bring the new tagged image up'
                script {
                        containerID = getContainerID()
                        echo "ContainerId: ${containerID}"
                        oldImageID = getImagesID()
                        echo "oldImageID: ${oldImageID}"
                        newImageID = getNewImagesID()
                        echo "newImageID:${newImageID}"
                        sh """
                            set +e
                            docker tag $DOCKER_IMAGE_NAME_REMOTE:$IMAGE_COMMITID $DOCKER_IMAGE_NAME:$IMAGE_VERSION
                            docker rmi $DOCKER_IMAGE_NAME_REMOTE:$IMAGE_COMMITID
                            if [ $MODULE_NAME != "xvsa" ]; then
                                docker stop $containerID
                                docker rm $containerID
                            fi
                            if [ $newImageID != $oldImageID ]; then
                                docker rmi $oldImageID
                            fi
                            set -e
                        """
                        }
                }
        }
        stage('versys') {
            steps {
                echo 'Register in version control system....'
                sh """
                if [ $MODULE_NAME != "protectverify" ]; then
                    curl -X POST -F 'refcommitid=$IMAGE_COMMITID' -F 'refmodule=$MODULE_NAME' $APIURL/updatebom
                fi
                """
            }
        }
    }
    post ('Email notification') {
        success {
            echo "Image building success for cloud deployment, sending email to $NOTIFY_EMAILS"
            notifyBuild('SUCCESS')
        }
        failure {
            echo "Image building failed for cloud deployment, sending email to $NOTIFY_EMAILS"
            notifyBuild('FAILED')
        }
    }
}

def getContainerID() {
    echo "---getContainerID---"
    echo "DOCKER_IMAGE_NAME: ${DOCKER_IMAGE_NAME}"
    echo "IMAGE_VERSION: ${IMAGE_VERSION}"
    return sh(returnStdout: true, script: "docker ps | grep $DOCKER_IMAGE_NAME:$IMAGE_VERSION | awk '{print  \$1}'").trim()
}

def getImagesID() {
    return sh(returnStdout: true, script: "docker images | grep ^$DOCKER_IMAGE_NAME | grep $IMAGE_VERSION | awk '{print  \$3}'").trim()
}

def getNewImagesID() {
    return sh(returnStdout: true, script: "docker images | grep ^$DOCKER_IMAGE_NAME_REMOTE | grep $IMAGE_COMMITID | awk '{print  \$3}'").trim()
}

def getCommitID() {
    return sh(returnStdout: true, script: "curl -G -d 'refModule=$MODULE_NAME' $APIURL/getmodid").trim()
}

def getXVSACommitID() {
    return sh(returnStdout: true, script: "curl -G -d 'refModule=xvsa' $APIURL/getmodid").trim()
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
