//
//  NGObjectFillHelper.m
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "NGObjectFillHelper.h"
#import "NSUserAccount+CoreDataProperties.h"

@implementation NGObjectFillHelper

- (void)fillProfileForUser:(NSUserAccount*)user fromResponse:(NSDictionary*)response
{
    user.uuid = SAFE_GET_OBJECT(response, @"uuid");
    user.email = SAFE_GET_OBJECT(response, @"email");
    user.password = SAFE_GET_OBJECT(response, @"password");
    user.aboutMe = SAFE_GET_OBJECT(response, @"aboutMe");
    user.firstname = SAFE_GET_OBJECT(response, @"firstname");
    user.gender = SAFE_GET_OBJECT(response, @"gender");
    user.height = SAFE_GET_OBJECT(response, @"height");
    user.weight = SAFE_GET_OBJECT(response, @"weight");
}
@end
