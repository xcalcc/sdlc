BRANCH=$1
VER_FILE=$2

get_ver() {
  GIT_REF_ID=$(git show-ref | grep ${BRANCH} | head -n 1 | awk '{print $1}')
  GIT_COMMIT_DATE=$(git log --pretty=format:"%cd" ${GIT_REF_ID} -1)
  echo "\"sdlc\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" >> "$VER_FILE"
}

get_ver