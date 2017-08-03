//
//  ZBCollectionCell.h
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBNewsModel;
@interface ZBCollectionCell : UICollectionViewCell
@property(nonatomic,copy)ZBNewsModel *newsModel;

@end
