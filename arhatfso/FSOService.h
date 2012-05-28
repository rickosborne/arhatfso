//
//  FSOService.h
//  arhatfso
//
//  Created by rosborne on 5/27/12.
//

#import <Foundation/Foundation.h>

@interface FSOService : NSObject

+ (FSOService *)defaultService;

- (void)authenticateUser:(NSString *) username withPassword:(NSString *) password withTarget:(id)target onSuccess:(NSString *)success onFailure:(NSString *)failure;

@end
