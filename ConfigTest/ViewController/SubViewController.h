//
//  SubViewController.h
//  ConfigTest
//
//  Created by li bo on 11/22/17.
//  Copyright © 2017 li bo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    NGUserAccount0,
    NGUserAccount1,
    NGUserAccount2
} NGUserAccount;


@interface SubViewController : BaseViewController

@property (nonatomic, strong) NSModel* model;

@property (nonatomic, assign) NGUserAccount userIndex;

@end
