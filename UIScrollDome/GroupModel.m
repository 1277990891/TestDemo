//
//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "GroupModel.h"
#import "DetailModel.h"
@implementation GroupModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        
        //把Group数组中detailarray数组中的字典转为模型
        NSMutableArray *detailGroup = [NSMutableArray array ];
        for (NSDictionary *subDict in self.detailArray)
        {
            DetailModel *detail = [DetailModel reportWithDict:subDict];
            [detailGroup addObject:detail];
            
        }
        self.detailArray = detailGroup;
    }
    return self;
}
+(instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
