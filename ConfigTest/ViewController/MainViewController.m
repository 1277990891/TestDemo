//
//  ViewController.m
//  ConfigTest
//
//  Created by li bo on 11/7/17.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "MainViewController.h"
#import "ConfigTest-Swift.h"
#import "NGViewHighlightControl.h"
#import "SubViewController.h"

@interface MainViewController ()

@property (nonatomic, strong)AFHTTPClient *httpClient;
@property (nonatomic, strong)AFHTTPRequestOperation *downloadOperation;
@property (nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NSModel* model;
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet NGViewHighlightControl *bottomCoverView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger indexUser;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef CONFIGTESTDEMO_BRANDING
    self.title = @"ConfigTestDemo";
#else
    self.title = @"ConfigTest";
#endif
    self.model = [[NSModel alloc]init];
    // 转义
    NSString* urlStr = @"https://baidu.com/liaojie[]{}<>!@#$%";
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSLog(@"urlStr = %@", urlStr);
    
    if (IPHONE6) {
        NSLog(@"--IPHONE6");
    }
//    添加如下代码时，系统会读取 Localizable.strings 文件中的国际化文本

//    [self.loginButton setTitle:NSLocalizedString(@"Login", @"login button") forState:UIControlStateNormal];
//    [self.downloadButton setTitle:NSLocalizedString(@"download", @"download button") forState:UIControlStateNormal];
//    [self.pauseButton setTitle:NSLocalizedString(@"pause", @"pause button") forState:UIControlStateNormal];

    self.view.backgroundColor = RGBCOLOR(100, 101, 102);
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progress = 0.0;

#ifdef DEBUG
    AppViewController *app = [[AppViewController alloc]init];
    int a = [app actions];
    NSLog(@"----%d", a);
#endif

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction)];
    [self.bottomCoverView addGestureRecognizer:tap];

    NSString* str = @"";
    if (str == nil) {
        NSLog(@"---");
    }
    NSString* strw = NULL;
    if (strw == nil) {
    }

    
}

#pragma --- 登陆 ---
- (IBAction)loginAction:(UIButton*)sender
{
    sender.selected = ! sender.selected;

    // user 1
//    self.indexUser = 0;
//    self.usernameTF.text = @"123456@qq.com";
//    self.passwordTF.text = @"Test1111";

    // user 2
    self.indexUser = 1;
    self.usernameTF.text = @"gold41@mailinator.com";
    self.passwordTF.text = @"test1234";

    // user 3
//    self.indexUser = 2;
//    self.usernameTF.text = @"1277990891@qq.com";
//    self.passwordTF.text = @"test1111";

    [self showHUDWithText:nil];
    [self.model loginSuccessWithUUID:nil login:self.usernameTF.text password:self.passwordTF.text completionBlock:^(id resultObject, NSError *error) {
        [self dismissHUD];

        if (error ==nil) {
            [MBProgressHUD showSuccess:@"登陆成功"];
        }else{
            [MBProgressHUD showError:@"登陆失败"];
        }
    }];
}


#pragma ---- AFHTTPRequestOperation 下载

- (IBAction)AFNtworkoutingAction
{
    NSURL *url = [NSURL URLWithString:@"http://baishi.baidu.com/watch/5010048124986969826.html"];
    _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    _queue = [[NSOperationQueue alloc] init];

//    NSURLConnection
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    // 保存到沙盒中
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docs[0] stringByAppendingPathComponent:@"download"];
    self.downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    NSLog(@"===%@", path);

    __weak typeof(self) weakSelf = self;

    [weakSelf.downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        // 设置进度条的百分比
        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        weakSelf.progressView.progress = precent;
        NSLog(@"%f", precent);
    }];

    // 设置下载完成操作
    [self.downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SSZipArchive unzipFileAtPath:path toDestination:docs[0]];
//        NSFileManager 文件管理操作，可以删除，复制，移动文件等操作
//        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        weakSelf.progressView.progress = 0.0;
//        [weakSelf.progressView removeFromSuperview];
        NSLog(@"下载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败--%@,", error);
    }];

    // 启动下载
    [_httpClient.operationQueue addOperation:self.downloadOperation];

}

- (IBAction)pauseResume:(id)sender
{
    // 关于暂停和继续，AFN中的数据不是线程安全的 会使得数据发生混乱
    if (_downloadOperation.isPaused) {
        [_downloadOperation resume];
    } else {
        [_downloadOperation pause];
    }
}

#pragma mark 检测网路状态

- (IBAction)checkNetwork:(id)sender
{
    // AFNetwork 是根据是否能够连接到baseUrl来判断网络连接状态的
    // 提示：最好使用门户网站来判断网络连接状态。
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];

    _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    [_httpClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [MBProgressHUD showSuccess:@"WiFi网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [MBProgressHUD showSuccess:@"3G网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showSuccess:@"未连接"];
                break;
            case AFNetworkReachabilityStatusUnknown:
                [MBProgressHUD showSuccess:@"未知错误"];
                break;
        }
    }];
}

- (void)imageViewAction
{
    // 设置高亮图标
    self.backgroundImageView.highlightedImage = [UIImage imageNamed:@"Logo"];
    self.imageView.highlightedImage = [UIImage imageNamed:@"xID_logo"];

    SubViewController* subView = [[SubViewController alloc]init];
    subView.model = self.model;

    switch (self.indexUser) {
        case 0:
            subView.userIndex = NGUserAccount0;
            break;
        case 1:
            subView.userIndex = NGUserAccount1;
            break;
        case 2:
            subView.userIndex = NGUserAccount2;
            break;
        default:
            subView.userIndex = NGUserAccount0;
            break;
    }
    [self.navigationController pushViewController:subView animated:YES];
}
@end
