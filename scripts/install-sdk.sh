#!/bin/bash

set -ex

# Map Docker TARGETARCH to Android SDK ABI
case "$ARCHITECTURE" in
  amd64)   ANDROID_ABI="x86_64" ;;
  arm64)   ANDROID_ABI="arm64-v8a" ;;
  x86_64)  ANDROID_ABI="x86_64" ;;
  arm64-v8a) ANDROID_ABI="arm64-v8a" ;;
  *)       echo "Unsupported architecture: $ARCHITECTURE"; exit 1 ;;
esac

export PACKAGE_PATH="system-images;android-${API_LEVEL};${IMG_TYPE};${ANDROID_ABI}"
export ABI="${IMG_TYPE}/${ANDROID_ABI}"
export ARCHITECTURE="$ANDROID_ABI"

# If the installation flag of the Android SDK is set
# we download the Android command-line tools,
# install the SDK, platform tools and the emulator.
if [ "$INSTALL_ANDROID_SDK" == "1" ]; then
  echo "Installing the Android SDK, platform tools and emulator ..."
  echo "Package path: $PACKAGE_PATH"
  wget https://dl.google.com/android/repository/commandlinetools-linux-${CMD_LINE_VERSION}.zip -P /tmp && \
  mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/ && \
  unzip -d $ANDROID_SDK_ROOT/cmdline-tools/ /tmp/commandlinetools-linux-${CMD_LINE_VERSION}.zip && \
  mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/ $ANDROID_SDK_ROOT/cmdline-tools/tools/ && \
  rm /tmp/commandlinetools-linux-${CMD_LINE_VERSION}.zip && \
  yes | sdkmanager --licenses && \
  sdkmanager --install "$PACKAGE_PATH" "$ANDROID_PLATFORM_VERSION" platform-tools emulator
fi
