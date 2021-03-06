//
//  TouchView.h
//  TouchDemo
//
//  Created by Zer0 on 13-10-11.
//  Copyright (c) 2013年 Zer0. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TouchViewModel;
@interface TouchView : UIImageView
{
    CGPoint _point;
    CGPoint _point2;
    NSInteger _sign;
    @public
    
    
}
@property (nonatomic,strong) NSMutableArray * array;

@property (nonatomic,strong) NSMutableArray * viewArr11;
@property (nonatomic,strong) NSMutableArray * viewArr22;

@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UILabel * moreChannelsLabel;
@property (nonatomic,strong) TouchViewModel * touchViewModel;
@end
