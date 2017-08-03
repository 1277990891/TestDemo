//
//  HMReadingViewController.m

//
//  Created by apple on 14-7-25.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMReadingViewController.h"
#import "CollectionView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HMReadingViewController ()<CollectionDelegate>
@property (nonatomic, strong)  UIImageView *bgView;
@property (nonatomic, strong)  UIImageView *hourHand;
@property (nonatomic, strong)  UIImageView *minuteHand;
@property (nonatomic, strong)  UIImageView *secondHand;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation HMReadingViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //
   
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 200;
    CollectionView *colview = [[CollectionView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    colview.delegate = self;
    [self.view addSubview:colview];
    
    [self setupClickView];
    

}

-(void)didSelectIndex:(NSInteger)index
{
    NSLog(@"点击了---%ld",index);
}

-(void)setupClickView
{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
    self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-180)/2,300, 180, 180)];
    self.bgView.image = [UIImage  imageNamed:@"click"];
    self.hourHand = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-15)/2, 350, 15, 60)];
    self.hourHand.image = [UIImage  imageNamed:@"hour"];
    self.minuteHand = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10)/2, 350, 10, 70)];
    self.minuteHand.image = [UIImage  imageNamed:@"minute"];
    self.secondHand = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-5)/2, 350, 5, 80)];
    self.secondHand.image = [UIImage  imageNamed:@"second"];
    
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:_bgView];
    [self.view addSubview:_hourHand];
    [self.view addSubview:_minuteHand];
    [self.view addSubview:_secondHand];
}

// 时钟
- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
}
@end
