pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    environment {
      git_url = "gitlab-address/web-api-service-main"
      branch = "$DATABASE_BRANCH_NAME"
      version = "$VERSION"
      registry = "$REGISTRY"
      image_name = "$IMAGE_NAME"
      commit_id = "$COMMIT_ID"
    }

    stages {
        stage('trace') {
           steps {
            sh "echo $PWD && ls -alF"
           }
        }
        stage('clone repository') {
            steps {
              dir('modules/database/workdir') {
                git credentialsId: 'xxx', branch: "${branch}", url: "${git_url}"
              }
            }
        }
        stage('checkout commitid') {
            steps {
              dir('modules/database/workdir') {
                script {
                  //sh "echo ${env.commit_id}"
                  if (env.commit_id!=null && env.commit_id!="null")
                  {
                    sh "git checkout $commit_id"
                  } else
                  {
                    commit_id=getCommitID()
                  }
                }
              }
            }
        }
        stage('build image') {
            steps {
              echo 'Building image..'
              sh "echo $PWD && ls -alF"
              dir('modules/database') {
                sh "bash InHouseBuild.sh $image_name $version $branch $commit_id"
              }
            }
        }
        stage('push') {
            steps {
                echo 'Pushing....'
                withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                  sh """
                  docker login -u $user -p $password $registry
                  docker push $image_name:$commit_id
                  docker push $image_name:$version
                  """
               }
            }
        }
        stage('versys') {
            steps {
                echo 'Register in version control system....'
                sh """
                curl -X POST -F 'commitid=$commit_id' -F 'module=database' http://127.0.0.1:6200/new
                """
            }
        }
    }
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}

def getCommitID() {
    return sh(returnStdout: true, script: "git rev-parse HEAD").trim()
}