//
//  HMMainViewController.h
//  网易新闻
//
//  Created by apple on 14-7-25.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMainViewController : UIViewController
#define HMNavShowAnimDuration 0.25
#define HMCoverTag 100
#define HMLeftMenuW 150
#define HMLeftMenuH  [UIScreen mainScreen].bounds.size.height
#define HMLeftMenuY 50
// 颜色
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HMColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define HMRandomColor HMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@end
