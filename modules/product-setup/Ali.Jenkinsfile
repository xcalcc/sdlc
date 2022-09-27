pipeline {
    agent any
    environment {
        IMAGE_VERSION = "$VERSION"
        DOCKER_IMAGE_NAME = "$IMAGE_NAME"
        DOCKER_IMAGE_NAME_REMOTE = "$IMAGE_NAME_HUB"
    }
    stages {
        stage('pull') {
            steps {
                echo '========= pull image =========='
                script {
                    echo "${DOCKER_IMAGE_NAME_REMOTE}"
                    withCredentials([usernamePassword(credentialsId: 'harbor_xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                        sh """                        
                        docker login -u $user -p $password hub.xcalibyte.co
                        docker pull ${DOCKER_IMAGE_NAME_REMOTE}:${IMAGE_VERSION}
                        """
                    }
                }

            }
        }
        stage('deploy') {
            steps {
                echo '======= deploy ======='
                script {
                        containerID = getContainerID()
                        echo "${containerID}"
                        oldImageID = getImagesID()
                        echo "${oldImageID}"
                        newImageID = getNewImagesID()
                        echo "${newImageID}"
                        sh """
                        set +e
                        docker tag $DOCKER_IMAGE_NAME_REMOTE:$IMAGE_VERSION $DOCKER_IMAGE_NAME:$IMAGE_VERSION
                        docker rmi $DOCKER_IMAGE_NAME_REMOTE:$IMAGE_VERSION
                        docker stop $containerID
                        docker rm $containerID
                        if [ $newImageID != $oldImageID ]; then
                            docker rmi $oldImageID
                        fi                   
                        set -e
                        """
                        }
                }
        }
    }
}

def getContainerID() {
    return sh(returnStdout: true, script: "docker ps | grep $DOCKER_IMAGE_NAME:$IMAGE_VERSION | awk '{print  \$1}'").trim()
}

def getImagesID() {
    return sh(returnStdout: true, script: "docker images | grep ^$DOCKER_IMAGE_NAME | grep $IMAGE_VERSION | awk '{print  \$3}'").trim()
}

def getNewImagesID() {
    return sh(returnStdout: true, script: "docker images | grep ^$DOCKER_IMAGE_NAME_REMOTE | grep $IMAGE_VERSION | awk '{print  \$3}'").trim()
}