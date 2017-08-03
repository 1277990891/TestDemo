//
//  chanal.h
//  32-网易新闻
//
//  Created by apple on 15-4-22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chanal : NSObject
/*
  加载topic_news.json 中的数据
 */
//标题名称
@property(nonatomic,copy)NSString * tname;
//标题id
@property(nonatomic,copy)NSString * tid;
// 新加载的数据----根据tid加载
@property(nonatomic,copy)NSString * urlString;

//创建标题对象
+(instancetype)channelWithDict:(NSDictionary *)dict;

//将所有的频道加到数组中---
+(NSArray *)channels;


@end
