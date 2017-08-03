//
//  chanal.m
//  32-网易新闻
//
//  Created by apple on 15-4-22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "chanal.h"

@implementation chanal


//创建标题对象
+(instancetype)channelWithDict:(NSDictionary *)dict
{
    id  obj = [[self alloc]init];
   
    NSArray *array = [self properties];
    [array enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
    }];

    return obj;
}

//把频道加入数组
+(NSArray *)channels
{
    //合成一句
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"topic_news.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //反序列化
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
   // 将字典中嵌套的数组赋值给arr;;
    NSArray *arr = dict[@"tList"];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];
//    for (NSDictionary *dict in arr)
//    {
//        //加数组中的每个字典的"tname"  "tid"属性加到arrM
//        [arrM addObject:[self channelWithDict:dict]];
//        NSLog(@"%@",arrM);
//    }

    // 功能同上-遍历数组
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arrM addObject:[self channelWithDict:obj]];
    }];
    NSLog(@"%@",arrM);
    
    //按照"tid"属性值排序  先将obj 的类型改为 chanal !!!!
    return [arrM sortedArrayUsingComparator:^NSComparisonResult(chanal *obj1, chanal *obj2) {
        //升序排列
        return [obj1.tid compare: obj2.tid];
    }];

}

/**
 *  根据需要的 tid 加载模型数组中新的数据
 */
-(void)setTid:(NSString *)tid
{
    _tid = tid.copy;
    
    _urlString = [NSString stringWithFormat:@"article/headline/%@/0-20.html", tid];
}

+ (NSArray *)properties {
    return @[@"tname", @"tid"];
}
@end
