//
//  FSOService.m
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import "FSOService.h"

static FSOService *defaultService = nil;

@implementation FSOService

- (void)fsoAuthenticationDidSucceed
{
	NSLog(@"fsoAuthenticationDidSucceed");
	[logInListener fsoUserDidAuthenticate];
}

- (void)fsoAuthenticationDidFail:(NSError *)error
{
	NSLog(@"fsoAuthenticationDidFail:%@", error);
	[logInListener fsoUserFailedToLogIn:error.localizedDescription];
}

- (void)logInUser:(NSString *)username
	 withPassword:(NSString *)password
	 withListener:(id<FSOLogInListener>)listener
{
	NSLog(@"logInUser:%@", username);
	logInListener = listener;
	FSOAuthenticator *auth = [[FSOAuthenticator alloc] initWithUser:username withPassword:password withListener:self];
	auth = nil;
}

+ (FSOService *)defaultService
{
	if (!defaultService)
	{
		defaultService = (FSOService *)[[super allocWithZone:NULL] init];
	}
	return defaultService;
}

+ (id)allocWithZone:(NSZone *)zone
{
	// singleton magic
	return [self defaultService];
}

- (id)init
{
	if (defaultService)
	{
		return defaultService;
	}
	if ((self = [super init]))
	{
		// additional init magic goes here
	}
	return self;
}

@end
