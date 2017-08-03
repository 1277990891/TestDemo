//
//  shareWorkTools.h
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface shareWorkTools : AFHTTPSessionManager
/**
 *  单例--赋值所有下载,继承AFHTTPSessionManager 执行下载
 */
+(instancetype)shareWorkTools;
@end
