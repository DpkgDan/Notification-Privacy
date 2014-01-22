#import "Headers/Headers.h"

static NPSettings *settings;

static BOOL shouldHideTitle(id self)
{
	if ([self shouldHideBulletin] && settings.titleHidden)
		return YES;
	else
		return NO;
}

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
	if (settings.isEnabled && settings.hiddenOnHomescreen &&
	 [settings isHiddenIdentifier: [self sectionID]])
		return YES;
	else
		return NO;
}

-(NSString*)title
{
	if (shouldHideTitle(self))
		return settings.notificationText;
	else
		return %orig;
}

-(NSString*)message
{
	if (shouldHideTitle(self))
		return Nil;
	else if ([self shouldHideBulletin])
		return settings.notificationText;
	else
		return %orig;
}

-(UIImage*)attachmentImage
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

%end

/** LOCKSCREEN **/

%hook SBLockScreenNotificationListController

%new
-(BOOL)shouldHideBulletin:(NSString*)identifier
{
	if (settings.isEnabled && settings.removedFromLockscreen &&
	[settings isHiddenIdentifier: identifier])
		return YES;
	else
		return NO;
}

- (void)observer:(id)arg1 addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3
{
	if ([self shouldHideBulletin: bulletin.sectionID])
		return;
	else
		%orig();
}

%end

%hook SBAwayBulletinListItem

%new
-(NSString*)sectionID
{
	return [[[self bulletins] objectAtIndex: 0] sectionID];
}

%new
-(BOOL)shouldHideBulletin
{
	if (settings.isEnabled && settings.hiddenOnLockscreen
	&& [settings isHiddenIdentifier:[self sectionID]])
		return YES;
	else
		return NO;
}

-(NSString*)title
{
	if (shouldHideTitle(self))
		return settings.notificationText;
	else
		return %orig;
}

-(NSString*)message
{
	if (shouldHideTitle(self))
		return Nil;
	else if ([self shouldHideBulletin])
		return settings.notificationText;
	else
		return %orig;
}

-(NSString*)subtitle
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

-(UIImage*)attachmentImageForKey:(id)arg1
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
	if (settings.isEnabled && settings.hiddenInNotifcenter 
	&& [settings isHiddenIdentifier: [self sectionID]])
		return YES;
	else
		return NO;
}

-(NSString*)_primaryText
{
	if (shouldHideTitle(self))
		return settings.notificationText;
	else
		return %orig;
}

-(NSString*)_secondaryText
{
	if (shouldHideTitle(self))
		return Nil;
	else if ([self shouldHideBulletin])
		return settings.notificationText;
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

-(UIImage*)_attachmentImageToDisplay
{
	if ([self shouldHideBulletin])
		return Nil;
	else
		return %orig;
}

%end

%ctor
{
    settings = [NPSettings sharedInstance];
}
