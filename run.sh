#!/bin/bash
set -e

# --------------------------------------------
# 1. Environment setup
# --------------------------------------------

export ANDROID_HOME=~/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/29.0.13599879
export SKIP_JDK_VERSION_CHECK=true
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_NDK_HOME:$PATH"

AVD_NAME="test"
SYS_IMG="system-images;android-30;google_apis;x86"
DEVICE="pixel"

# --------------------------------------------
# 2. Sanity cleanup: remove broken backup folder
# --------------------------------------------

if [ -d "$ANDROID_HOME/emulator_backup" ]; then
  echo "🧹 Removing invalid emulator_backup directory"
  rm -rf "$ANDROID_HOME/emulator_backup"
fi

# --------------------------------------------
# 3. Install required packages if missing
# --------------------------------------------

sdkmanager --install "ndk;29.0.13599879" "$SYS_IMG" "emulator"

# --------------------------------------------
# 4. Create AVD if it doesn't exist
# --------------------------------------------

if ! avdmanager list avd | grep -q "$AVD_NAME"; then
  echo "📱 Creating AVD named $AVD_NAME"
  echo "no" | avdmanager create avd -n "$AVD_NAME" -k "$SYS_IMG" --device "$DEVICE"
fi

# --------------------------------------------
# 5. Kill zombie emulators
# --------------------------------------------

echo "🛑 Killing any zombie emulators"
pkill -9 -f "emulator" || true

# --------------------------------------------
# 6. Start Emulator
# --------------------------------------------

echo "🚀 Starting emulator..."
nohup emulator -avd "$AVD_NAME" -no-audio -no-snapshot -no-boot-anim -no-window > /tmp/emulator.log 2>&1 &

# Wait for ADB to connect
adb wait-for-device

echo "⏳ Waiting for emulator to fully boot..."
boot_completed=""
timeout=600
count=0
until [[ "$boot_completed" == "1" || $count -ge $timeout ]]; do
  boot_completed=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
  sleep 1
  count=$((count + 1))
done

if [ "$boot_completed" != "1" ]; then
  echo "❌ Timeout: emulator failed to boot in $timeout seconds"
  cat /tmp/emulator.log
  exit 1
fi

echo "✅ Emulator booted successfully"

# # --------------------------------------------
# # 5. Build Native Binary
# # --------------------------------------------

echo "Building native binary..."
mkdir -p build
$ANDROID_NDK_HOME/ndk-build \
  NDK_PROJECT_PATH=. \
  NDK_APPLICATION_MK=./Application.mk \
  APP_BUILD_SCRIPT=./Android.mk \
  NDK_OUT=./build \
  NDK_LIBS_OUT=./build

# # --------------------------------------------
# # 6. Push and run on AVD
# # --------------------------------------------

echo "Running native binary on AVD..."
adb shell mkdir -p /data/local/tmp/testbin
adb push build/local/x86/your-test-binary /data/local/tmp/testbin/
adb shell chmod +x /data/local/tmp/testbin/your-test-binary
adb push $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/i686-linux-android/libc++_shared.so /data/local/tmp/
adb shell LD_LIBRARY_PATH=/data/local/tmp /data/local/tmp/testbin/your-test-binary

