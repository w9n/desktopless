#! /bin/sh
set -e

# from https://github.com/linuxkit/linuxkit/blob/master/tools/alpine/push-manifest.sh

# This script creates a multiarch manifest for the 'linuxkit/alpine'
# image, pushes and signs it. The manifest is pushed with the tag of
# the amd64 images (which is the suffix removed). On macOS we use the
# credentials helper to extract the Hub credentials. We need to
# manually sign the manifest using 'notary'.
#
# This script is specific to 'linuxkit/alpine'. For normal packages we
# use a different scheme.
#
# For signing, DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE must be set.
#
# This should all be replaced with 'docker manifest' once it lands.

ORG=$1
IMAGE=$2

IMG_X86_64=$(head -1 versions.x86_64 | sed 's,[#| ]*,,')
IMG_ARM64=$(head -1 versions.aarch64 | sed 's,[#| ]*,,')
# Extract the TAG from the x86_64 name and build the manifest target name
TAG=$(echo "$IMG_X86_64" | sed 's,\-.*$,,' | cut -d':' -f2)
TARGET="$ORG/$IMAGE:$TAG"

YAML=$(mktemp)
cat <<EOF > "$YAML"
image: $TARGET
manifests:
 # temporarly disabled
 #- image: $IMG_ARM64
 #   platform:
 #     architecture: arm64
 #     os: linux
  - image: $IMG_X86_64
    platform:
      architecture: amd64
      os: linux
EOF

# Work out credentials. On macOS they are needed for manifest-tool and
# we need them for notary on all platforms.
case $(uname -s) in
    Darwin)
        CRED=$(echo "https://index.docker.io/v1/" | /Applications/Docker.app/Contents/Resources/bin/docker-credential-osxkeychain.bin get)
        USER=$(echo "$CRED" | jq -r '.Username')
        PASS=$(echo "$CRED" | jq -r '.Secret')
        MT_ARGS="--username $USER --password $PASS"
        ;;
    Linux)
        CRED=$(cat ~/.docker/config.json | jq -r '.auths."https://index.docker.io/v1/".auth' | base64 -d -)
        USER=$(echo $CRED | cut -d ':' -f 1)
        PASS=$(echo $CRED | cut -d ':' -f 2-)
        # manifest-tool can use docker credentials directly
        MT_ARGS=
        ;;
    *)
        echo "Unsupported platform"
        exit 1
        ;;
esac

# Push manifest list
OUT=$(manifest-tool $MT_ARGS push from-spec "$YAML")
rm "$YAML"
echo "$OUT"

# Extract sha256 and length from the manifest-tool output
SHA256=$(echo "$OUT" | cut -d' ' -f2 | cut -d':' -f2)
LEN=$(echo "$OUT" | cut -d' ' -f3)

NOTARY_DELEGATION_PASSPHRASE="$DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE"

# Notary requires a PTY for username/password so use expect for that.
export NOTARY_DELEGATION_PASSPHRASE="$DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE"
NOTARY_CMD="notary -s https://notary.docker.io -d $HOME/.docker/trust addhash \
             -p docker.io/"$ORG"/"$IMAGE" $TAG $LEN --sha256 $SHA256 \
             -r targets/releases"

$NOTARY_CMD
echo
echo "New signed multi-arch image: $REPO:$TAG"
echo
