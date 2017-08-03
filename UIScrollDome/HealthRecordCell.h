//

//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthHeaderView.h"
#import "DetailModel.h"
@class DetailModel;
@interface HealthRecordCell : UITableViewCell


//数据模型---设置cell数据
@property(nonatomic,strong)DetailModel *detailModel;


+(instancetype)recordCellWithTableView:(UITableView *)tableView;

@end
