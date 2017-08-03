//
//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"
@class DetailModel;
@interface GroupModel : NSObject
// 分组名称
@property(nonatomic,copy)NSString *name;

// 是否展开列表
@property(nonatomic,assign,getter=isShow)BOOL show;

// 数据模型
@property(nonatomic,strong)NSArray *detailArray;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)groupWithDict:(NSDictionary *)dict;

@end
