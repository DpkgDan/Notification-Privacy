#import "BBBulletin.h"
#import <CoreFoundation/CoreFoundation.h>

#define FILEPATH @"/var/mobile/Library/Preferences/com.dpkgdan.notificationprivacy.plist"

%hook BBBulletin

static NSDictionary *preferenceFile;
static NSString *notificationText;

void loadFromFile()
{
    preferenceFile = NULL;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: FILEPATH]){
        preferenceFile = [[NSDictionary alloc] initWithContentsOfFile: FILEPATH];
        
        notificationText = [preferenceFile objectForKey: @"NotificationText"];
        if (!notificationText)
            notificationText = @"New Notification";

    } else {
        notificationText = @"New Notification";
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

-(id)init
{
    if (preferenceFile == NULL){
        loadFromFile();

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update, CFSTR("com.dpkgdan.notificationprivacy.settingsupdated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
    return %orig;
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
    if (isMobileMail(arg1)){
        [self setSubtitle: notificationText];
        [self setMessage: @" "];
    } else if (isHiddenIdentifier(arg1)){
        [self setMessage: notificationText];
    }
    
    %orig(arg1);
}

-(BOOL)suppressesMessageForPrivacy
{
    if (isMobileSMS([self sectionID]))
        return NO;
    else
        return %orig;
}

-(BBAttachments*)attachments
{
    NSString *identifier = [self sectionID];

    if (isMobileSMS(identifier) || isMobileMail(identifier))
        return Nil;
    else
        return %orig;
}

%end