#!/bin/sh
rm -rf $CODESIGNING_FOLDER_PATH
cp -av $SRCROOT/Payload/$FULL_PRODUCT_NAME $CODESIGNING_FOLDER_PATH
rm -f $CODESIGNING_FOLDER_PATH/embedded.mobileprovision
$SRCROOT/Scripts/optool install -t $CODESIGNING_FOLDER_PATH/$EXECUTABLE_NAME -p "@executable_path/Frameworks/PDebug.framework/PDebug"
chmod +x $CODESIGNING_FOLDER_PATH/$EXECUTABLE_NAME
exit 0
