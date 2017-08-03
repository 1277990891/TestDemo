//
//  CZ
//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(instancetype)reportWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
