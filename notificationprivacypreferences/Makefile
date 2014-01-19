ARCHS = armv7 arm64

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

BUNDLE_NAME = NotificationPrivacyPreferences
NotificationPrivacyPreferences_FILES = NotificationPrivacyPreferences.mm
NotificationPrivacyPreferences_INSTALL_PATH = /Library/PreferenceBundles
NotificationPrivacyPreferences_FRAMEWORKS = UIKit
NotificationPrivacyPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotificationPrivacyPreferences.plist$(ECHO_END)
include $(THEOS_MAKE_PATH)/aggregate.mk
