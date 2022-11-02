REGISTRY=$1
VERSION=$2  # Image tag
BRANCH=$3
PRODUCT_RELEASE_VERSION=$4
BUILD_ARGS=$4

INFO="[INFO]:"
WARN="[WARNING]:"
ERR="[ERROR]:"

IMAGE_PREFIX="xcal"
THIRD_PARTY_IMAGE_LIST=()   # Third party images to be packaged
XCALSCAN_IMAGE_LIST=()      # Xcalscan images to be packaged
PACKAGED_IMAGE_LIST_FILE="pull_images/image.list"
XCALSCAN_IMAGE_LIST_FILE="pull_images/xcalscan_images.txt"
THIRD_PARTY_IMAGE_LIST_FILE="pull_images/third_party_images.txt"

status_check() {
  ret=$1
  prompt=$2

  if [ ${ret} != 0 ]; then
    logger "${ERR} ${prompt}...failed"
    exit 1
  else
    logger "${INFO} ${prompt}...ok"
  fi
}

get_ver() {
  GIT_REF_ID=$(git show-ref | grep ${BRANCH} | head -n 1 | awk '{print $1}')
  GIT_COMMIT_DATE=$(git log --pretty=format:"%cd" ${GIT_REF_ID} -1)
  echo "\"xcal-product-setup\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" > VER
}

pull_third_party_images() {
  t_images=$(cat $THIRD_PARTY_IMAGE_LIST_FILE)
  for t_image in ${t_images[@]}; do
    name=$(echo ${t_image} | tr "=" " " | awk '{print $1}')
    source=$(echo ${t_image} | tr "=" " " | awk '{print $2}')
    echo "$INFO Pulling third-party image $name from $source"
    docker pull $source &&
      docker tag $source "${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}" &&
      THIRD_PARTY_IMAGE_LIST+=("${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}")
    if [ $? -ne 0 ]; then
      echo "$ERR Pulling third-party image $name from $source failed."
      exit 1
    fi
  done
}

pull_xcalscan_images() {
  cat $XCALSCAN_IMAGE_LIST_FILE | sed "s#REGISTRY#${REGISTRY}#" | \
    sed "s#VERSION#${VERSION}#" > valid_xcalscan_images.txt
  x_images=$(cat valid_xcalscan_images.txt)
  for x_image in ${x_images[@]}; do
    name=$(echo ${x_image} | tr "=" " " | awk '{print $1}')
    source=$(echo ${x_image} | tr "=" " " | awk '{print $2}')
    echo "$INFO Pulling xcalscan image $name from $source"
    docker pull $source &&
      docker tag $source "${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}" &&
      XCALSCAN_IMAGE_LIST+=("${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}")
    if [ $? -ne 0 ]; then
      echo "$ERR Pulling xcalscan image $name from $source failed."
      exit 1
    fi
  done
}

grab_ver() {
  get_ver
  for xcalscan_image in ${XCALSCAN_IMAGE_LIST[@]}; do
    cmd_command="docker run --rm $xcalscan_image cat /VER"
    entrypoint_command="docker run --rm --entrypoint cat $xcalscan_image /VER"
    if $cmd_command > /dev/null; then
      $cmd_command >> VER
    elif $entrypoint_command > /dev/null; then
      $entrypoint_command >> VER
    else
      echo "$ERR Grabbing $xcalscan_image VER failed."
    fi
  done
}

write_image_list_to_file() {
  # clean PACKAGED_IMAGE_LIST_FILE first
  echo "cleaning $PACKAGED_IMAGE_LIST_FILE"
  echo "" > $PACKAGED_IMAGE_LIST_FILE

  for third_party_image in ${THIRD_PARTY_IMAGE_LIST[@]}; do
    echo $third_party_image >> $PACKAGED_IMAGE_LIST_FILE
  done
  for xcalscan_image in ${XCALSCAN_IMAGE_LIST[@]}; do
    echo $xcalscan_image >> $PACKAGED_IMAGE_LIST_FILE
  done
}

clean_images() {
  for xcalscan_image in ${XCALSCAN_IMAGE_LIST[@]}; do
      docker rmi $xcalscan_image
  done
}

main() {
  pull_third_party_images
  status_check $? "Pulling third_party_image"
  pull_xcalscan_images
  status_check $? "Pulling xcalscan_image"
  grab_ver
  status_check $? "Grabing ver"
  write_image_list_to_file
  status_check $? "write_image_list_to_file"
  #clean_images
  #status_check $? "clean_images"
}

# TODO: check completeness

main
