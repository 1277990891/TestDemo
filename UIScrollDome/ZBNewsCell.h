//
//  ZBNewsCell.h
//  32-网易新闻
//
//  Created by apple on 15-4-22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBNewsListController;
@interface ZBNewsCell : UICollectionViewCell
/**
 *  1.加载新闻视图控制器,把每一个控制器当做collectionView中的一个layout.
 */
@property(nonatomic,strong)ZBNewsListController *newsVc;
/**
 *  2.加载从视图控制器中传来的对应的频道urlString请求;
 */
@property(nonatomic,copy)NSString *urlString;
@end
