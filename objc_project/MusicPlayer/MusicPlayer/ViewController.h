//
//  ViewController.h
//  MusicPlayer
//
//  Created by 김동규 on 25/09/2019.
//  Copyright © 2019 김동규. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>
// MARK: IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

// MARK: Methods
// MARK: Custom Method
-(void)initializePlayer;
-(void)updateTimeLabelText:(NSTimeInterval)time;
-(void)makeAndFireTimer;
-(void)invalidateTimer;
-(void)addViewsWithCode;
-(void)addPlayPauseButton;
-(void)addTimeLabel;
-(void)addProgressSlider;
-(void)timerMethod:(NSTimer*)timer;

// MARK: IBActions
- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)touchUpPlayPauseButton:(UIButton *)sender;

// MARK: AVAudioPlayerDelegate
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
@end

