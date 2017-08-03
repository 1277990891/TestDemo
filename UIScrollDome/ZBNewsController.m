//
//  ZBNewsController.m
//  32-网易新闻
//
//  Created by apple on 15-4-20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNewsController.h"
#import "ZBNewsModel.h"
#import "ZBCollectionCell.h"
@interface ZBNewsController ()
//属性数组
@property (nonatomic, strong) NSArray *newsArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@end

@implementation ZBNewsController

#pragma ------newsArray之前会做懒加载获取模型数据.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZBNewsModel headerLineWithcomplete:^(NSArray *headerLine)
     {
         self.newsArray = headerLine;
         [self.collectionView reloadData];
     }];
}

///设置layout属性
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromCGSize (self.collectionView.bounds.size));
    self.layout.itemSize = self.collectionView.bounds.size;
    //没有间距
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    //隐藏滚动条
    self.layout.collectionView.showsHorizontalScrollIndicator = NO;
    //滚动方向
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //弹簧效果
    self.layout.collectionView.bounces = NO;
    //分页
    self.layout.collectionView.pagingEnabled = YES;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    //创建cell
    ZBCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    //设置数据
    cell.newsModel = self.newsArray[indexPath.item];
    
    return cell;
}



@end
