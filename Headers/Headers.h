#import "Utilities.h"

@interface BBBulletin : NSObject <NSCopying, NSCoding>

@property(copy, nonatomic) NSString *sectionID;

+(BBBulletin*)copyCachedBulletinWithBulletinID:(NSString*)bulletinID;

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