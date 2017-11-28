//
//  NGHTTPClient.m
//  Galaxy
//
//  Created by Eugene Belyakov on 02.07.13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "NGHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#ifdef UI_TESTING

#import "NGBackendRequestOperation.h"
#import "BSLBackendStubber.h"

@interface NGHTTPClient () <BSLBackendStubberDelegate>

@property (nonatomic) BSLBackendStubber<AFHTTPRequestOperation*>* backendStubber;

@end

@interface AFHTTPRequestOperation (UITests) <BSLBackendStubberOperationProtocol>

@end

#endif // UI_TESTING

@implementation NGHTTPClient

- (AFHTTPRequestOperation*)getRequestWithPath:(NSString*)path
    parameters:(NSDictionary*)parameters
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation*)postRequestWithPath:(NSString*)path
    parameters:(NSDictionary*)parameters
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation*)putRequestWithPath:(NSString*)path
    parameters:(NSDictionary*)parameters
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation*)multipartPostRequestWithPath:(NSString*)path
    parameters:(NSDictionary*)parameters
    data:(NSData*)data
    fileName:(NSString*)fileName
    mimeType:(NSString*)mimeType
    JSONKey:(NSString*)jsonKey
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:jsonKey fileName:fileName mimeType:mimeType];

    }];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation*)deleteRequestWithPath:(NSString*)path
    parameters:(NSDictionary*)parameters
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}


- (AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSURLRequest*)urlRequest
    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
#ifdef UNIT_TESTING
    assert(0);
#endif

#ifdef UI_TESTING
    return [self.backendStubber requestOperationWithURLRequest:urlRequest withSuccess:success failure:failure];

#else
    return [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
#endif // UI_TESTING
}

#ifdef UI_TESTING

#pragma mark - UITesting

- (BSLBackendStubber*)backendStubber
{
    if (_backendStubber == nil)
    {
        _backendStubber = [BSLBackendStubber new];
        _backendStubber.delegate = self;
        _backendStubber.cacheDirectoryPath = NG_NSSTRINGIFY(BE_RESPONSE_LIST_PATH);
    }
    return _backendStubber;
}

#pragma mark - BSLBackendStubberDelegate

- (id<BSLBackendStubberOperationProtocol>)requestOperationForBackendStubberUsingCache:(BSLBackendStubber*)stubber
{
    return [AFHTTPRequestOperation new];
}

- (id<BSLBackendStubberOperationProtocol>)requestOperationForBackendStubber:(BSLBackendStubber*)stubber usingRealBackendWithURLRequest:(NSURLRequest*)urlRequest withSuccess:(void (^)(id<BSLBackendStubberOperationProtocol> operation, id responseObject))success failure:(void (^)(id<BSLBackendStubberOperationProtocol> operation, NSError* error))failure
{
    return [super HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation* operation, id responseObject) {
        if (success != nil)
        {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (failure != nil)
        {
            failure(operation, error);
        }
    }];
}

- (NSError*)errorForBackendStubber:(BSLBackendStubber*)stubber withURLRequest:(NSURLRequest*)urlRequest urlResponse:(NSHTTPURLResponse*)urlResponse responseJSON:(NSDictionary*)responseJSON
{
    NGBackendRequestOperation* operation = [[NGBackendRequestOperation alloc] initWithRequest:urlRequest];
    [operation setValue:urlResponse forKey:@"response"];
    [operation setValue:responseJSON forKey:@"responseJSON"];
    NSError* error = operation.error;
    return error;
}

#pragma mark - Reachability

- (AFNetworkReachabilityStatus)networkReachabilityStatus
{
    if (self.backendStubber != nil)
    {
        if (self.backendStubber.simulatedNetworkReachabilityStatus == BSLBackendStubberNetworkReachabilityStatusReachableViaWiFi)
        {
            return AFNetworkReachabilityStatusReachableViaWiFi;
        }
        else
        {
            return AFNetworkReachabilityStatusNotReachable;
        }
    }
    else
    {
        return AFNetworkReachabilityStatusReachableViaWiFi;
    }
}

#endif // UI_TESTING

@end
