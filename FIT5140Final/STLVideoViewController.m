//
//  STLVideoViewController.m
//  STLBGVideo
//
//  Created by StoneLeon on 16/1/13.
//  Copyright © 2016年 StoneLeon. All rights reserved.
//

#import "STLVideoViewController.h"
#import "STLVideoFunctions.h"


#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface STLVideoViewController ()

@property (nonatomic,strong) AVPlayerViewController *playerController;

@property (nonatomic,strong) AVAudioSession *avaudioSession;

@property (nonatomic,assign) BOOL isLoop;

@end

@implementation STLVideoViewController

#pragma mark - allow background music still play
- (void)stillPlayMusic {

    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
}

#pragma mark - Player
- (void)getPlayerNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.playerController.player currentItem]];
    
}

- (void)preparePlayback {
    if (self.playerController == nil) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[STLVideoFunctions getVideoUrl] ofType:[STLVideoFunctions getVideoType]]];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        self.playerController = [[AVPlayerViewController alloc]init];
        self.playerController.player = player;
//        [self.playerController setControlStyle:MPMovieControlStyleNone];
//        [self.playerController.player prepareToPlay];
        self.playerController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.playerController.showsPlaybackControls = false;
        [self.playerController.view setFrame:self.view.frame];
        [self.view addSubview:self.playerController.view];
        [self.view sendSubviewToBack:self.playerController.view];
        
//        self.playerController.scalingMode = MPMovieScalingModeAspectFill;

    }

}

#pragma mark - Notifications
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self stillPlayMusic];

    if ([STLVideoFunctions getUrlInfo] != nil) {
        self.isLoop = [STLVideoFunctions getLoopMode];
        
        [self preparePlayback];
    }
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self getPlayerNotifications];
    
    [self.playerController.player play];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [self.playerController.player pause];
}
@end
