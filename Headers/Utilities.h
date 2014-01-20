#ifndef Utilities_h
#define Utilities_h

NSString* notificationText();
BOOL isEnabled();
BOOL hiddenOnLockscreen();
BOOL hiddenOnHomescreen();
BOOL hiddenInNotifcenter();
BOOL titleHidden();
BOOL isHiddenIdentifier(NSString *identifier);
void constructor();

#endif