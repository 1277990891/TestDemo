//
//  CoverFlowView.h
//  TKDoctor
//
//  Created by aragon_mini2 on 15/9/24.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverFlowView : UIView

@property (nonatomic,assign) int sideVisibleImageCount;
@property (nonatomic,assign) CGFloat sideVisibleImageScale;
@property (nonatomic,assign) CGFloat middleImageScale;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *imageLayers;
@property (nonatomic, retain) NSMutableArray *templateLayers;
@property (nonatomic) int currentRenderingImageIndex;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic,assign)BOOL isSwipingToLeftDirection;

+ (id)coverFlowViewWithFrame:(CGRect)frame andImages: (NSMutableArray *)rawImages sideImageCount:(int) sideCount sideImageScale: (CGFloat) sideImageScale
            middleImageScale: (CGFloat) middleImageScale;

//get index for current image that in the middle in images
- (int)getIndexForMiddle;

- (int)imageWithIndex;

@end
