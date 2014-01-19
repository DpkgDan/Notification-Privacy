#import "Headers/Utilities.h"

#define FILEPATH @"/var/mobile/Library/Preferences/com.dpkgdan.notificationprivacy.plist"

static NSDictionary *_preferenceFile;
static NSString *_notificationText;
static NSString *DEFAULT_TEXT = @"New Notification";

static BOOL _isEnabled;
static BOOL _hiddenOnLockscreen;
static BOOL _hiddenOnHomescreen;
static BOOL _hiddenInNotifcenter;

NSString* notificationText()
{
    return _notificationText;
}

BOOL isEnabled()
{
    return _isEnabled;
}

BOOL hiddenOnLockscreen()
{
    return _hiddenOnLockscreen;
}

BOOL hiddenOnHomescreen()
{
    return _hiddenOnHomescreen;
}

BOOL hiddenInNotifcenter()
{
    return _hiddenInNotifcenter;
}

BOOL isHiddenIdentifier(NSString *identifier)
{
    if (_preferenceFile == Nil)
        return NO;
    if ([[_preferenceFile objectForKey: identifier] boolValue])
        return YES;
    else
        return NO;
}

static void loadSettings()
{
	_preferenceFile = [[NSDictionary alloc] initWithContentsOfFile: FILEPATH];

	if (_preferenceFile) {
		id object = [_preferenceFile objectForKey: @"NotificationText"];
		_notificationText = (object ? object : DEFAULT_TEXT);

		object = [_preferenceFile objectForKey: @"isEnabled"];
		_isEnabled = (object ? [object boolValue] : YES);

		object = [_preferenceFile objectForKey: @"hiddenOnLockscreen"];
		_hiddenOnLockscreen = (object ? [object boolValue] : YES);

		object = [_preferenceFile objectForKey: @"hiddenOnHomescreen"];
		_hiddenOnHomescreen = (object ? [object boolValue] : YES);

		object = [_preferenceFile objectForKey: @"hiddenInNotifcenter"];
		_hiddenInNotifcenter = (object ? [object boolValue] : NO);
	
	} else {
		_notificationText = DEFAULT_TEXT;
		_isEnabled = YES;
		_hiddenOnLockscreen = YES;
		_hiddenOnHomescreen = YES;
		_hiddenInNotifcenter = NO;
	}
}

static void update (
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
)
{
    loadSettings();
}

void constructor()
{
    loadSettings();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR("com.dpkgdan.notificationprivacy.settingsupdated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}