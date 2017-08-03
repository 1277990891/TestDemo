//
//  ZBNews.m
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNews.h"
#import <objc/runtime.h>
#import "shareWorkTools.h"
@implementation ZBNews

//类方法+对象方法----实例化对象
+(instancetype)newsWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc]init];
    
    NSArray *arr =[self addProperties];
    for (NSString *key in arr)
    {
        if (dict[key]){
        [obj setValue:dict[key] forKey:key];
        }
    }
    return obj;
}

/*
  运行时机制---:使用一个数组动态加载属性(个数),
*/
+(NSArray *)addProperties
{
    //1.遵守<obj/runtime.h>协议
    //初始化数组个数
    unsigned int count = 0;
    //返回类的属性
    objc_property_t *pros =  class_copyPropertyList([self class], &count);
     //
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:count];
    //
    for (int i = 0 ; i<count ;i++)
    {
        //遍历属性
        objc_property_t  pro = pros[i];
        //获取属性名
        const char *name = property_getName(pro);
        //把属性加到数组中
        [arrM addObject:[NSString stringWithUTF8String:name]];
    }
    //释放属性数组
    free(pros);
    
    return arrM;
}

//"懒加载"字典转模型---返回一个数组-作为block函数complete 的返回值
+(void)newsWithUrlString:(NSString *)url complete:(void(^)(NSArray * ))complete
{
    //断言
    NSAssert(complete != nil, @"参数complete不能为空");
    //利用单例下载数据
    [[shareWorkTools shareWorkTools]GET:url parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSLog(@"%@",responseObject);
        
        // keyEnumerator.nextObject  获取第一个键值对应的数组
        NSArray *arr = responseObject[responseObject.keyEnumerator.nextObject];

        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];
        //字典转模型
        for (NSDictionary *dict in arr)
        {
            //将实例化对象的属性加到数组中
            [arrM addObject:[self newsWithDict:dict]];
        }
        //保存block代码库----
        complete(arrM.copy);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return ;
    }];
    
}
@end
