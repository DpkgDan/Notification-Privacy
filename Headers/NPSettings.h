#import <Foundation/Foundation.h>
#import <libactivator/libactivator.h> 
#import "Headers.h"

@interface NPSettings : NSObject <LAListener> {
	NSString *_notificationText;
	NSMutableDictionary *_preferenceFile;
		
	BOOL _isEnabled;
	BOOL _hiddenOnLockscreen;
	BOOL _hiddenOnHomescreen;
	BOOL _hiddenInNotifcenter;
	BOOL _titleHidden;
	BOOL _removedFromLockscreen;
}

@property (readonly) NSString * notificationText;
@property (readonly) BOOL isEnabled;
@property (readonly) BOOL hiddenOnLockscreen;
@property (readonly) BOOL hiddenOnHomescreen;
@property (readonly) BOOL hiddenInNotifcenter;
@property (readonly) BOOL titleHidden;
@property (readonly) BOOL removedFromLockscreen;

+(id)sharedInstance;
-(BOOL)isHiddenIdentifier:(NSString*)identifier;
-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event;
-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event;

@end