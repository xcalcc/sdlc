pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    tools {
        maven 'maven-3-6-3'
    }

    environment {
      git_url = "gitlab-address/web-api-service-main"
      //git_url = "gitlab-address/web-api-service-main"
      branch = "$MAINSERVICE_BRANCH_NAME"
      version = "$VERSION"
      registry = "$REGISTRY"
      image_name = "$IMAGE_NAME"
      m2_dir = "$M2_DIR"
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
              dir('modules/web-main-service/workdir') {
                  git credentialsId: 'xxx', branch: "${branch}", url: "${git_url}"
              }
            }
        }
        stage('checkout commitid') {
            steps {
              dir('modules/web-main-service/workdir') {
                script {
                  //sh "echo ${env.commit_id}"
                  if (env.commit_id != null && env.commit_id != "null")
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
              dir('modules/web-main-service') {
                sh "bash -x InHouseBuild.sh $image_name $version $branch $m2_dir $commit_id"
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
                curl -X POST -F 'commitid=$commit_id' -F 'module=webmain' http://127.0.0.1:6200/new
                """
            }
        }
        // stage('build') {
        //     steps {
        //       dir('modules/web-main-service/workdir') {
        //         echo 'Building Harry..'
        //         sh 'ls -alF'
        //         sh 'mvn clean package'
        //       }
        //     }
        // }
        // stage('JaCoCo') {
        //     steps {
        //       dir('modules/web-main-service/workdir') {
        //         echo '======= Generate JaCoCo Report ======='
        //         jacoco(
        //                 changeBuildStatus: true,
        //                 execPattern: 'target/*.exec',
        //                 classPattern: 'target/classes',
        //                 sourcePattern: 'src/main/java',
        //                 exclusionPattern: '**/repository/*.class,**/entity/*_.class,**/WebAPIServiceMainApplication.class',
        //                 minimumBranchCoverage: '70',
        //                 maximumBranchCoverage: '80',
        //                 minimumClassCoverage: '70',
        //                 maximumClassCoverage: '80',
        //                 minimumComplexityCoverage: '65',
        //                 maximumComplexityCoverage: '80',
        //                 minimumInstructionCoverage: '80',
        //                 maximumInstructionCoverage: '85',
        //                 minimumLineCoverage: '80',
        //                 maximumLineCoverage: '85',
        //                 minimumMethodCoverage: '80',
        //                 maximumMethodCoverage: '85'
        //         )
        //       }
        //     }
        // }
    }
    // post {
    //     success {
    //         emailext (
    //             subject: "'${env.JOB_NAME} [${env.BUILD_NUMBER}]' update success",
    //             body: """
    //             Detail:
    //             SUCCESSFULL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
    //             Status: ${env.JOB_NAME} jenkins run normal
    //             URL: ${env.BUILD_URL}
    //             Project Name: ${env.JOB_NAME}
    //             Project Update Process: ${env.BUILD_NUMBER}
    //             """,
    //             to: "deyu.xie@xcalibyte.com,raymond.ma@xcalibyte.com"
    //         )
    //     }
    //     failure {
    //         emailext (
    //             subject: "'${env.JOB_NAME} [${env.BUILD_NUMBER}]' update failure",
    //             body: """
    //             Detail:
    //             FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
    //             Status: ${env.JOB_NAME} jenkins run fail
    //             URL: ${env.BUILD_URL}
    //             Project Name: ${env.JOB_NAME}
    //             Project Update Process: ${env.BUILD_NUMBER}
    //             """,
    //             to: "deyu.xie@xcalibyte.com,raymond.ma@xcalibyte.com"
    //         )
    //     }
    //     unstable {
    //         emailext (
    //             subject: "'${env.JOB_NAME} [${env.BUILD_NUMBER}]' update success",
    //             body: """
    //             Detail:
    //             SUCCESSFULL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
    //             Status: ${env.JOB_NAME} jenkins run normal
    //             URL: ${env.BUILD_URL}
    //             Project Name: ${env.JOB_NAME}
    //             Project Update Process: ${env.BUILD_NUMBER}
    //             """,
    //             to: "deyu.xie@xcalibyte.com,raymond.ma@xcalibyte.com"
    //         )
    //     }
    // }
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}

def getCommitID() {
    return sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
}