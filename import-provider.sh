#!/bin/bash
set -euo pipefail

# Help and usage
usage() {
    cat <<EOF
Usage: $(basename "$0") <container-image>

Extract CRDs from an Upbound xpkg container image and import them with kcl.

Arguments:
  <container-image>   The OCI image (e.g., xpkg.upbound.io/upbound/provider-aws-ec2:v1)

Example:
  $(basename "$0") xpkg.upbound.io/upbound/provider-aws-ec2:v1
EOF
    exit 1
}

# Check input
if [[ $# -ne 1 ]]; then
    usage
fi

IMG="$1"
PACKAGE_FILE="package.yaml"
CRD_FILE="crds.yaml"

# Create temp directory and cleanup on exit
TEMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Create and export Docker container
echo "Creating Docker container from image: $IMG"
CONTAINER_ID=$(docker create "$IMG")

echo "Exporting container filesystem..."
docker export "$CONTAINER_ID" | tar -xC "$TEMP_DIR"
docker rm "$CONTAINER_ID" > /dev/null

# Extract CRDs
PACKAGE_PATH="$TEMP_DIR/$PACKAGE_FILE"
CRD_OUTPUT_PATH="$TEMP_DIR/$CRD_FILE"

if [[ ! -f "$PACKAGE_PATH" ]]; then
    echo "Error: $PACKAGE_FILE not found in image."
    exit 1
fi

echo "Extracting CRDs from $PACKAGE_FILE..."
yq eval 'select(.kind == "CustomResourceDefinition")' "$PACKAGE_PATH" > "$CRD_OUTPUT_PATH"

# Convert CRDs with kcl
MODULE_NAME=$(basename "${IMG%%:*}" | tr '-' '_')
echo "Importing CRDs into kcl module: $MODULE_NAME"
kcl import -m crd -p "$MODULE_NAME" "$CRD_OUTPUT_PATH"

echo "Done."