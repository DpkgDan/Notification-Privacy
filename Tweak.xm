#import "Headers/Headers.h"

/** HOMESCREEN **/

%hook SBBulletinBannerItem

%new
-(NSString*)sectionID
{
	return [[self seedBulletin] sectionID];
}

%new
-(BOOL)shouldHideBulletin
{
	if (isEnabled() && hiddenOnHomescreen() && isHiddenIdentifier([self sectionID]))
		return YES;
	else
		return NO;
}

-(id)message
{
	if ([self shouldHideBulletin])
		return notificationText();
	else
		return %orig;
}

-(id)attachmentImage
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

%end

/** LOCKSCREEN **/

%hook SBAwayBulletinListItem

%new
-(NSString*)sectionID
{
	return [[[self bulletins] objectAtIndex: 0] sectionID];
}

%new
-(BOOL)shouldHideBulletin
{
	if (isEnabled() && hiddenOnLockscreen() && isHiddenIdentifier([self sectionID]))
		return YES;
	else
		return NO;
}

-(id)message
{
	if ([self shouldHideBulletin])
		return notificationText();
	else
		return %orig;
}

-(id)subtitle
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

-(id)attachmentImageForKey:(id)arg1
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

%end

/** NOTIFICATION CENTER **/

%hook SBNotificationsBulletinInfo

%new
-(NSString*)sectionID
{
	return [[%c(BBBulletin) copyCachedBulletinWithBulletinID: [self identifier]] sectionID];
}

%new
-(BOOL)shouldHideBulletin
{
	if (isEnabled() && hiddenInNotifcenter() && isHiddenIdentifier([self sectionID]))
		return YES;
	else
		return NO;
}

-(NSString*)_secondaryText
{
	if ([self shouldHideBulletin])
		return notificationText();
	else
		return %orig;
}

-(NSString*)_subtitleText
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

-(id)_attachmentImageToDisplay
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

%end

%ctor
{
    constructor();
}
