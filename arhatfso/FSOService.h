//
//  FSOService.h
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import <Foundation/Foundation.h>

@protocol FSOAuthenticationRecipient <NSObject>

- (void)fsoUserDidAuthenticate;
- (void)fsoUserFailedAuthentication:(NSString *)errorMessage;

@end

@interface FSOService : NSObject

+ (FSOService *)defaultService;

- (void)authenticateUser:(NSString *) username withPassword:(NSString *) password withRecipient:(id)recipient;

@end
