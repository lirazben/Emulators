# Emukators
# Android AVD + C++ Test in GitHub Actions

This repository demonstrates how to:
- Compile a C++ binary with Android NDK
- Compile a java apk 
- Start an Android AVD in GitHub Actions
- Push the binary to the emulator
- Push the apk and the test_apk
- Execute them via `adb shell`

## Output

The binary should print:
✅ TEST PASSED from C++ on Android AVD!

INSTRUMENTATION_RESULT: stream=

Time: 0.011

OK (1 test)

