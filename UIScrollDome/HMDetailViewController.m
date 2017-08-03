//
//  HMDetailViewController.m
//  UIScrollDome
//
//  Created by lee on 15/11/25.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "HMDetailViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HMDetailViewController ()

@end

@implementation HMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addIntro];
}

-(void)addIntro
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0,kScreenWidth-40 , kScreenHeight-50)];
    lbl.text = self.intro;
    lbl.numberOfLines = 0;
    
    CGSize size = CGSizeMake(kScreenWidth-40, 1000);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:lbl.font,NSFontAttributeName,nil];
    CGSize titleSize = [lbl.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    lbl.frame = CGRectMake(20, 0, kScreenWidth-40, titleSize.height);
    [lbl setContentMode:UIViewContentModeTop];
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lbl];
    
}


@end
