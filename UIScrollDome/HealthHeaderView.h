//

//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordCell.h"
#import "GroupModel.h"


@class GroupModel;
@class HealthHeaderView;
//协议
@protocol HeaderViewDelegate <NSObject>
-(void)HeaderViewClick:(HealthHeaderView *)friendHeaderView;


@end
@interface HealthHeaderView : UITableViewHeaderFooterView
//模型
@property(nonatomic,strong)GroupModel *group;

//创建HeaderView
+(instancetype)friendHeaderViewWithTableView:(UITableView *)tableView;
@property(nonatomic,weak) id<HeaderViewDelegate> delegate;
@end
