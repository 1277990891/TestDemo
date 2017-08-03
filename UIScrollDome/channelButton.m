//
//  channelButton.m
//  UIScrollDome
//
//  Created by lee on 16/6/12.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "channelButton.h"

#define NormalSize      16.0
#define SelectedSize    20.0
@implementation channelButton

/**
 *  1.创建label标题
 */
+(instancetype)channelWithTitle:(NSString*)title
{
    channelButton *btn = [channelButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:NormalSize];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setHighlighted:NO];
    CGFloat w = 40;
    if (btn.titleLabel.text.length>3) {
        w = 80;
    }
    btn.frame = CGRectMake(0, 0, w, 40);

    return btn;
}

/**
 *  2,.设置切换视图时标题字体的大小比例---
 */
-(void)setScale:(CGFloat)scale
{
    _scale = scale;
    CGFloat max = SelectedSize / NormalSize - 1;
    CGFloat percent = max * scale + 1;
    //变大/小
    self.transform = CGAffineTransformMakeScale(percent, percent);
    //变颜色
    //self.textColor = [UIColor redColor];
    
    
}

@end
