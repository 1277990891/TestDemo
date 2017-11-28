//
//  NGHTTPClient.h
//  Galaxy
//
//  Created by Eugene Belyakov on 02.07.13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "AFHTTPClient.h"

@interface NGHTTPClient : AFHTTPClient

- (AFHTTPRequestOperation*)getRequestWithPath:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

- (AFHTTPRequestOperation*)postRequestWithPath:(NSString *)path
                                    parameters:(NSDictionary *)parameters
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

- (AFHTTPRequestOperation*)putRequestWithPath:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

- (AFHTTPRequestOperation*)deleteRequestWithPath:(NSString *)path
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

- (AFHTTPRequestOperation*)multipartPostRequestWithPath:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                                                   data:(NSData*)data
                                               fileName:(NSString*)fileName
                                               mimeType:(NSString*)mimeType
                                                JSONKey:(NSString*)jsonKey
                                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

@end
