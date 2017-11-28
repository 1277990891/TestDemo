//
//  MBProgressHUD+CZ.h
//
//  Created by 刘天源 on 14/11/4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CZ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
