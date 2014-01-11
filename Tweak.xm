#import "BBBulletin.h"
#import <CoreFoundation/CoreFoundation.h>

#define FILEPATH @"/var/mobile/Library/Preferences/com.dpkgdan.notificationprivacy.plist"
#define DEFAULT_TEXT @"New Notification"

%hook BBBulletin

static NSDictionary *preferenceFile;
static NSString *notificationText;
static BOOL isEnabled;
static BOOL isLockScreen = YES;

void loadFromFile()
{
    preferenceFile = NULL;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: FILEPATH]){
        preferenceFile = [[NSDictionary alloc] initWithContentsOfFile: FILEPATH];
        
        NSArray *allKeys = [preferenceFile allKeys];
        
        if ([allKeys containsObject: @"NotificationText"])
            notificationText = [preferenceFile objectForKey: @"NotificationText"];
        else
            notificationText = DEFAULT_TEXT;

        if ([allKeys containsObject: @"isEnabled"])
            isEnabled = [[preferenceFile objectForKey: @"isEnabled"] boolValue];
        else
            isEnabled = YES;

    } else {
        isEnabled = NO;
    }
}

void update (
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
)
{
    loadFromFile();
}

void displayStatusChanged (
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
)
{
    isLockScreen = !isLockScreen;
}

/* //For debugging
-(id)initWithCoder:(id)arg1
{
    self = %orig(arg1);
    NSLog(@"%@", [self description]);
    return self;
} */

BOOL isHiddenIdentifier(NSString *identifier)
{
    if (preferenceFile == NULL)
        return NO;
    if ([[preferenceFile objectForKey: identifier] boolValue])
        return YES;
    else
        return NO;
}

BOOL isMatch(NSString *matchString, NSString *identifier)
{
    if ([identifier isEqualToString: matchString] &&
    isHiddenIdentifier(identifier))
        return YES;
    else
        return NO;
}

BOOL isMobileSMS(NSString *identifier)
{
    if (isMatch(@"com.apple.MobileSMS", identifier))
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

-(void)setSectionID:(NSString*)arg1
{
    if (isEnabled){
        if (isMobileMail(arg1)){
            [self setSubtitle: notificationText];
            [self setMessage: @" "];
        } else if (isHiddenIdentifier(arg1)){
            [self setMessage: notificationText];
        }
    }
    %orig(arg1);
}

-(BOOL)suppressesMessageForPrivacy
{
    if (isEnabled){
        if (isMobileSMS([self sectionID]))
            return NO;
        else
            return %orig;
    } else {
        return %orig;
    }
}

-(BBAttachments*)attachments
{
    if (isEnabled){
        NSString *identifier = [self sectionID];

        if (isMobileSMS(identifier) || isMobileMail(identifier))
            return Nil;
        else
            return %orig;
    } else {
        return %orig;
    }
}

%end

%ctor
{
    @autoreleasepool {
        loadFromFile();

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR("com.dpkgdan.notificationprivacy.settingsupdated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR("com.dpkgdan.notificationprivacy.enabled"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.springboard.lockstate"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}