//
//  SubViewController.m
//  ConfigTest
//
//  Created by li bo on 11/22/17.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "SubViewController.h"
#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSUserAccount+CoreDataProperties.h"
#import "UseAccountViewController.h"

typedef enum : NSInteger {
    NGWorkoutsTime30Seconds,
    NGWorkoutsTime60Seconds,
    NGWorkoutsTime90Seconds,
    NGWorkoutsTimeCustom
} NGWorkoutsNumber;


@interface SubViewController ()<QRViewControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign)NSInteger indexPath;
@property (nonatomic,strong)QRViewController* qrVc;
@property (nonatomic, strong)UIWebView* web;
@property (nonatomic, strong)NSUserAccount* userAccount;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

// 系统控件
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"国际化文本";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftbarAction)];

    UIButton* back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    UIImage* backiamge = [[UIImage imageNamed:@"ic_back"] imageWithTintColor:[UIColor blackColor]];
    [back setImage:backiamge forState:UIControlStateNormal];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    back.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, -15);
//    [back addTarget:self action:@selector(leftbarAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];

    SEL action = @selector(leftbarAction);
    [back addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    _web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_web];

    [self addViews];

//    [self setupAVFundationView];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription* workout = [NSEntityDescription entityForName:@"NSUserAccount" inManagedObjectContext:self.model.managedObjectContext];
//    [request setEntity:workout];

    request.entity = [NSEntityDescription entityForName:@"NSUserAccount" inManagedObjectContext:self.model.managedObjectContext];
    NSError *error = nil;
    NSArray* objs = [self.model.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil){
        for (int i=0; i<objs.count; i++) {
            self.userAccount = objs[i];
            NSLog(@"=======%@", self.userAccount.email);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    switch (self.indexPath) {
        case NGWorkoutsTime30Seconds:
            NSLog(@"---NGWorkoutsTime30Seconds");
            break;
        case NGWorkoutsTime60Seconds:
            NSLog(@"---NGWorkoutsTime60Seconds");
        case NGWorkoutsTime90Seconds:
            NSLog(@"---NGWorkoutsTime90Seconds");
        default:
            NSLog(@"---NGWorkoutsTimeCustom");
            break;
    }
}

- (void)leftbarAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addViews
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"扫码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *savebtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    savebtn.backgroundColor = [UIColor redColor];
    [savebtn setTitle:@"保存" forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(savebtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebtn];
}
- (void)btnAction
{
    self.qrVc = [[QRViewController alloc]init];
    self.qrVc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.qrVc];
    [self presentViewController:nav animated:YES completion:nil];
}


// 保存个人信息
- (void)savebtnAction
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormatter dateFromString:@"01/13/2000"];

    NSString* firstname = nil;
    NSString* email  = nil;
    NSString* uuid  = nil;
    NSString* gender  = nil;
    NSNumber* weight  = nil;
    NSNumber* height  = nil;
    NSString* homeClub = nil;

//  测试用户
    if (_lastuser) {
        email = @"123456@qq.com";
        uuid = @"8ad6046e-78ec-4d34-a63f-547b8ccda62e";
        homeClub = @"219243ee-fc33-488a-9726-25c89fe79883";
        firstname = @"tester";
        gender = @"M";
        weight = @10;
        height = @30;
    }else{
        uuid = @"d97f22e3-2598-4512-a3b5-707012ec7c71";
        homeClub = @"45ecf341-0045-4adb-bf7f-e285469afa14";
        weight = @30;
        height = @80;
    }

    [self.model updateUserProfileWithUserUUID:uuid firstName:firstname lastName:@"Test" email:email measurementUnit:@"I" gender:gender homeClub:homeClub birthday:date weight:weight height:height newPassword:nil withCompletionBlock:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"NSHomeDirectory = %@", NSHomeDirectory());
            [MBProgressHUD showSuccess:@"保存成功"];
            [self pushtoUserAccountViewController];
        }else{
            NSDictionary* dict = [error.userInfo objectForKey:@"responseData"];
            [MBProgressHUD showError:[dict objectForKey:@"message"]];
        }
    }];
}

-(void)pushtoUserAccountViewController
{
    UseAccountViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"UseAccountVC"];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma --- QRViewControllerDelegate

-(void)qrCodeComplete:(NSString *)codeString
{
    [self.qrVc dismissViewControllerAnimated:YES completion:nil];

    NSURL* url = [NSURL URLWithString:codeString];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [_web loadRequest:req];

    NSLog(@"%@",codeString);
}
-(void)qrCodeError:(NSError *)error
{
    NSLog(@"%@",error);
}


-(void)setupAVFundationView
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_output setRectOfInterest:CGRectMake(0.2f, 0.2f, 0.8f, 0.8f)];

    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }

    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];

    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if (stringValue == nil){
            [self.session startRunning];
        }
        NSURL* url = [NSURL URLWithString:stringValue];
        NSURLRequest* req = [NSURLRequest requestWithURL:url];
        [_web loadRequest:req];
    }

}
@end