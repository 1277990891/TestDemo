//
//  ZBNewsListController.m
//  32-网易新闻
//
//  Created by apple on 15-4-21.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZBNewsListController.h"
#import "ZBNewsListCell.h"
#import "ZBNews.h"
#import "HMDetailViewController.h"
#import "ZBNewsController.h"
// 屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZBNewsListController ()
@property (nonatomic, strong) NSArray *news;
@end

@implementation ZBNewsListController

/**
 *   从模型中加载频道新闻数据
 */
-(void)setUrlString:(NSString *)urlString
{
    _urlString = urlString.copy;
    
    //加载数据
    [ZBNews newsWithUrlString:urlString complete:^(NSArray * newList) {
        self.news = newList;
        [self.tableView reloadData];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新闻列表";

    [ZBNews newsWithUrlString:@"article/headline/T1348649654285/0-20.html" complete:^(NSArray *newsList) {
        //将block代码块中的数据 赋值给 数组news
        if(newsList.count<1){
            return ;
        }
        self.news = newsList;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZBNews *new = self.news[indexPath.row];
    ZBNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZBNewsListCell cellWithidentifier:new] forIndexPath:indexPath];
    cell.news = new;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZBNews *news = self.news[indexPath.row];
    
    return [ZBNewsListCell rowHeightForCell:news];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMDetailViewController *newVc = [[HMDetailViewController alloc]init];
    
    ZBNews *news = self.news[indexPath.row];
    newVc.title = news.title;
    newVc.intro = news.digest;
    [self.navigationController pushViewController:newVc animated:YES];
}

@end
