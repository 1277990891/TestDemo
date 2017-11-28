//
//  NGBackendClient.m
//  Galaxy
//
//  Created by Roman Kapshuk on 17/12/13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "NGBackendClient.h"
#import "NGRequestWrapper.h"
#import "NGBackendRequestOperation.h"


//--

static NSString* const NGAccessIsDeniedErrorMessage = @"Access is denied";

NSString* const NGBackendClientAppVersionDeprecatedNotification = @"NGBackendClientAppVersionDeprecatedNotification";
NSString* const NGBackendClientSessionTokenHasExpiredNotification = @"NGBackendClientSessionTokenHasExpiredNotification";

//--

@interface NGBackendClient ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation NGBackendClient

- (id)initWithBaseURL:(NSURL*)url
{
    if (nil != (self = [super initWithBaseURL:url]))
    {
        self.queue = dispatch_queue_create("com.netpulse.httpclient.low", DISPATCH_QUEUE_SERIAL);
#if NG_ENABLE_INVALID_CERTIFICATE
        self.allowsInvalidSSLCertificate = YES;
#endif
    }
    return self;
}

- (AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSURLRequest*)urlRequest
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    return [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure authenticationIterationCount:0];
}

- (AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSURLRequest*)urlRequest
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure authenticationIterationCount:(NSUInteger)authenticationIterationCount
{
    __weak __typeof(self) weakSelf = self;

    AFHTTPRequestOperation* operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        if ([error.domain isEqualToString:NGBackendErrorDomain] && error.code == NGAppVersionDeprecated)
        {
            [[strongSelf.operationQueue operations] makeObjectsPerformSelector:@selector(cancel)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NGBackendClientAppVersionDeprecatedNotification object:strongSelf];
        }
        else if ([error.domain isEqualToString:NGBackendErrorDomain] && error.code == NGAccessDenied && authenticationIterationCount < 1)
        {
            dispatch_async(strongSelf.queue, ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;

                NSLog(@"Recieved error response for request: %@\n%@", operation.request.URL, error);

                if ([[NGRequestWrapper sharedInstance] sessionToken] == nil || [[[NGRequestWrapper sharedInstance] sessionToken] isEqualToString:[[[operation request] allHTTPHeaderFields] objectForKey:@"Cookie"]])
                {
                    NSDictionary* analyticsProperties = @{@"URL Path": SAFE_GET_STRING(operation.request.URL.path)};

                    [[NGRequestWrapper sharedInstance] setSessionToken:nil];

                    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

                    void (^ successBlock)(id, NSString*, NSDictionary*) = ^void (id responseObject, NSString* cookie, NSDictionary* statusDescription){
                        __strong __typeof(weakSelf) strongSelf = weakSelf;

                        [[KeychainItemWrapper sessionTokenItem] setObject:cookie forKey:(__bridge id)(kSecValueData)];
                        [[NGRequestWrapper sharedInstance] setSessionToken:cookie];
                        dispatch_semaphore_signal(semaphore);

                        NSMutableURLRequest* request = [operation.request mutableCopy];
                        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
                        AFHTTPRequestOperation* requestOperation = [strongSelf HTTPRequestOperationWithRequest:request success:success failure:failure authenticationIterationCount:(authenticationIterationCount + 1)];
                        [strongSelf enqueueHTTPRequestOperation:requestOperation];
                    };

                    void (^ failBlock)(NSError*) = ^void (NSError* error){
                        __strong __typeof(weakSelf) strongSelf = weakSelf;

                        dispatch_semaphore_signal(semaphore);

                        failure(operation, error);

                        if ([error.domain isEqualToString:NGBackendErrorDomain])
                        {
                            NSInteger code = [error.userInfo[NGBackendResponseErrorCodeKey] integerValue];

                            if (code == 300 || code == 400 || code == 401 || code == 403)
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:NGBackendClientSessionTokenHasExpiredNotification object:strongSelf];
                            }
                        }
                    };

                    if (nil == strongSelf.guestUUID)
                    {
                        //Regular user
                        [[NGRequestWrapper sharedInstance] signInWithUsername:strongSelf.userName password:strongSelf.password success:^(id responseObject, NSString* cookie, NSDictionary* statusDescription) {
                            successBlock(responseObject, cookie, statusDescription);
                        } failure:^(NSError* error) {
                            failBlock(error);
                        }];
                    }

                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                }
                else
                {
                    NSMutableURLRequest* request = [operation.request mutableCopy];
                    [request setValue:[[NGRequestWrapper sharedInstance] sessionToken] forHTTPHeaderField:@"Cookie"];
                    AFHTTPRequestOperation* requestOperation = [strongSelf HTTPRequestOperationWithRequest:request success:success failure:failure authenticationIterationCount:authenticationIterationCount];
                    [strongSelf enqueueHTTPRequestOperation:requestOperation];
                }
            });
        }
        else
        {
            failure(operation, error);
        }
    }];

    return operation;
}

@end
