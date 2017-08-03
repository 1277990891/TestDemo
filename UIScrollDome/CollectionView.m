
//
//  CollectionView.m
//  UIScrollDome
//
//  Created by lee on 15/11/17.
//  Copyright (c) 2015年 lst. All rights reserved.
//

/**  使用方法
 
 *  CGFloat w = self.view.bounds.size.width;
    CGFloat h = 200;
    CollectionView *colview = [[CollectionView alloc]init];
    colview.delegate = self;
    self.tableView.tableHeaderView = colview;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 65+20, w, h);
 */

#import "CollectionView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define PhotoNum 5
#define SectionNum 1000


@interface CollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (strong, nonatomic)  UIPageControl *pageControl;
//@property (strong, nonatomic)   UICollectionViewFlowLayout *layout;
@property (strong ,nonatomic)UICollectionView *collectionView;
//计时器
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation CollectionView

static NSString * const reuseIdentifier = @"cell";

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc ] init];
    layout.itemSize = CGSizeMake(kScreenWidth, 200);
    //列之间间距
    layout.minimumInteritemSpacing = 0;
    //行之间间距
    layout.minimumLineSpacing = 0;
    //四周间距
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumLineSpacing, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 200) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    self.currentIndex = 0;
    
    // 无限轮播
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:SectionNum/2];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2, 180, 100, 20)];
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = PhotoNum;
    self.pageControl.currentPage = 0;
    
    // 定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(NSArray *)dataList
{
    if (_dataList == nil) {
       
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _dataList = array;
    }
    return _dataList;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionNum;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSUInteger index = (indexPath.item - 1 + self.dataList.count + self.currentIndex) % self.dataList.count;
    UIImageView *imgView =[[UIImageView alloc]initWithFrame:cell.bounds];
    [cell.contentView addSubview:imgView];
    NSString *str= [self.dataList[index] objectForKey:@"icon"];
    imgView.image = [UIImage imageNamed:str];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-30, kScreenWidth, 20)];
    title.text =  [self.dataList[index] objectForKey:@"title"];
    [cell.contentView addSubview:title];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if ([self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.delegate didSelectIndex:indexPath.row];
    }
}

#pragma mark-----轮播结束--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.dataList.count;
    self.pageControl.currentPage = page;
    NSLog(@"===> %zd", page);
    
}

// 拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

// 拖拽结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 重新启动一个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)scrollImage
{
    
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.dataList.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:SectionNum/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return currentIndexPathReset;
}
@end
