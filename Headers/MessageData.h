#ifndef MessageData_h
#define MessageData_h

@class BBAttachments;

@interface MessageData : NSObject {
    NSString *_message;
    NSString *_subtitle;
    BBAttachments *_attachments;
    NSString *_sectionID;
}
    
@property (readonly) NSString *message;
@property (readonly) NSString *subtitle;
@property (readonly) BBAttachments *attachments;
@property (readonly) NSString *sectionID;
    
-(id)initWithMessage:(NSString*)message subtitle:(NSString*)subtitle attachments:(BBAttachments*)attachments sectionID:(NSString*)sectionID;
    
@end

#endif