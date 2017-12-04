//
//  NGRequestWrapper.m
//  Galaxy
//
//  Created by Eugene Belyakov on 16.05.13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "NGRequestWrapper.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "NGBackendRequestOperation.h"
#import "NGCascadeRequestOperation.h"
#import "NGBackendClient.h"
#import "KeychainItemWrapper.h"
#import "NGRequestEndpoints.h"
//#import "NGJSONParametersKeys.h"
//#import "NSString+NGMethods.h"
//#import "NGBackendGroupScheduleVersion.h"

NSString* const NGMethodAPIVersion = @"1.4";
NSString* const NGMethodAppVersionParameterKey = @"appVersion";

NSUInteger const NGAPNSVersion = 3;

NSString* const NGClubcomAddress = @"http://api.clubcom.com";
NSString* const NGMethodGetExerciserBarcodes= @"/np/goldsgym/v1.0/exercisers/%@/barcodes";

static NGRequestWrapper* sRequestWrapper = nil;

@interface NGRequestWrapper ()

@property (nonatomic) NSNumber* appVersion;

@property (nonatomic) NGBackendClient* httpClient;
@property (nonatomic) NGHTTPClient* clubComHttpClient;

@end

#ifdef ebelyakov_define

#warning IGNORES HTTPS CERTIFICATES

@interface NSURLRequest (Private)

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

#endif


@implementation NGRequestWrapper

+ (NGRequestWrapper*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sRequestWrapper = [[NGRequestWrapper alloc] init];
    });
    return sRequestWrapper;
}

- (id)init
{
    if (nil != (self = [super init]))
    {
        NSString* deviceUid = [[KeychainItemWrapper uniqueIdentifierItem] uniqueIdentifier];
        NSString* applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
        NSString* applicationVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString* applicationVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
        NSString* xNPUserAgent = [NSString stringWithFormat:@"clientType=MOBILE_DEVICE; devicePlatform=IOS; deviceUid=%@; applicationName=%@; applicationVersion=%@; applicationVersionCode=%@", deviceUid, applicationName, applicationVersion, applicationVersionCode];

        self.httpClient = [NGBackendClient clientWithBaseURL:[NSURL URLWithString:[self baseURL]]];
        [self.httpClient setDefaultHeader:@"X-NP-User-Agent" value:xNPUserAgent];
        [self.httpClient setDefaultHeader:@"X-NP-API-Version" value:NGMethodAPIVersion];
        [self.httpClient setDefaultHeader:@"X-NP-APP-Version" value:applicationVersion];
        [self.httpClient setDefaultHeader:@"Accept" value:@"application/json,text/plain"];
        self.httpClient.parameterEncoding = AFFormURLParameterEncoding;
        [self.httpClient registerHTTPOperationClass:[NGBackendRequestOperation class]];

        NSURL* clubComURL = [NSURL URLWithString:NGClubcomAddress];
        self.clubComHttpClient = [NGHTTPClient clientWithBaseURL:clubComURL];
        [self.clubComHttpClient setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
        [self.clubComHttpClient setDefaultHeader:@"Accept" value:@"application/json,text/plain"];
        self.clubComHttpClient.parameterEncoding = AFFormURLParameterEncoding;
        [self.clubComHttpClient registerHTTPOperationClass:[NGCascadeRequestOperation class]];

        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
#ifdef ebelyakov_define
#warning IGNORES HTTPS CERTIFICATES
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    }
    return self;
}

- (NSString*)baseURL
{
    static NSDictionary* sBrandedPlistDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* plistFileName = [[NSBundle mainBundle] pathForResource:@"Branding" ofType:@"plist"];
        sBrandedPlistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFileName];
    });

    return [sBrandedPlistDictionary valueForKeyPath:@"NetworkSettings.NGBackendAddressKey"];
}

- (NSNumber*)appVersion
{
    if (_appVersion == nil)
    {
        NSString* versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSArray* components = [versionString componentsSeparatedByString:@"."];

        NSInteger majorVersion = components.count > 0 ? [[components objectAtIndex:0] integerValue] : 0;
        NSInteger minorVersion = components.count > 1 ? [[components objectAtIndex:1] integerValue] : 0;
        NSInteger patchVersion = components.count > 2 ? [[components objectAtIndex:2] integerValue] : 0;

        NSString* appVersion = [NSString stringWithFormat:@"%ld%02ld%02ld", (long)majorVersion, (long)MIN(minorVersion, 99), (long)MIN(patchVersion, 99)];

        _appVersion = @(appVersion.integerValue);
    }
    return _appVersion;
}


- (void)setSessionToken:(NSString*)sessionToken
{
    _sessionToken = sessionToken;
    [self.httpClient setDefaultHeader:@"Cookie" value:sessionToken];
}

- (void)setAbcSessionToken:(NSString*)abcSessionToken
{
    _abcSessionToken = abcSessionToken;
}

- (AFNetworkReachabilityStatus)reachabilityStatus
{
    return [self.httpClient networkReachabilityStatus];
}

- (NSOperation*)requestCookiesWithSuccess:(NGRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock
{
    NSMutableURLRequest* request = [self.httpClient requestWithMethod:@"GET" path:NGMethodGetCookies parameters:nil];

    AFHTTPRequestOperation* operation = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation* operation, id responseObject) {

        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError* error) {
        failureBlock(error);
    }];
    [self.httpClient enqueueHTTPRequestOperation:operation];
    return operation;
}

#pragma mark Sign In / Sign Up

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock
{
    return [self signInWithUsername:username password:password newHomeClubUUID:nil memberID:nil success:successBlock failure:failureBlock];
}

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password newHomeClubUUID:(NSString*)newHomeClubUUID memberID:(NSString*)memberID success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock
{
    return [self signInWithUsername:username password:password newHomeClubUUID:newHomeClubUUID memberID:memberID checkForMessages:NO success:successBlock failure:failureBlock];
}

- (NSOperation*)signInWithUsername:(NSString*)username password:(NSString*)password newHomeClubUUID:(NSString*)newHomeClubUUID memberID:(NSString*)memberID checkForMessages:(BOOL)checkForMessages success:(NGSignInRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    SAFE_SET_OBJECT(parameters, @"username", username);
    SAFE_SET_OBJECT(parameters, @"password", password);
    SAFE_SET_OBJECT(parameters, @"newHomeClubUuid", newHomeClubUUID);
    SAFE_SET_OBJECT(parameters, @"memberId", memberID);
    SAFE_SET_OBJECT(parameters, @"checkForMessages", (checkForMessages ? @"true" : @"false"));

    NSString* path = [NSString stringWithFormat:@"%@%@",kServerRootURL, NGMethodSignIn];
#ifdef CONFIGTESTDEMO_BRANDING
    path = [NSString stringWithFormat:@"%@%@", [NSURL URLWithString:NG_BACKEND_ADDRESS_DEFINE], NGMethodStandardSignIn];
#endif
    NSMutableURLRequest* request = [self.httpClient requestWithMethod:@"POST" path:path parameters:parameters];

    [request setHTTPShouldHandleCookies:NO];

    __weak __typeof(self) weakSelf = self;
    AFHTTPRequestOperation* operation = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation* operation, id responseObject) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        strongSelf.httpClient.guestUUID = nil;
        strongSelf.httpClient.userName = username;
        strongSelf.httpClient.password = password;
        strongSelf.httpClient.APIType = NGBackendAPITypeLegacy;

        NSString* sessionToken = [[operation.response allHeaderFields] objectForKey:@"Set-Cookie"];
        if (sessionToken == nil)
        {
            sessionToken = strongSelf.sessionToken;
        }

        successBlock(responseObject, sessionToken, nil);
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failureBlock(error);
    }];

    [self.httpClient enqueueHTTPRequestOperation:operation];
    return operation;
}

#pragma Profile
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
                                      failure:(NGRequestFailureCompletionBlock)failureBlock
{
    NSString* path = [NSString stringWithFormat:@"%@%@", NGMethodUpdateProfile,userUUID];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    SAFE_SET_OBJECT(params, @"firstname", firstName);
    SAFE_SET_OBJECT(params, @"lastname", lastName);
    SAFE_SET_OBJECT(params, @"email", email);
    SAFE_SET_OBJECT(params, @"measurementUnit", measurementUnit);
    SAFE_SET_OBJECT(params, @"gender", gender);
    SAFE_SET_OBJECT(params, @"birthday", [dateFormatter stringFromDate:birthdayDate]);
    NSString* weightString = [NSString stringWithFormat:@"%.1f", weight.floatValue];
    SAFE_SET_OBJECT(params, @"weight", weightString);
    NSString* heightString =[NSString stringWithFormat:@"%.2f", height.floatValue];
    SAFE_SET_OBJECT(params, @"height", heightString);

    SAFE_SET_OBJECT(params, @"aboutMe", aboutMe);
    SAFE_SET_OBJECT(params, @"profilePhoto", profilePhoto);
    SAFE_SET_OBJECT(params, @"street1", street1);
    SAFE_SET_OBJECT(params, @"street2", street2);
    SAFE_SET_OBJECT(params, @"city", city);
    SAFE_SET_OBJECT(params, @"country", country);
    SAFE_SET_OBJECT(params, @"stateOrProvince", stateOrProvince);
    SAFE_SET_OBJECT(params, @"postalCode", postalCode);
    SAFE_SET_OBJECT(params, @"phoneNumber", phoneNumber);
    SAFE_SET_OBJECT(params, @"clientLoginId", clientLoginId);
    SAFE_SET_OBJECT(params, @"picturePassword", picturePassword);
    SAFE_SET_OBJECT(params, @"privacy", privacy);
    SAFE_SET_OBJECT(params, @"timezone", timeZone);
    SAFE_SET_OBJECT(params, @"homeClub", homeClubUUID);
    SAFE_SET_OBJECT(params, @"newPasscode", passcode);
    SAFE_SET_OBJECT(params, @"confirmPasscode", passcode);
    SAFE_SET_OBJECT(params, @"oldPassword", oldPassword);
    SAFE_SET_OBJECT(params, @"newPassword", newPassword);
    SAFE_SET_OBJECT(params, @"confirmPassword", confirmPassword);
    
    if (nil != passcode)
    {
        params[@"firstTimeUser"] = @YES;
    }
    
    NSMutableURLRequest* request = [self.httpClient requestWithMethod:@"PUT" path:path parameters:params];
    if (nil != passcode)
    {
        [request setHTTPShouldHandleCookies:NO];
    }
    
    AFHTTPRequestOperation* requestOperation = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation* operation, id responseObject) {
        self.httpClient.password = newPassword;
        successBlock(responseObject, [[operation.response allHeaderFields] objectForKey:@"Set-Cookie"], nil);
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failureBlock(error);
    }];
    
    [self.httpClient enqueueHTTPRequestOperation:requestOperation];
    
    return requestOperation;
}

- (NSOperation*)loadUserProfileWithUserUUID:(NSString*)userUUID successBlock:(NGRequestSuccessCompletionBlock)successBlock failure:(NGRequestFailureCompletionBlock)failureBlock
{
    NSString* path = [NSString stringWithFormat:NGMethodGetProfile, userUUID];
    return [self.httpClient getRequestWithPath:path parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failureBlock(error);
    }];
}

@end
