
//
//  PlayMusicView.m
//  UIScrollDome
//
//  Created by lee on 15/11/24.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "PlayMusicView.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayMusicView ()<AVAudioPlayerDelegate>
{
//    AVAudioPlayer *_audioPlayer;
}
@end

@implementation PlayMusicView


+ (instancetype)appView
{
    // 1. 通过xib创建每个应用(UIView)
    NSBundle *rootBundle = [NSBundle mainBundle];

    return [[rootBundle loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        [self addSubview];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview];

    }
    return self;
}

- (void)awakeFromNib {
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
}

-(void)addSubview
{
    self.imageView.image = [UIImage imageNamed:@"promoboard_icon_activities"];
    
    NSURL * audioURL = [[NSBundle mainBundle] URLForResource:@"十年" withExtension:@"mp3"];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:nil];

    _audioPlayer.delegate = self;
    [_audioPlayer setNumberOfLoops:0];//设置为-1可以实现无限循环播放
    [_audioPlayer setVolume:1.0];
    
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
    [self.slider addTarget:self action:@selector(sliderDragAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateSlider {
    
    _slider.value = _audioPlayer.currentTime;
    
    NSString *strTime = [NSString stringWithFormat:@"%.f", _audioPlayer.duration - _audioPlayer.currentTime];
    
    
    self.timeLbl.text = [self timeFormatted:[strTime integerValue]];
    
}
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = (int)totalSeconds / 3600 ;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

// 进度
- (IBAction)sliderDragAction:(id)sender
{
     _audioPlayer.currentTime = _slider.value;
}
// 播放
- (IBAction)playBtnAction:(UIButton *)sender
{
    
    NSURL * audioURL = [[NSBundle mainBundle] URLForResource:@"十年" withExtension:@"mp3"];
    NSError * err;
    
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&err];

        [_audioPlayer prepareToPlay];
        [_audioPlayer setEnableRate:YES];
        [_audioPlayer setRate:1.0f];// 设置播放速度
    }
    if (_audioPlayer.isPlaying){
        [_audioPlayer pause];
         self.playBtn.selected = NO;
    } else {
         self.playBtn.selected = YES;
        [_audioPlayer play];
    }
    self.slider.maximumValue = _audioPlayer.duration;
}

#pragma ----delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (flag) {
        
        _slider.value = 0;
        
        [_audioPlayer stop];
        
        [_sliderTimer invalidate];
        
        self.playBtn.selected = NO;
    }
    
}

//播放过程中被打断(比如播放音乐过程中电话响了，短信响了等)
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
    self.playBtn.selected = NO;
    
    [_audioPlayer stop];
}
//结束打断
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    self.playBtn.selected = YES;
    
    [_audioPlayer play];
}
@end
