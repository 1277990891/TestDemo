//
//  BaseViewController.m
//  ConfigTest
//
//  Created by li bo on 04/12/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) MBProgressHUD* hud;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
}

- (void)showHUDWithText:(NSString *)text {
    [[self hud] setLabelText:text];
    [[self hud] show:YES];

    [self.navigationController.view addSubview:[self hud]];
}

- (void)dismissHUD {
    [[self hud] hide:YES afterDelay:0.0f];
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }

    return _hud;
}

 

@end
