//
//  PlayMusicView.h
//  UIScrollDome
//
//  Created by lee on 15/11/24.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PlayMusicView : UIView<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic ,strong)AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

- (IBAction)sliderDragAction:(id)sender;//拖拽进度条

- (IBAction)playBtnAction:(UIButton *)sender;// 播放

@property (nonatomic ,strong)NSTimer *sliderTimer;
/**
 *  Description
 */
// 为自定义view封装一个类方法, 这个类方法的作用就是创建一个view对象
+ (instancetype)appView;

@end
