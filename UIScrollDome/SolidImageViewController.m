//
//  3DViewController.m
//  UIScrollDome
//
//  Created by lee on 15/11/23.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "SolidImageViewController.h"
#import "BannerView.h"
#import "PlayMusicView.h"
// 屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ImageCount 5
@interface SolidImageViewController ()

@property (nonatomic,weak)BannerView *bannerView;

@end

@implementation SolidImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    [self addSubViews];
}

- (void)addSubViews {
    // 3D视图
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    BannerView *bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bannerView.coverFlowView addGestureRecognizer:tap];
    
    self.bannerView = bannerView;
    [bgView addSubview:self.bannerView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = bgView;
    
}
-(void)tap
{
    int index = [self.bannerView.coverFlowView imageWithIndex];
    if (index==0) {
        
    }
    
    NSLog(@"index ---=>%d",index);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    PlayMusicView *view = [PlayMusicView appView];
    view.frame = CGRectMake(0, 0, kScreenWidth, 70);
    
    [cell.contentView addSubview:view];
    return cell;
 }




@end
