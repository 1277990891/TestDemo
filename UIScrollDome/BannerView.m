//
//  BannerView.m
//  TKDoctor
//
//  Created by aragon_mini2 on 15/10/27.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "BannerView.h"
#import "UIView+Frame.h"
// 屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ImageCount 5
@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self bannerView];
    }
    return self;
}

- (void)bannerView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:bgView];
    
    NSMutableArray *sourceImages = [NSMutableArray arrayWithCapacity:9];
    
    UIImage *image4 = [UIImage imageNamed:@"banner04.png"];
    [sourceImages addObject:image4];
    UIImage *imageFirst = [UIImage imageNamed:@"banner05.png"];
    [sourceImages addObject:imageFirst];
    
    
    for (int i = 0; i <ImageCount ; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"banner0%d.png", i+1]];
        [sourceImages addObject:image];
    }
    
    UIImage *image = [UIImage imageNamed:@"banner01.png"];
    [sourceImages addObject:image];
    UIImage *image2 = [UIImage imageNamed:@"banner02.png"];
    [sourceImages addObject:image2];
    
    
    if (kScreenWidth == 375) {
        self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(15, 0, bgView.width-30, 130) andImages:sourceImages sideImageCount:1 sideImageScale:0.8 middleImageScale:1.1];
        
        
    }else if (kScreenWidth<375){
        self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(0, 0, bgView.width, 130) andImages:sourceImages sideImageCount:1 sideImageScale:0.8 middleImageScale:1.1];
        
    }else{
        
        self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(55, 0, bgView.width-30-70, 130) andImages:sourceImages sideImageCount:1 sideImageScale:0.8 middleImageScale:1.2];
        
    }
    
    [bgView addSubview:self.coverFlowView];
    
}



@end
