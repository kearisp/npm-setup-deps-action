#!/usr/bin/env bash

version_gt() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$1" ]
}

KEYS="peerDependencies devDependencies dependencies"
LAST_VERSION=$(npm view $PACKAGE_NAME version 2> /dev/null || echo "")
BETA_VERSION=$(npm view $PACKAGE_NAME@$TAG version 2> /dev/null || echo "")
CURRENT_VERSION=""
echo "Found latest version: $LAST_VERSION"
echo "Found $TAG version: $BETA_VERSION"

for KEY in $KEYS; do
    DEP_VERSION=$(npm pkg get "$KEY.$PACKAGE_NAME" | sed -e 's/^"//' -e 's/^\^//' -e 's/^~//' -e 's/"$//')

    if [ $DEP_VERSION != '{}' ] && version_gt $DEP_VERSION $LAST_VERSION && [[ "$BETA_VERSION" == "$DEP_VERSION"* ]]; then
        CURRENT_VERSION=$DEP_VERSION
        npm pkg set "$KEY.$PACKAGE_NAME=^$BETA_VERSION"
        echo "Version in $KEY changed $CURRENT_VERSION -> ^$BETA_VERSION"
    fi
done

if [[ -n "$CURRENT_VERSION" ]] && [[ "$BETA_VERSION" == "$CURRENT_VERSION"* ]] && [[ -n "$OVERRIDES" ]]; then
    for OVERRIDE in $OVERRIDES; do
        npm pkg set "overrides.$OVERRIDE.$PACKAGE_NAME=^$BETA_VERSION"
        echo "Version in $OVERRIDE overrides set ^$BETA_VERSION"
    done
fi