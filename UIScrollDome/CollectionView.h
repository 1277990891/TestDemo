//
//  CollectionView.h
//  UIScrollDome
//
//  Created by lee on 15/11/17.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionView;
@protocol CollectionDelegate <NSObject>

-(void)didSelectIndex:(NSInteger)index;

@end
@interface CollectionView : UIView

@property(nonatomic,weak)id<CollectionDelegate>delegate;
@end
