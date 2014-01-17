#import "Utilities.h"
#import "MessageData.h"

@interface BBAttachments : NSObject
    
@property(retain, nonatomic) NSMutableDictionary *clientSideComposedImageInfos;
@property(retain, nonatomic) NSCountedSet *additionalAttachments;
    
@end

@interface BBContent : NSObject <NSCopying, NSCoding>

@property(copy, nonatomic) NSString *message;
@property(copy, nonatomic) NSString *subtitle;
    
@end

@interface BBBulletin : NSObject <NSCopying, NSCoding>

@property(copy) NSString * title;
@property(copy) NSString * subtitle;
@property(copy) NSString * message;
@property(retain) BBAttachments *attachments;
@property(copy, nonatomic) NSString *bulletinID;
@property(retain, nonatomic) BBContent *content;
@property(copy, nonatomic) NSString *sectionID;

@end

@interface SBNotificationsAllModeBulletinInfo

-(NSString*)identifier;
-(NSString*)_primaryText;

@end