//
//  FSOAuthenticator.h
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import <Foundation/Foundation.h>

@protocol FSOAuthenticatorListener <NSObject>

- (void)fsoAuthenticationDidSucceed;
- (void)fsoAuthenticationDidFail:(NSError *)error;

@end

@interface FSOAuthenticator : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
	id<FSOAuthenticatorListener> _listener;
	NSMutableData *_data;
}


- (id)initWithUser:(NSString *)username withPassword:(NSString *)password withListener:(id<FSOAuthenticatorListener>)listener;

@end
