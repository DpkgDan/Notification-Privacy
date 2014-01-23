ARCHS = armv7 arm64

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = NotificationPrivacy

NotificationPrivacy_FILES = Tweak.xm NPSettings.xm
NotificationPrivacy_FRAMEWORKS = AudioToolbox
NotificationPrivacy_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notificationprivacypreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
