#import "Headers/Headers.h"

static NSRecursiveLock *lock = [NSRecursiveLock new];
static NSMutableDictionary *identifierForMsgData = [NSMutableDictionary new];

static void addToDict(BBBulletin* bulletin)
{
    @autoreleasepool {
        NSLog(@"Call to addToDict()");

        NSString *message = [[bulletin message] copy];
        NSString *subtitle = [[bulletin subtitle] copy];
        BBAttachments *attachments = [[bulletin attachments] copy];
        NSString *sectionID = [[bulletin sectionID] copy];
        
        [lock lock];
        NSLog(@"Lock obtained: addToDict()");

        if (![identifierForMsgData objectForKey: bulletin.bulletinID]){
            MessageData *messageData = [[MessageData alloc] initWithMessage: message subtitle: subtitle attachments: attachments sectionID: sectionID];
            [identifierForMsgData setObject: messageData forKey: bulletin.bulletinID];
        }

        [lock unlock];
        NSLog(@"Lock released: addToDict()");
    }
}

static BBBulletin* hideBulletinContent(BBBulletin *bulletin)
{
    BBBulletin *bulletinCopy = [bulletin copy];
    BBContent *contentCopy = [bulletin.content copy];

    contentCopy.message = notificationText();
    contentCopy.subtitle = Nil;
    bulletinCopy.attachments = Nil;
    
    bulletinCopy.content = contentCopy;
    return bulletinCopy;
}

static BBBulletin* restoreBulletinContent(BBBulletin *bulletin)
{
    @autoreleasepool {
        [lock lock];
        NSLog(@"Lock obtained: restoreBulletinContent()");

        MessageData *messageData = [identifierForMsgData objectForKey: [bulletin bulletinID]];

        if (messageData){
            BBBulletin *bulletinCopy = [bulletin copy];
            BBContent *contentCopy = [bulletin.content copy];

            contentCopy.message = messageData.message;
            contentCopy.subtitle = messageData.subtitle;
            bulletin.attachments = messageData.attachments;
            
            bulletinCopy.content = contentCopy;
            bulletin = bulletinCopy;
        }

        [lock unlock];
        NSLog(@"Lock released: restoreBulletinContent()");
        
        return bulletin;
    }
}

%hook BBBulletin

-(id)initWithCoder:(id)coder
{
    if (isEnabled() && (hiddenOnHomescreen() || allHidden())){
        self = %orig();

        if (!allHidden())
            addToDict(self);
        
        if (isMobileMail([self sectionID])){
            [self setMessage: @" "];
            [self setSubtitle: notificationText()];
            [self setAttachments: Nil];
        } else if (isHiddenIdentifier([self sectionID])){
            [self setMessage: notificationText()];
            [self setAttachments: Nil];
        }
        return self;

    } else
        return %orig();
}

%end

%hook SBLockScreenNotificationListController

- (void)observer:(id)arg1 addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3
{
    if (isEnabled()){
        if (hiddenOnHomescreen() && !hiddenOnLockscreen())
            bulletin = restoreBulletinContent(bulletin);
        else if (hiddenOnLockscreen() && !allHidden())
            bulletin = hideBulletinContent(bulletin);
    }
    %orig();
}

%end

%hook SBNotificationsAllModeBulletinInfo

-(id)_secondaryText
{
    @autoreleasepool {
        if (isEnabled()){
            [lock lock];
            NSLog(@"Lock obtained: _secondaryText");

            MessageData *messageData = [identifierForMsgData objectForKey: [self identifier]];

            if (hiddenOnHomescreen() && !hiddenInNotifcenter()){
                NSString *message;

                if (messageData)
                    message = messageData.message;
                else
                    message = %orig;

                [lock unlock];
                NSLog(@"Lock released: _secondaryText");

                return message;
            } else if (hiddenInNotifcenter() && !allHidden() && isHiddenIdentifier(messageData.sectionID)){
                [lock unlock];
                return notificationText();
            } else {
                [lock unlock];
                return %orig;
            }
        } else
            return %orig;
    }
}

-(id)_subtitleText
{
    @autoreleasepool {
        if (isEnabled()){
            [lock lock];
            NSLog(@"Lock obtained: _subtitleText");
            
            MessageData *messageData = [identifierForMsgData objectForKey: [self identifier]];

            if (hiddenOnHomescreen() && !hiddenInNotifcenter()){
                NSString *subtitle;

                if (messageData)
                    subtitle = messageData.subtitle;
                else
                    subtitle = %orig;
                
                [lock unlock];
                NSLog(@"Lock released: _subtitleText");

                return subtitle;
            } else if (hiddenInNotifcenter() && !allHidden()){
                if (isMobileMail(messageData.sectionID)){
                    [lock unlock];
                    return notificationText();
                }
                else if (isHiddenIdentifier(messageData.sectionID)){
                    [lock unlock];
                    return Nil;
                } else
                    return %orig;
            } else
                return %orig;
        } else
            return %orig;
    }
}

-(id)_attachmentImageToDisplay
{
    [lock lock];
    NSLog(@"Lock obtained: _attachmentImageToDisplay");
    
    MessageData *messageData = [identifierForMsgData objectForKey: [self identifier]];
    BBAttachments *attachments = messageData.attachments;
    
    for (id object in attachments.clientSideComposedImageInfos)
        NSLog(@"Object description: %@", [object description]);

    [lock unlock];
    NSLog(@"Lock released: _attachmentImageToDiplay");

    return %orig();
}

%end

%hook SBNotificationsAllModeViewController

- (void)commitRemovalOfBulletin:(SBNotificationsAllModeBulletinInfo*)info fromSection:(id)arg2
{
    if (isEnabled()){
        NSLog(@"METHOD 3");
        
        [lock lock];
        NSLog(@"Lock obtained: commitRemovalOfBulletin");

        [identifierForMsgData removeObjectForKey: [info identifier]];
        
        [lock unlock];
        
        NSLog(@"Lock released: commitRemovalOfBulletin");
    }
    
    %orig();
}

%end

%ctor
{
    constructor();
}
