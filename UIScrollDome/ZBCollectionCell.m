//
//  ZBCollectionCell.m
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZBNewsModel.h"
@interface ZBCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic)  UILabel *title;

@end
@implementation ZBCollectionCell


-(void)setNewsModel:(ZBNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    [self.imgView setImageWithURL:[NSURL URLWithString:newsModel.imgsrc]];
    self.title.text = newsModel.title;
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTitle];
    }
    return self;
}
-(void)addTitle
{
    self.title = [[UILabel alloc]init];
    self.title.textColor = [UIColor redColor];
    self.title.font = [UIFont systemFontOfSize:14];

    [self addSubview:self.title];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.title.frame = CGRectMake(10, self.frame.size.height-20, self.frame.size.width, 20);
    
}
@end
