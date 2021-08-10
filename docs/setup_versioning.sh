#!/bin/bash -x
# Automated Versioning Changes are done here.
# Do Not change versions in anyother place 

CHANGE_LOG=changelog$$
#PRODUCT_VERSION=$(curl https://stash.us.cray.com/projects/SSHOT/repos/slingshot-version/raw/slingshot-version?at=refs%2Fheads%2Fmaster)
PRODUCT_VERSION=1.0.0
date=`date '+%a %b %d %Y'` 
git_hash=`git rev-parse HEAD`
if [[ -z "${BUILD_NUMBER}" ]]; then
  RELEASE="LocalBuild"
else
  RELEASE=${BUILD_NUMBER}
fi


create_changelog() {
    # Usage:
    #    create_changelog <output file name> <release_version>
    outfile=$1
    package_version=$2


    rm -f $1
    echo '* '`date '+%a %b %d %Y'`" $USER <$USER@hpe.com> $package_version" >> $1
    echo "- Built from git hash ${git_hash}" >> $1
}

if [[ ! -z "${1}" ]]; then
   cat << EOF
---
# Copyright and Version
&copy; 2021 Hewlett Packard Enterprise Development LP

Docs-as-code Template:
${PRODUCT_VERSION}-${RELEASE}

Doc git hash:
${git_hash}

Generated:
${date}

EOF
   exit 0
fi

if [[ ! -z "${BUILD_NUMBER}" ]]; then
    if [[ -z "${PRODUCT_VERSION}" ]]; then
        echo "Version: ${PRODUCT_VERSION} is Empty"
        exit 1
    fi 
    create_changelog $CHANGE_LOG ${PRODUCT_VERSION}

    # Modify .version files
    sed -i s/999.999.999/${PRODUCT_VERSION}-${BUILD_NUMBER}/g .version
    sed -i s/999.999.999/${PRODUCT_VERSION}/g .version_rpm

    # Modify rpm spec 
    cat portal/developer-portal/product-docs.spec.template | sed \
        -e "s/999.999.999/$PRODUCT_VERSION/g" \
        -e "/__CHANGELOG_SECTION__/r $CHANGE_LOG" \
        -e "/__CHANGELOG_SECTION__/d" > portal/developer-portal/product-docs.spec
fi
rm -f ${CHANGE_LOG}