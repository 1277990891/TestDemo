//
//  QRViewController.m
//  iOS自带二维码扫描
//
//  Created by iOS Dev on 14/11/4.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()
{
    //定义一个定时器
    NSTimer *_timer;
    
    //扫描框的背景图片
    UIImageView *_imageView;
    
    //扫描线
    UIImageView *_lineImageView;
}
@end

@implementation QRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置视图自动适配为YES
    self.view.autoresizingMask = YES;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    //设置导航栏为黑色风格
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self initUiConfig];
}


//初始化UI
- (void)initUI:(CGRect)previewFrame
{
    //初始化设备为视频设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    //初始化输入设备是摄像头视频设备
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    //如果没有摄像头 或者摄像头不可用就调用代理方法传出出错信息
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(qrCodeError:)]) {
            [self.delegate qrCodeError:error];
        }
        
        NSLog(@"你手机不支持二维码扫描!");
        return;
    }
    //初始化输出设备
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //设置输出设备的代理 是当前控制器  并且设置队列为主队列
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化会话
    self.session = [[AVCaptureSession alloc]init];
    
    //判断输入设备和输出设备能否被添加到会话中
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    //设置输出设备的类型支持
    self.output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode];
    //用会话初始化一个能拍照扫描的layer
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //设置layer的frame为大视图的frame
    self.preview.frame = previewFrame;
    
    //把拍摄的layer添加到主视图的layer中
    [self.view.layer addSublayer:self.preview];
    
    //设置会话的扫描的大小
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    //开始扫描
    [self.session startRunning];
}

//扫描完成的时候就会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //终止会话
    [self.session stopRunning];
    //把扫描的layer从主视图的layer中移除
    [self.preview removeFromSuperlayer];
    
    NSString *val = nil;
    if (metadataObjects.count > 0)
    {
        //取出最后扫描到的对象
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        //获得扫描的结果
        val = obj.stringValue;
        //调用代理的方法 传出扫描到信息
        if ([self.delegate respondsToSelector:@selector(qrCodeComplete:)]) {
            [self.delegate qrCodeComplete:val];
        }
    }
}

- (void)initUiConfig
{
    [self initUI:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
    
    //设置背景图片
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    //设置位置到界面的中间
    _imageView.frame = CGRectMake((self.view.bounds.size.width-200)/2, (self.view.bounds.size.height)/4, 200, 200);
    //添加到视图上
    [self.view addSubview:_imageView];
    
    //初始化二维码的扫描线的位置
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 10, 220, 2)];
    _lineImageView.image = [UIImage imageNamed:@"line.png"];
    [_imageView addSubview:_lineImageView];
    
    //设置导航控制器的右边的按钮为取消 并且点击了这个按钮就销毁这个modal控制器
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClick:)];
    
    
    
    //开启定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}



- (void)animation
{
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _lineImageView.frame = CGRectMake(0, 200, 200, 2);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(0, 10, 200, 2);
    }];
}

- (void)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
