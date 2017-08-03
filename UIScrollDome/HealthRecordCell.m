//
//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HealthRecordCell.h"
#import "DetailModel.h"
@interface HealthRecordCell()
{
    UILabel *nameLbl;
    UILabel *introLbl;
    UILabel *testLbl;
    UILabel *uploadLbl;
    UIButton *detailBtn;
}
@end
@implementation HealthRecordCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        {
            [self initDetailCell];
        }
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initDetailCell];
    }
    return self;
}

#pragma mark ------重用cell类方法
+(instancetype)recordCellWithTableView:(UITableView *)tableView
{
   static NSString *ID = @"friendCell";
    HealthRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil)
    {
        cell = [[HealthRecordCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)initDetailCell
{
    nameLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLbl.font = [UIFont systemFontOfSize:13];
    introLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    introLbl.font = [UIFont systemFontOfSize:13];

    testLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    testLbl.font = [UIFont systemFontOfSize:13];

    uploadLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    uploadLbl.font = [UIFont systemFontOfSize:13];

    detailBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    detailBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:nameLbl];
    [self.contentView addSubview:introLbl];
    [self.contentView addSubview:testLbl];
    [self.contentView addSubview:uploadLbl];
    [self.contentView addSubview:detailBtn];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    nameLbl.frame = CGRectMake(15, 10, self.frame.size.width, self.frame.size.height/4);
    introLbl.frame = CGRectMake(15, 15+self.frame.size.height/4, self.frame.size.width, self.frame.size.height/4);
    testLbl.frame = CGRectMake(15, 15+self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/4);
    uploadLbl.frame = CGRectMake(self.frame.size.width/2+10, 15+self.frame.size.height/2, self.frame.size.width-10, self.frame.size.height/4);
    
    detailBtn.frame = CGRectMake(self.frame.size.width-40, 20, 20, 20);

}
#pragma mark ----设置数据
-(void)setDetailModel:(DetailModel *)detailModel
{
    _detailModel = detailModel;
    
    //1.设置icon数据
    self.imageView.image = [UIImage imageNamed:@""];
     //2.设置name
    nameLbl.text = [NSString stringWithFormat:@"姓名：%@",detailModel.name];
    //3.设置intro
    introLbl.text =[NSString stringWithFormat:@"机构：%@", detailModel.orgname];
    testLbl.text = [NSString stringWithFormat:@"日期：%@",detailModel.checkintime];
    uploadLbl.text = [NSString stringWithFormat:@"完成日期：%@",detailModel.uploadtime];
    
}

@end
