#import "Headers/Utilities.h"

#define FILEPATH @"/var/mobile/Library/Preferences/com.dpkgdan.notificationprivacy.plist"

static NSDictionary *_preferenceFile;
static NSString *_notificationText;
static NSString *DEFAULT_TEXT = @"New Notification";

static BOOL _isEnabled;

static BOOL _hiddenOnLockscreen;
static BOOL _hiddenOnHomescreen;
static BOOL _hiddenInNotifcenter;

NSDictionary* preferenceFile()
{
    return _preferenceFile;
}

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

BOOL allHidden()
{
    return _hiddenOnLockscreen && _hiddenOnHomescreen && _hiddenInNotifcenter;
}

static void loadSettings()
{
    _preferenceFile = NULL;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: FILEPATH]){
        _preferenceFile = [[NSDictionary alloc] initWithContentsOfFile: FILEPATH];

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
        _isEnabled = NO;
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

BOOL isHiddenIdentifier(NSString *identifier)
{
    if (_preferenceFile == NULL)
        return NO;
    if ([[_preferenceFile objectForKey: identifier] boolValue])
        return YES;
    else
        return NO;
}

static BOOL isMatch(NSString *matchString, NSString *identifier)
{
    if ([identifier isEqualToString: matchString] &&
    isHiddenIdentifier(identifier))
        return YES;
    else
        return NO;
}

BOOL isMobileMail(NSString *identifier)
{
    if (isMatch(@"com.apple.mobilemail", identifier))
        return YES;
    else
        return NO;
}

void constructor()
{
    loadSettings();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR("com.dpkgdan.notificationprivacy.settingsupdated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}