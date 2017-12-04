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

// save profile
- (NSOperation*)updateUserProfileWithUserUUID:(NSString*)userUUID
                                    firstName:(NSString*)firstName
                                     lastName:(NSString*)lastName
                                        email:(NSString*)email
                              measurementUnit:(NSString*)measurementUnit
                                       gender:(NSString*)gender
                                     birthday:(NSDate*)birthdayDate
                                       weight:(NSNumber*)weight
                                       height:(NSNumber*)height
                                      aboutMe:(NSString*)aboutMe
                                     homeClub:(NSString*)homeClubUUID
                                 profilePhoto:(NSString*)profilePhoto
                                      street1:(NSString*)street1
                                      street2:(NSString*)street2
                                         city:(NSString*)city
                                      country:(NSString*)country
                              stateOrProvince:(NSString*)stateOrProvince
                                   postalCode:(NSString*)postalCode
                                  phoneNumber:(NSString*)phoneNumber
                                clientLoginId:(NSString*)clientLoginId
                              picturePassword:(NSNumber*)picturePassword
                                      privacy:(NSString*)privacy
                                     timezone:(NSString*)timeZone
                                     passcode:(NSString*)passcode
                                  oldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                              confirmPassword:(NSString*)confirmPassword
                                 successBlock:(NGSignInRequestSuccessCompletionBlock)successBlock
                                      failure:(NGRequestFailureCompletionBlock)failureBlock;

- (NSOperation*)loadUserProfileWithUserUUID:(NSString*)userUUID successBlock:(NGRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock;

@end
