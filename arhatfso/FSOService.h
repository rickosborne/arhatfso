//
//  FSOService.h
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import <Foundation/Foundation.h>
#import "FSOAuthenticator.h"

@protocol FSOLogInListener <NSObject>

- (void)fsoUserDidAuthenticate; // first
- (void)fsoUserDidLoadMainProfile; // second
- (void)fsoUserDidLoadPhoto; // third
- (void)fsoUserDidLoadContactInfo; // fourth
- (void)fsoUserDidLogIn; // the fifth and final call
- (void)fsoUserFailedToLogIn:(NSString *)errorMessage;

@end

@interface FSOService : NSObject <FSOAuthenticatorListener>
{
	id<FSOLogInListener> logInListener;
}

+ (FSOService *)defaultService;

- (void)logInUser:(NSString *) username withPassword:(NSString *) password withListener:(id)listener;

@end
