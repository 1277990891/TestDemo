//
//  ZBNews.h
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBNews : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 摘要
@property (nonatomic, copy) NSString *digest;
// 图片
@property (nonatomic, copy) NSString *imgsrc;
// 跟贴数
@property (nonatomic, assign) int replyCount;
// 配图个数
@property (nonatomic, strong) NSArray *imgextra;
// 大图标记?
@property (nonatomic, assign) BOOL imgType;

//类方法-
+(instancetype)newsWithDict:(NSDictionary *)dict;

//"懒加载"字典转模型---返回一个数组-作为block函数complete 的返回值
+(void)newsWithUrlString:(NSString *)url complete:(void(^)(NSArray * ))complete;
@end
