//
//  ZBNewsModel.h
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBNewsModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * imgsrc;
/**
 *  字典转模型
 */
+(instancetype)newsWithDict:(NSDictionary*)dict;
/**
 *  下载模型数据---在返回一个属性数组headerLine(接口),赋值给控制器的属性数组.....
 */
// 新闻轮播图和title
+(void)headerLineWithcomplete:(void(^)(NSArray *))complete;
@end
