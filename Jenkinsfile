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
          scmVars = checkout scm
          gitcommit = scmVars.GIT_COMMIT
          echo "Build SHA: $gitcommit"
          echo "fdsssffdfgcvbcbd"
        }
      }
    }
  }
}
