//
//  NGBackendClient.h
//  Galaxy
//
//  Created by Roman Kapshuk on 17/12/13.
//  Copyright (c) 2013 Netpulse. All rights reserved.
//

#import "NGHTTPClient.h"

typedef NS_ENUM(NSUInteger, NGBackendAPIType)
{
    NGBackendAPITypeLegacy = 0,
    NGBackendAPITypeStandard
};

extern NSString* const NGBackendClientAppVersionDeprecatedNotification;
extern NSString* const NGBackendClientSessionTokenHasExpiredNotification;

@interface NGBackendClient : NGHTTPClient

// Identifies Regular user if present
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* password;

// Identifies Guest user if present
@property (nonatomic, strong) NSString* guestUUID;

@property (nonatomic) NGBackendAPIType APIType;

@end
