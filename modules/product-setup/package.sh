COMPANY=$1
VERSION=$2 # Image tag (reserverd)
PRODUCT_NAME=$3
PRODUCT_RELEASE_VERSION=$4
BUILD_ARGS=$5

INFO="[INFO]:"
WARN="[WARNING]:"
ERR="[ERROR]:"

NETWORK_SUFFIX="$(echo $PRODUCT_RELEASE_VERSION | tr "." "_")"
IMAGE_TAR="xcal.images.tar"
PACKAGED_IMAGE_LIST_FILE="pull_images/image.list"
PACKAGED_IMAGE_LIST=()
PACKAGE_DATA_TAR=$COMPANY-$PRODUCT_NAME-$PRODUCT_RELEASE_VERSION.tar
PACKAGE_INSTALLER_TAR=$COMPANY-$PRODUCT_NAME-$PRODUCT_RELEASE_VERSION-installer.tar
INSTALLER_SCRIPT=$PRODUCT_NAME-$PRODUCT_RELEASE_VERSION-install.sh
UPGRADE_SCRIPT=upgrade.sh

# create preset directories
create_directory() {
  echo "$INFO Creating preset directories"
  mkdir -p $COMPANY/config &&
    mkdir -p $COMPANY/data/volume/logs $COMPANY/data/volume/diagnostic $COMPANY/data/volume/scandata $COMPANY/data/volume/upload $COMPANY/data/volume/tmp $COMPANY/data/volume/kafka $COMPANY/data/volume/kafka-data $COMPANY/data/volume/rules $COMPANY/data/volume/customrules &&
    mkdir -p $COMPANY/images
  if [ $? -ne 0 ]; then
    echo "$ERR Creating preset directories failed"
    exit 1
  fi
}


# Wrap images to be used
wrap_image() {
  echo "$INFO Reading image list"
  if [ ! -f $PACKAGED_IMAGE_LIST_FILE ]; then
    echo "$ERR image list file:$PACKAGED_IMAGE_LIST_FILE don't exist"
    exit 1
  fi
  images=$(cat $PACKAGED_IMAGE_LIST_FILE)
  for image in ${images[@]}; do
    PACKAGED_IMAGE_LIST+=("$image")
  done

  echo "$INFO Saving images..."
  docker save "${PACKAGED_IMAGE_LIST[@]}" -o $IMAGE_TAR &&
    mv $IMAGE_TAR $COMPANY/images
  if [ $? -ne 0 ]; then
    echo "$ERR Saving images...failed"
    exit 1
  fi
}

# Replace template value
config_related_files() {
  echo "$INFO Configuring related files"
  cat installer/xcalscan-install.sh | \
    sed "s%PRODUCT_RELEASE_NAME%${PRODUCT_NAME}%g" | sed "s%PRODUCT_RELEASE_VERSION%${PRODUCT_RELEASE_VERSION}%g" > \
    ${INSTALLER_SCRIPT} &&

    cat installer/xcalscan-uninstall.sh | \
      sed "s%PRODUCT_RELEASE_NAME%${PRODUCT_NAME}%g" | sed "s%PRODUCT_RELEASE_VERSION%${PRODUCT_RELEASE_VERSION}%g" > \
      $COMPANY/config/$PRODUCT_NAME-$PRODUCT_RELEASE_VERSION-uninstall.sh &&

    cat installer/xcalscan-service.sh | \
      sed "s/PRODUCT_RELEASE_VERSION/${PRODUCT_RELEASE_VERSION}/g" > \
      $COMPANY/config/$PRODUCT_NAME-service.sh &&

    cat installer/xcalscan-docker-compose-customer.yml | \
      sed "s%IMAGE_VERSION%${PRODUCT_RELEASE_VERSION}%g"  | \
      sed "s%NETWORK_SUFFIX%${NETWORK_SUFFIX}%g"  | \
      sed "s%PRODUCT_VERSION%${PRODUCT_RELEASE_VERSION}%g" > \
      $COMPANY/config/$PRODUCT_NAME-$PRODUCT_RELEASE_VERSION-docker-compose-customer.yml

  if [ $? -ne 0 ]; then
    echo "$ERR Configuring related files failed"
    exit 1
  fi

}

# Wrap installer
wrap_installer() {
  echo "$INFO Wrapping installer"
  tar -cf $PACKAGE_DATA_TAR $COMPANY &&
    cp installer/.env . &&
    cp -r installer/.config . &&
    chmod +x $INSTALLER_SCRIPT &&
    cp installer/$UPGRADE_SCRIPT . &&
    tar -cvf $PACKAGE_INSTALLER_TAR $PACKAGE_DATA_TAR $INSTALLER_SCRIPT $UPGRADE_SCRIPT .env .config &&
    gzip $PACKAGE_INSTALLER_TAR &&
    rm $PACKAGE_DATA_TAR &&
    ls -lLrt
  if [ $? -ne 0 ]; then
    echo "$ERR Wrapping installer failed"
  fi
}


main() {
  create_directory
  wrap_image
  config_related_files
  wrap_installer
}

main