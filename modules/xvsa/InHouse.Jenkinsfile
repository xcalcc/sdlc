pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    environment {
      git_url = "gitlab-address/mastiff"
      branch = "$BRANCH_NAME"
      version = "$VERSION"
      registry = "$REGISTRY"
      image_name = "$IMAGE_NAME"
    }

    stages {
        stage('trace') {
           steps {
            sh "echo $PWD && ls -alF"
           }
        }
        //stage('clone repository') {
        //    steps {
        //      dir('modules/xvsa/workdir') {
        //          git credentialsId: 'xxx', branch: "${branch}", url: "${git_url}"
        //      }
        //    }
        //}
        stage('build image') {
            steps {
              echo 'Building image..'
              sh "echo $PWD && ls -alF"
              dir('modules/xvsa') {
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
    }
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}