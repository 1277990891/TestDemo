//
//  ZBNewsListController.h
//  32-网易新闻
//
//  Created by apple on 15-4-21.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBNewsListController : UITableViewController

/**
 *  1.从频道总获取urlString对应的数据
 */
@property(nonatomic,copy)NSString * urlString;

@end
