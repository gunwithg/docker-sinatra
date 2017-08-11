
USERNAME=git log --format='%an' ${TRAVIS_COMMIT} 
EMAILADDRESS=git log --format='%ae' ${TRAVIS_COMMIT}
BRANCH=

cd $HOME
git config --global user.name "${USERNAME}"
git config --global user.email "${EMAILADDRESS}"
git clone --branch=master  https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra  master > /dev/null

cd master  
ls -alih
cat .git/config

#touch projectname.hcl
#echo "${TRAVIS_BUILD_NUMBER}" > projectname.hcl

#NOMAD_JOB=$(basename `pwd`)
#DOCKER_REPO=$1
#DOCKER_TAG=$2

cat > projectname.hcl << NOMADCONFIG
job "NOMAD_JOB}" {
  region      = "aws"
  datacenters = ["eu-west-1"]
  type = "service"

  update {
    stagger      = "60s"
    max_parallel = 1
  }

  constraint {
    attribute = "${node.class}"
    value     = "Edge_Node"
  }

  group "${DOCKER_REPO}" {
    count = 1

    task "deploy" {
      driver = "docker"
      config {
        image = "${DOCKER_REPO}:${DOCKER_TAG}"
        force_pull = true
        auth {
          username =  "${DOCKER_USERNAME}"
          password =  "${DOCKER_PASSWORD}"
        }

        port_map {
          http = 80
          management = 7777
        }
      }

      # Specify the maximum resources required to run the job,
      # include CPU, memory, and bandwidth.
      resources {
        cpu    = 1024 # MHz
        memory = 1024 # MB

        network {
          mbits = 10
          port "http" {
            static = 80
          }
          port "management" {
            static = 7777
          }
        }
      }
    }
  }
}
NOMADCONFIG



git add -f .
git remote rm origin
git remote add origin https://gunwithg:$GITHUB_API_KEY@github.com/gunwithg/docker-sinatra.git
cat .git/config
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed [skip ci] "
git push -fq origin master:deploy 
echo -e "Done\n"


echo ${TRAVIS_BUILD_DIR}
echo ${TRAVIS_BUILD_ID}
echo ${TRAVIS_BUILD_NUMBER}
echo ${TRAVIS_COMMIT}
echo ${TRAVIS_COMMIT_MESSAGE}
echo ${TRAVIS_COMMIT_RANGE}
echo ${TRAVIS_EVENT_TYPE}
echo ${TRAVIS_JOB_ID}
echo ${TRAVIS_PULL_REQUEST}
echo ${TRAVIS_PULL_REQUEST_BRANCH}
echo ${TRAVIS_BRANCH}
