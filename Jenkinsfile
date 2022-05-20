#!/usr/bin/env groovy

def scmVars = ""
def gitcommit = ""

pipeline {

  agent {
    label 'master'
  }

  stages {

    stage('Prepare Git') {
      options {
          retry(2)
      }
      steps {
        deleteDir()  
        script {
          //scmVars = checkout scm
          //gitcommit = scmVars.GIT_COMMIT
          scmSkip(deleteBuild: true, skipPattern:'.*[maven-release-plugin].*')
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'MessageExclusion', excludedMessage: 'jenkins'], [$class: 'LocalBranch', localBranch: 'master']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/ricardofas/devops.git']]])
          //echo "Build SHA: $gitcommit"
          echo "fdsssffdfgcvbcbddfdfsdfssdfsdfsdfsdfdffdfdg"
        }
      }
    }
  }
}
