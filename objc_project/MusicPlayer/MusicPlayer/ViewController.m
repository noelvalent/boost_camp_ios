//
//  ViewController.m
//  MusicPlayer
//
//  Created by 김동규 on 25/09/2019.
//  Copyright © 2019 김동규. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@implementation ViewController
{
    AVAudioPlayer *player;
    NSTimer *timer;
}
@synthesize playPauseButton;
@synthesize timeLabel;
@synthesize progressSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializePlayer];
}

// MARK: Methods
// MARK: Custom Method
-(void)initializePlayer{
    NSString *soundUrl = [[NSBundle mainBundle] pathForResource:@"/mysong" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:soundUrl];
    
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    player.delegate = self;
    progressSlider.maximumValue = (float)player.duration;
    progressSlider.minimumValue = 0;
    progressSlider.value = (float)player.currentTime;
    
}

-(void)updateTimeLabelText:(NSTimeInterval)time{
    const int minute = (int)(time / 60);
    const int second = (int)(fmodf(time, 60));
    const int milisecond = (int)(fmodf(time, 1) * 100);
    
    NSString *timeText = [NSString stringWithFormat:@"%02d:%02d:%02d", minute, second, milisecond];
    self.timeLabel.text = timeText;
}

-(void)timerMethod:(NSTimer*)timer{
    if (self.progressSlider.tracking){
        return;
    }
    [self updateTimeLabelText:player.currentTime];
    progressSlider.value = (float)player.currentTime;
}

-(void)makeAndFireTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerMethod:) userInfo:nil repeats:true];
    [timer fire];
}

-(void)invalidateTimer{
    [timer invalidate];
    timer = nil;
}

-(void)addViewsWithCode{
    [self addPlayPauseButton];
    [self addTimeLabel];
    [self addProgressSlider];
}

-(void)addPlayPauseButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button_pause"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(touchUpPlayPauseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *centerX = [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.8 constant:0];
    
    NSLayoutConstraint *width = [button.widthAnchor constraintEqualToAnchor:button.widthAnchor multiplier:1];
    
    NSLayoutConstraint *ratio = [button.heightAnchor constraintEqualToAnchor:button.widthAnchor multiplier:1];
    
    centerX.active = true;
    centerY.active = true;
    width.active = true;
    ratio.active = true;
    
    self.playPauseButton = button;
    
}

-(void)addTimeLabel{
    UILabel *timeLabel = [UILabel init];
    timeLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:timeLabel];
    
    timeLabel.textColor = UIColor.blackColor;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    NSLayoutConstraint *centerX = [timeLabel.centerXAnchor constraintEqualToAnchor:self.playPauseButton.centerXAnchor];
    
    NSLayoutConstraint *top = [timeLabel.topAnchor constraintEqualToAnchor:self.playPauseButton.bottomAnchor constant:8];
    
    centerX.active = true;
    top.active = true;
    
    self.timeLabel = timeLabel;
    [self updateTimeLabelText:0];
}

-(void)addProgressSlider{
    UISlider *slider = [UISlider init];
    slider.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:slider];
    
    slider.minimumTrackTintColor = UIColor.redColor;
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILayoutGuide *safeAreaGuide = [self.view safeAreaLayoutGuide];
    
    NSLayoutConstraint *centerX = [slider.centerXAnchor constraintEqualToAnchor:self.timeLabel.centerXAnchor];
    NSLayoutConstraint *top = [slider.topAnchor constraintEqualToAnchor:self.timeLabel.bottomAnchor constant:8];
    
    NSLayoutConstraint *leading = [slider.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:safeAreaGuide.leadingAnchor multiplier:16];
    NSLayoutConstraint *trailing = [slider.trailingAnchor constraintEqualToAnchor:safeAreaGuide.trailingAnchor constant:-16];
    
    centerX.active = true;
    top.active = true;
    leading.active = true;
    trailing.active = true;
    
    self.progressSlider = slider;
}

// MARK: AVAudioPlayerDelegate
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (error != nil) {
        NSLog(@"audio player decode error");
    }
    
    NSString *message = [NSString stringWithFormat:@"Audio Player got Error %@", error.localizedDescription];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.playPauseButton setSelected:false];
    self.progressSlider.value = 0;
    [self updateTimeLabelText:0];
    [self invalidateTimer];
}


// MARK: IBActions
- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self updateTimeLabelText:(NSTimeInterval)sender.value];
    if (sender.isTracking){
        return;
    }
    player.currentTime = (NSTimeInterval)sender.value;
}
- (IBAction)touchUpPlayPauseButton:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected){
        [player play];
    } else {
        [player pause];
    }
    
    if (sender.isSelected) {
        [self makeAndFireTimer];
    } else {
        [self invalidateTimer];
    }
    
}


@end
