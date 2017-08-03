//
//  ChannelView.h
//  CJNewsOrderDemo
//
//  Created by lichq on 15/11/4.
//  Copyright (c) 2015年 lichq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"



@class ChannelModel;
@interface ChannelView : UIImageView
{
    CGPoint _point;
    CGPoint _point2;
    NSInteger _sign;
    @public
    
    NSMutableArray * _array;
    NSMutableArray * _viewArr11;
    NSMutableArray * _viewArr22;
}
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) UILabel *moreChannelsLabel;
@property (nonatomic,retain) ChannelModel *channelModel;
@end
