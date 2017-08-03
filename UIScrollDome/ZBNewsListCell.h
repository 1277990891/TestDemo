//
//  ZBNewsListCell.h
//  32-网易新闻
//
//  Created by apple on 15-4-21.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBNews;
@interface ZBNewsListCell : UITableViewCell
//模型数组
@property (nonatomic, strong) ZBNews *news;
/**
 *  1.类方法创建cell------根据new模型中图片的数量确定哪一个可重用ID
 */
+(NSString *) cellWithidentifier:(ZBNews*)news;
/**
 *  2.分别设置不同cell的行高
 */
+(CGFloat) rowHeightForCell:(ZBNews*)news;
@end
