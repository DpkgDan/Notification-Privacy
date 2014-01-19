#import <Preferences/Preferences.h>

@interface NotificationPrivacyPreferencesListController: PSListController {
}
-(id)specifiers;
-(void)openPaypalLink:(id)param;

@end

@interface PrivacyOptionsListController : PSListController {
}
-(id)specifiers;

@end


@implementation NotificationPrivacyPreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"NotificationPrivacyPreferences" target:self];
	}
	return _specifiers;
}

-(void)openPaypalLink:(id)param
{
	 [[UIApplication sharedApplication] openURL:[NSURL URLWithString: 
	 @"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=RZR4L777XGYF2&lc=US&item_name=DpkgDan&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"]];
}

@end

@implementation PrivacyOptionsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"PrivacyOptions" target:self];
	}
	return _specifiers;
}

@end

// vim:ft=objc
