#import "NPSettings.h"

@class BBObserver;

@interface BBBulletin : NSObject <NSCopying, NSCoding>

@property(copy, nonatomic) NSString *sectionID;

+(BBBulletin*)copyCachedBulletinWithBulletinID:(NSString*)bulletinID;

@end

@interface BBAction

+(BBAction*)action;

@end

@interface BBBulletinRequest : NSObject

@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *message;
@property(copy, nonatomic) NSString *sectionID;
@property(copy, nonatomic) BBAction *defaultAction;

@end

@interface SBBulletinBannerController

+(id)sharedInstance;
-(void)observer:(BBObserver*)observer addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)feed;
-(void)_dismissIntervalElapsed;

@end

@interface SBBulletinBannerItem

-(BBBulletin*)seedBulletin;
-(NSString*)sectionID;
-(BOOL)shouldHideBulletin;

@end

@interface SBAwayBulletinListItem

-(NSArray*)bulletins;
-(NSString*)sectionID;
-(BOOL)shouldHideBulletin;

@end

@interface SBNotificationsBulletinInfo

-(NSString*)identifier;
-(NSString*)sectionID;
-(BOOL)shouldHideBulletin;

@end