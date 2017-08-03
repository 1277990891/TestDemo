//
//  ZBNewsModel.m
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNewsModel.h"
#import "shareWorkTools.h"
@implementation ZBNewsModel

+(instancetype)newsWithDict:(NSDictionary*)dict
{
    //实例化对象
    id obj = [[self alloc]init];
    NSArray *arr = @[@"title",@"imgsrc"];
    //可以随时增添属性...
    
    for (NSString *str in arr)
    {
        if(dict[str] != nil)
        {
            [obj setValue:dict[str] forKey:str];
        }
    }
      return obj;
}
/**
 *  懒加载---返回一个属性数组headerLine(接口),在赋值给控制器的属性数组.....
 */
+(void)headerLineWithcomplete:(void(^)(NSArray *))complete
{
    //提前判断条件是否符合----
    NSAssert(complete != nil, @"请从控制器中传递参数....");
    //利用单例下载
    [[shareWorkTools shareWorkTools]GET:@"ad/headline/0-4.html" parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        //输出get获取的数组数据//responseObject 为一个字典格式

        NSLog(@"=====%@",responseObject);
        //获取字典对应的数组
        NSArray *arr = responseObject[responseObject.keyEnumerator.nextObject];
        
        //把字典中数据加到数组中
//        NSArray *arr = responseObject[@"headline_ad"];
        
        //字典转模型
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in arr)
        {
            [arrM addObject:[self newsWithDict:dict]];
        }
#pragma 将模型数组中的数据保存到代码块中...
        complete(arrM.copy);
        
        NSLog(@"%@",arrM);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
