//
//  ZBNewsListCell.m
//  32-网易新闻
//
//  Created by apple on 15-4-21.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNewsListCell.h"
#import "ZBNews.h"
#import "UIImageView+AFNetworking.h"


@interface ZBNewsListCell ()
/**
 *  将相同的属性连载一起
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
//简介
@property (weak, nonatomic) IBOutlet UILabel *introLbl;
//跟帖
@property (weak, nonatomic) IBOutlet UILabel *followLbl;
//第一张图
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//配图--(第2/3张图p)
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *extraImage;


@end
@implementation ZBNewsListCell

- (void)awakeFromNib {
    
}

/**
 *  1.根据new模型中图片的数量确定哪一个可重用ID
 */
+(NSString *)cellWithidentifier:(ZBNews*)news
{
    //有两张图片
    if (news.imgextra.count == 2)
    {
        return @"cell2";
        //显示"大图"
    }else if (news.imgType)
    {
        return @"cell3";
    }else{
        return @"cell1";
    }
}

/**
 *  2.分别设置不同cell的行高
 */
+(CGFloat)rowHeightForCell:(ZBNews*)news
{
    
    if (news.imgextra.count == 2)
    {   //有两张图片
        return 110;
        
    }else if (news.imgType)
    {   //显示"大图"
        return 160;
    }else{
        return 75;
    }
}

/**
 *  3.set 方法设置属性
 */
-(void)setNews:(ZBNews *)news
{
    _news = news;
    self.titleLbl.text = news.title;
    self.introLbl.text = news.digest;
    self.followLbl.text = [NSString stringWithFormat:@"%02d",news.replyCount];
    self.imgView.image = [UIImage imageNamed:news.imgsrc];

    [self.imgView setImageWithURL:[NSURL URLWithString:news.imgsrc]];
    //配图
    if (news.imgextra.count == 2)
    {
        for (int i = 0 ; i< news.imgextra.count; i++) {
            
            //获取news.imgextra[i]对应的字典中的"imgsrc"属性值
            NSURL *url = [NSURL URLWithString:news.imgextra[i][@"imgsrc"]];
            
            UIImageView *view = self.extraImage[i];
            
            [view setImageWithURL:url];
        }
    }
    
    
}

@end
