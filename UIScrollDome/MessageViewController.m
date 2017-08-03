//
//  MessageViewController.m
//  UIScrollDome
//
//  Created by lee on 15/11/18.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "MessageViewController.h"
#import "QRViewController.h"

@interface MessageViewController ()<QRViewControllerDelegate>
@property (nonatomic,strong)QRViewController *qr;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addViews];
}

-(void)addViews
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"扫码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnAction
{
    _qr = [[QRViewController alloc]init];
    _qr.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_qr];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)qrCodeComplete:(NSString *)codeString
{
    [_qr dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",codeString);
}
-(void)qrCodeError:(NSError *)error
{
    NSLog(@"%@",error);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}



@end
