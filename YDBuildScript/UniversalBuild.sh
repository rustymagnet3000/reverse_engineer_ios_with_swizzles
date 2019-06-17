#!/bin/bash
printf "%0.s-" {1..120}
printf "%0.s-" {1..120}
echo -e "[+] *** To work with Swift code, uncomment Step 3 ***"
echo -e "[+] Converting ${TARGET_NAME} into Fat Framework"
echo -e "[+] Derived data location: ${BUILD_DIR}"
echo -e "[+] Configuration: ${CONFIGURATION}"   # Debug / Release
echo -e "[+] Build root: ${BUILD_ROOT}\n"
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
echo -e "[+] Universal folder: ${UNIVERSAL_OUTPUTFOLDER}\n"
if [ "true" == ${ALREADYINVOKED:-false} ]
then
  echo "[+] RECURSION: Detected, stopping"
else
  export ALREADYINVOKED="true"

# Step 1. Build Device and Simulator versions
xcodebuild -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules (from iphonesimulator build) to the copied framework directory
# cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule"

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework" "${PROJECT_DIR}"

# Step 6. as xcodebuild was running from script locally, I needed to remove temp directory
rm -r "${PROJECT_DIR}/build"
test -d "${PROJECT_DIR}/build" || echo -e "[+] Deleted temp folder"

fi
