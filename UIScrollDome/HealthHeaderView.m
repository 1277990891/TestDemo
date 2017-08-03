//

//
//  Created by apple on 15-3-6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HealthHeaderView.h"
#import "GroupModel.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface HealthHeaderView ()

// 点击按钮
@property(nonatomic,weak)UIButton *btnTitle;

//显示好友数量
@property(nonatomic,weak)UILabel *lblCount;
@end
@implementation HealthHeaderView


#pragma mark------------封装创建HeaderView的类方法---;
+(instancetype)friendHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"headerView";
    HealthHeaderView *headerView = (HealthHeaderView*)[tableView dequeueReusableCellWithIdentifier:ID];
    if (headerView == nil)
    {
        //HeaderView则创建并初始化
        headerView = [[HealthHeaderView alloc]initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    //如果没有重用headerView,则创建,并初始化
    if (self =[super initWithReuseIdentifier:reuseIdentifier])
    {
        UIButton *btnTitle = [[UIButton alloc]init];
        //设置按钮的背景图
        [btnTitle setBackgroundColor:[UIColor whiteColor]];
        //设置"三角"标志
        [btnTitle setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        btnTitle.adjustsImageWhenHighlighted = NO;
        //设置按钮左对齐
        btnTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置按钮左面有个边距
        btnTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置"三角"与组名有个间距
        btnTitle.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        btnTitle.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth-60, 0, 0);
        //设置按钮文字大小
        btnTitle.titleLabel.font = [UIFont systemFontOfSize:16];
        //按钮//组名文字的颜色
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //点击事件--被点击是调用自己的btnClick方法;
        [btnTitle addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //设置btn中的"三角"不被拉伸截取
        btnTitle.imageView.clipsToBounds = NO;
        
        [self.contentView addSubview:btnTitle];
        self.btnTitle = btnTitle;
        
        /**
          创建在线人数lbl
         */
        UILabel *lblCount = [[UILabel alloc]init];
        //label右对齐
        lblCount.textAlignment = NSTextAlignmentRight;
        //label的颜色
        lblCount.textColor = [UIColor grayColor];
        //label的文字大小
        lblCount.font = [UIFont boldSystemFontOfSize:12];
        self.lblCount = lblCount;
//      [self.contentView addSubview:lblCount];
        
    }
    return self;
}

#pragma mark---headerView的子控件的数据-
-(void)setGroup:(GroupModel *)group
{
    _group = group;
    
    //设置分组名称
    [self.btnTitle setTitle:group.name forState:UIControlStateNormal];
    
    //三角图标
    if(group.isShow)
        {
        self.btnTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            self.btnTitle.imageView.transform = CGAffineTransformMakeRotation(0);
        }
}

#pragma mark---headerView的子控件的frame---
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置btn的frame填充整个headerview
    self.btnTitle.frame = self.bounds;

    CGFloat lblW = 50;
    CGFloat lblH = self.bounds.size.height;
    CGFloat lblX = self.bounds.size.width - lblW -10;
    CGFloat lblY = 0;
    self.lblCount.frame = CGRectMake(lblX, lblY, lblW, lblH);
}


#pragma mark---headerView的的监听事件-----;
-(void)btnClick
{
    self.group.show = ! self.group.isShow;
    //通过代理方法刷新表视图
    if([self.delegate respondsToSelector:@selector(HeaderViewClick:)])
    {
        [self.delegate HeaderViewClick:self];
    }

}


@end
