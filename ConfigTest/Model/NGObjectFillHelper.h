//
//  NGObjectFillHelper.h
//  ConfigTest
//
//  Created by li bo on 30/11/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSUserAccount;

@interface NGObjectFillHelper : NSObject

- (void)fillProfileForUser:(NSUserAccount*)user fromResponse:(NSDictionary*)response;

@end
