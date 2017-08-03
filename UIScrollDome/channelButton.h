//
//  channelButton.h
//  UIScrollDome
//
//  Created by lee on 16/6/12.
//  Copyright © 2016年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightButton.h"

@interface channelButton : HighlightButton

/**
 *  1.创建顶部scrollView中的label标题
 */
+(instancetype)channelWithTitle:(NSString*)title;

// 字体的大小比例
@property(nonatomic,assign)CGFloat scale;

@end
