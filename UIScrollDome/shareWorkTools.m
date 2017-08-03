//
//  shareWorkTools.m
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "shareWorkTools.h"

@implementation shareWorkTools

+(instancetype)shareWorkTools
{
    //声明静态属性
    static shareWorkTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //baseurl
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        tools = [[self alloc]initWithBaseURL:url sessionConfiguration:config];
        
        // 设置能够解析的 JSON 格式
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

    });
    //返回单例对象-执行下载
    return tools;
}
@end
