#import <Foundation/Foundation.h>
#import "Headers/Headers.h"

@implementation MessageData : NSObject
    
-(id)initWithMessage:(NSString*)message subtitle:(NSString*)subtitle attachments:(BBAttachments*)attachments sectionID:(NSString*)sectionID
{
    self = [super init];
    if (self){
        _message = message;
        _subtitle = subtitle;
        _attachments = attachments;
        _sectionID = sectionID;
    }
    return self;
}

@end