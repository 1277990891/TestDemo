//
//  NGRequestWrapper.h
//  Galaxy
//
//  Created by Eugene Belyakov on 16.05.13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NGBackendClient.h"

typedef void (^ NGSignInRequestSuccessCompletionBlock)(id responseObject, NSString* cookie, NSDictionary* statusDescription);
typedef void (^ NGABCSignInRequestSuccessCompletionBlock)(NSString* cookie);
typedef void (^ NGRequestSuccessCompletionBlock)(id responseObject);
typedef void (^ NGRequestFailureCompletionBlock)(NSError* error);

 
@interface NGRequestWrapper : NSObject

@property (nonatomic, strong) NSString* sessionToken;
@property (nonatomic, strong) NSString* abcSessionToken;
@property (nonatomic, readonly) NSString* baseURL;
@property (nonatomic, readonly) NSString* accountLinkingRedirectPrefix;
@property (nonatomic, readonly) NGBackendClient* httpClient;

+ (NGRequestWrapper*)sharedInstance;


#pragma mark - Reachability

- (AFNetworkReachabilityStatus)reachabilityStatus;


- (NSOperation*)requestCookiesWithSuccess:(NGRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock;;

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock;

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password newHomeClubUUID:(NSString*)newHomeClubUUID memberID:(NSString*)memberID success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock;

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password newHomeClubUUID:(NSString*)newHomeClubUUID memberID:(NSString*)memberID checkForMessages:(BOOL)checkForMessages success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock;

@end
