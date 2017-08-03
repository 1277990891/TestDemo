//

//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property(nonatomic,copy)NSString * name;//姓名
@property(nonatomic,copy)NSString * orgname;//机构
@property(nonatomic,copy)NSString * checkintime;//体检日期
@property(nonatomic,copy)NSString * uploadtime;// 时间


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)reportWithDict:(NSDictionary *)dict;

@end
