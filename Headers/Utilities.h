#ifndef Utilities_h
#define Utilities_h

@class BBBulletin;

NSString* notificationText();
BOOL hasBeenConstructed();
BOOL isEnabled();
BOOL hiddenOnLockscreen();
BOOL hiddenOnHomescreen();
BOOL hiddenInNotifcenter();
BOOL allHidden();
BOOL isHiddenIdentifier(NSString *identifier);
BOOL isMobileMail(NSString *identifier);
void constructor();

#endif