#!/bin/bash
# Build J2HienLoader cho macOS (Mac Catalyst) — app chay native tren Mac Apple Silicon
set -e
echo "=== Building J2ME-Loader for macOS (Catalyst) ==="
rm -rf build
mkdir -p build

xcodebuild build \
  -project J2MELoader-iOS.xcodeproj \
  -scheme J2MELoader-iOS \
  -configuration Release \
  -destination "generic/platform=macOS,variant=Mac Catalyst" \
  -derivedDataPath "$(pwd)/build/DerivedData" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="-" > build/xcodebuild_mac.log 2>&1 || {
    echo "=== XCODEBUILD MAC FAILED ==="
    tail -n 120 build/xcodebuild_mac.log
    exit 1
}

APP_PATH=$(find build/DerivedData -name "*.app" -maxdepth 5 | head -1)
if [ -z "$APP_PATH" ]; then
  echo "Khong tim thay .app"
  find build -maxdepth 6 | head -40
  exit 1
fi
echo "APP found: $APP_PATH"
APP_NAME=$(basename "$APP_PATH")
cd "$(dirname "$APP_PATH")"
zip -r "$(pwd)/../../$APP_NAME.zip" "$APP_NAME" >/dev/null
echo "ZIP: ../../$APP_NAME.zip"
ls -la ../../*.zip
