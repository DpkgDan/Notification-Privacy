#ifndef Utilities_h
#define Utilities_h

NSString* notificationText();
BOOL isEnabled();
BOOL hiddenOnLockscreen();
BOOL hiddenOnHomescreen();
BOOL hiddenInNotifcenter();
BOOL allHidden();
BOOL isHiddenIdentifier(NSString *identifier);
BOOL isMobileMail(NSString *identifier);
void constructor();

#endif