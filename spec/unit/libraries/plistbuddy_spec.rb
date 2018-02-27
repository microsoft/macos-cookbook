# Set the CFBundleIdentifier property to com.apple.plistbuddy:
#
#         Set :CFBundleIdentifier com.apple.plistbuddy
#
# Add the CFBundleGetInfoString property to the plist:
#
#         Add :CFBundleGetInfoString string "App version 1.0.1"
#
# Add a new item of type dict to the CFBundleDocumentTypes array:
#
#         Add :CFBundleDocumentTypes: dict
#
# Add the new item to the beginning of the array:
#
#         Add :CFBundleDocumentTypes:0 dict
#
# Delete the FIRST item in the array:
#
#         Delete :CFBundleDocumentTypes:0 dict
#
# Delete the ENTIRE CFBundleDocumentTypes array:
#
#         Delete :CFBundleDocumentTypes
