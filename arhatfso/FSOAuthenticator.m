//
//  FSOAuthenticator.m
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import "FSOAuthenticator.h"
#import "Foundation/Foundation.h"

@implementation FSOAuthenticator

const float FSOAUTH_TIMEOUT       = 10.0f;
const int FSOAUTH_CODE_CHALLENGED = 400;
const int FSOAUTH_CODE_LOST       = 300;
const int FSOAUTH_CODE_NOCONN     = 86;
const NSString *FSOAUTH_ERROR_CHALLENGED = @"HTTP authentication required";
const NSString *FSOAUTH_ERROR_LOST = @"Authentication uncertain";
const NSString *FSOAUTH_ERROR_NOCONN = @"Connection failed";
const NSString *FSOAUTH_DOMAIN     = @"FSO Authentication";
const NSString *FSOAUTH_URL_TARGET = @"http://portal.online.fullsail.edu/index.cfm?fuseaction=auth.loginProcess";
const NSString *FSOAUTH_URL_SUCCESS = @"http://portal.online.fullsail.edu/index.cfm?fuseaction=home.main";

- (void)sendFailure:(int)code withMessage:(const NSString *)message
{
	[_listener fsoAuthenticationDidFail:[NSError errorWithDomain:(NSString *)FSOAUTH_DOMAIN code:code userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:message, nil] forKeys:[NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil]]]];	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"didReceiveData:%d bytes", data.length);
	[_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"didReceiveResponse:%@", response);
	_data = [NSMutableData dataWithLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"connectionDidFinishLoading:%@", connection);
	[self sendFailure:FSOAUTH_CODE_LOST	withMessage:FSOAUTH_ERROR_LOST];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	[challenge.sender cancelAuthenticationChallenge:challenge];
	[self sendFailure:FSOAUTH_CODE_CHALLENGED withMessage:FSOAUTH_ERROR_CHALLENGED];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[_listener fsoAuthenticationDidFail:error];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
	NSLog(@"willSendRequest:%@ redirectResponse:%@", request, response);
	if (response)
	{
		[connection cancel];
		if ([request.URL.absoluteString isEqualToString:(NSString*)FSOAUTH_URL_SUCCESS])
		{
			NSLog(@"success:%@", request.URL.absoluteString);
			[_listener fsoAuthenticationDidSucceed];
		}
		else
		{
			NSLog(@"failure:%@", request.URL.absoluteString);
			[self sendFailure:FSOAUTH_CODE_LOST	withMessage:FSOAUTH_ERROR_LOST];
		}
		return nil;
	}
	return request;
}

- (NSString *)encodeString:(NSString *)string
{
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

- (id)initWithUser:(NSString *)username
	  withPassword:(NSString *)password
	  withListener:(id<FSOAuthenticatorListener>)listener
{
	if ((self = [super init]))
	{
		_listener = listener;
		_data = [NSMutableData dataWithLength:0];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:(NSString *)FSOAUTH_URL_TARGET] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:FSOAUTH_TIMEOUT];
		[request setHTTPMethod:@"POST"];
		NSString *postData = [NSString stringWithFormat:@"j_username=%@&j_password=%@", [self encodeString:username], [self encodeString:password]];
		[request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
		NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
		if (conn)
		{
			[conn start];
		}
		else
		{
			[self sendFailure:FSOAUTH_CODE_NOCONN withMessage:FSOAUTH_ERROR_NOCONN];
		}
	}
	return self;
}

@end
