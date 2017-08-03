//
//  ZBNewsCell.m
//  32-网易新闻
//
//  Created by apple on 15-4-22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNewsCell.h"
#import "ZBNewsListController.h"
@implementation ZBNewsCell

/**
 *  1.将控制器视图 加到cell中
 */
-(void)awakeFromNib
{
    //获取视图控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    self.newsVc = sb.instantiateInitialViewController;
    
    //设置视图控制器的大小为collectionview的大小-"全屏"
    self.newsVc.view.frame = self.bounds;
    
    //加入视图控制器
    [self addSubview:self.newsVc.view];
    
}
/**
 *  2.把模型中urlString对应的数据传给控制器的urlString
 */
-(void)setUrlString:(NSString *)urlString
{
    _urlString = urlString.copy;
    self.newsVc.urlString = urlString;
}
@end
