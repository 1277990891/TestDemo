
//
//  ZBHomeController.m
//  32-网易新闻
//
//  Created by apple on 15-4-23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBHomeController.h"
#import "ZBNewsCell.h"
#import "chanal.h"
#import "channelButton.h"
#import "ChannelOrderVC.h"
#import "Header.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZBHomeController () <UICollectionViewDataSource ,UICollectionViewDelegate,ChannelOrderVCDataSource,ChannelOrderVCDelegate>
//视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//标题栏
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//布局
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

//模型数组
@property (nonatomic, strong) NSArray *channels;

// 当前选中的频道索引
@property (nonatomic, assign) NSInteger currentIndex;

// 记录上一个偏移量
@property (nonatomic, assign)CGFloat offsetX;
@end

@implementation ZBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加scrollView上的标题栏
    [self addChannel];
    //
    [self addOrderButton];
}
-(void)addOrderButton
{
    UIButton *orderButton= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60 , 0, 60, 44)];
    [orderButton setBackgroundImage:[UIImage imageNamed:@"topnav_orderbutton"] forState:UIControlStateNormal];
    [self.view addSubview:orderButton];
    [orderButton addTarget:self action:@selector(orderViewOut:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark－ 懒加载
- (NSArray *)channels {
    if (_channels == nil) {
        _channels = [chanal channels];
    }
    return _channels;
}

// 添加scrollView上的标题..
-(void)addChannel
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat margin= 5;
    CGFloat x = 10;
    CGFloat h = self.scrollView.bounds.size.height;
    NSInteger index = 0;
    for (chanal *channal in self.channels)
    {
       index ++;
       channelButton* btn = [channelButton channelWithTitle:channal.tname];
        btn.frame = CGRectMake(x, 0, btn.bounds.size.width, h);
        x = x + btn.bounds.size.width+margin;
        btn.tag = 1000+ index;
        [btn addTarget:self action:@selector(channelBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(x + margin, h);
    
    //默认选中第一个"头条"
    self.currentIndex = 0;
    channelButton* btn = self.scrollView.subviews[0];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.scale = 1;
    
    
}

-(void)channelBtnAction:(UIButton*)btn
{
    NSLog(@"btn.tag = %ld",btn.tag);
    
    // 滚动结束之后重新更新标题状态
    for(channelButton *title  in  self.scrollView.subviews){
        if ([title isKindOfClass:[channelButton class]]) {
            title.titleLabel.textColor = [UIColor blackColor];
            CGFloat max = 20 / 16 - 1;
            CGFloat percent = max * 1 + 1;
            title.layer.affineTransform = CGAffineTransformMakeScale(percent, percent);
        }
    }
    // 选中当前的标签
    self.currentIndex = btn.tag -1001;
    channelButton *currentbtn = self.scrollView.subviews[self.currentIndex];
    currentbtn.titleLabel.textColor = [UIColor redColor];
    currentbtn.scale = 1.0;
    
    if (self.currentIndex==5) {
        _offsetX = 45*6-kScreenWidth/2-45/2;
        [self.scrollView setContentOffset:CGPointMake(_offsetX, 0) animated:YES];
    }else if (self.currentIndex>5){
        _offsetX=50*(self.currentIndex-4)+30;
        [self.scrollView setContentOffset:CGPointMake(_offsetX, 0) animated:YES];
        NSLog(@"---===%f",_offsetX);
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.currentIndex, 0)];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
    
}

// 视图将要显示，子视图还没有完成布局
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@ %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(self.collectionView.bounds));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"==> %@ %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(self.collectionView.bounds));
    
    // 设置布局
    [self setupLayout];
}

// 设置布局
- (void)setupLayout {
    
    self.layout.itemSize = self.collectionView.bounds.size;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 分页
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channels.count ;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZBNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelCell" forIndexPath:indexPath];
    // 判断当前 cell 的视图控制器是否是 homeViewController 的子控制器.一定要添加子视图控制器！让 newsVc 控制器界面填充整个 layout
    if (![self.childViewControllers containsObject:(UIViewController *)cell.newsVc]) {
        [self addChildViewController:(UIViewController *)cell.newsVc];
    }
    NSLog(@"子视图控制器 %@", self.childViewControllers);
    
    ZBNewsCell *channel = self.channels[indexPath.item];
    
    cell.urlString = channel.urlString;
    
    return cell;
}


#pragma mark -  只要滚动视图发生滚动，就会立即执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"开始 %@", NSStringFromCGPoint(self.collectionView.contentOffset));

}

// 滚动视图停止滚动，更新一下当前的索引
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    NSLog(@"停止 %@ %zd", NSStringFromCGPoint(scrollView.contentOffset), self.currentIndex);
    [self reloadTitle];
    
    // 滚动结束之后重新更新标题状态
    for(channelButton *title  in  self.scrollView.subviews){
        if ([title isKindOfClass:[channelButton class]]) {
            title.titleLabel.textColor = [UIColor blackColor];
            CGFloat max = 20 / 16 - 1;
            CGFloat percent = max * 1 + 1;
            title.layer.affineTransform = CGAffineTransformMakeScale(percent, percent);
        }
    }
    // 当前的标签
    channelButton *currentLabel = self.scrollView.subviews[self.currentIndex];
    currentLabel.titleLabel.textColor = [UIColor redColor];
    currentLabel.scale = 1.0;
}

-(void)reloadTitle
{
    // 当前的标签
    channelButton *currentLabel = self.scrollView.subviews[self.currentIndex];
    // 下一个标签
    channelButton *nextLabel = nil;
    
    // 遍历数组，查找下一个标签
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        if (indexPath.item != self.currentIndex) {
            nextLabel = self.scrollView.subviews[indexPath.item];
            break;
        }
    }
    NSLog(@"从 %@ 到 %@", currentLabel.titleLabel.text, nextLabel.titleLabel.text);
    NSLog(@"---%ld",self.currentIndex);
    if (self.currentIndex<5) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        CGFloat w = 50;
        [self.scrollView setContentOffset:CGPointMake(w*(self.currentIndex-4)+30, 0) animated:YES];
    }
    
}
#pragma ---增删频道
- (void)orderViewOut:(id)sender{
    
    CGFloat y = 0;
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height - y;
    CGRect rect_hidden = CGRectMake(0, - height, width, height);
    CGRect rect_show = CGRectMake(0, y, width, height);
    
    ChannelOrderVC *orderVC = [[ChannelOrderVC alloc] init];
    orderVC.dataSource = self;
    orderVC.delegate = self;
    [orderVC.view setFrame:rect_hidden];
    //注意点：setFrame要在此view被addSubview之前调用
    [self.view addSubview:orderVC.view];
    [self addChildViewController:orderVC];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [orderVC.view setFrame:rect_show];
        
    } completion:^(BOOL finished){
        
    }];
    
}
#pragma mark 数据源:ChannelOrderVCDataSource
- (NSMutableArray *)originChannelOrderYES_whenChannelFileNoExist{
    NSArray *channelNames = [NSArray arrayWithObjects:KChannelList, nil] ;
    NSArray *channelUrls = [NSArray arrayWithObjects:KChannelUrlStringList, nil];
    
    NSMutableArray *channel_order_YES_Ori = [NSMutableArray array]; //Origin
    for (int i = 0; i < channelNames.count; i++) {
        NSString *channelName = [channelNames objectAtIndex:i];
        NSString *channelUrl = [channelUrls objectAtIndex:i];
        ChannelModel *channel = [[ChannelModel alloc]initWithTitle:channelName urlString:channelUrl];
        if (i < KDefaultCountOfUpsideList - 1) {
            [channel_order_YES_Ori addObject:channel];
        }
    }
    return channel_order_YES_Ori;
}

- (NSMutableArray *)originChannelOrderNO_whenChannelFileNoExist{
    NSArray *channelNames = [NSArray arrayWithObjects:KChannelList, nil] ;
    NSArray *channelUrls = [NSArray arrayWithObjects:KChannelUrlStringList, nil];
    
    NSMutableArray *channel_order_NO_Ori = [NSMutableArray array];
    for (int i = 0; i < channelNames.count; i++) {
        NSString *channelName = [channelNames objectAtIndex:i];
        NSString *channelUrl = [channelUrls objectAtIndex:i];
        ChannelModel *channel = [[ChannelModel alloc]initWithTitle:channelName urlString:channelUrl];
        if (i >= KDefaultCountOfUpsideList - 1) {
            [channel_order_NO_Ori addObject:channel];
        }
    }
    return channel_order_NO_Ori;
}

#pragma mark 委托:ChannelOrderVCDelegate
- (void)hiddenChannelOrderVC:(ChannelOrderVC *)orderVC{
    if (orderVC->_viewArr1.count < 3) {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)message:NSLocalizedString(@"请至少选择三个", nil)
               delegate:nil cancelButtonTitle: NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
        return;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGFloat width = self.view.bounds.size.width;//本例中orderButton.vc等于self
        CGFloat height = self.view.bounds.size.height;
        CGRect rect_hidden = CGRectMake(0, - height, width, height);
        [orderVC.view setFrame:rect_hidden];
        
    } completion:^(BOOL finished){
        [orderVC updateCurrentOrder_whenChangeOrder];
        
        [orderVC.view removeFromSuperview];
        [orderVC removeFromParentViewController];
        
    }];
    
    for (int i = 0; i<orderVC->_viewArr1.count; i++) {
        
        NSLog(@"频道-%@",orderVC->_viewArr1[i]);
    }
    
    
}@end
