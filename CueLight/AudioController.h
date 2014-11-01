//
//  AudioController.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : Singleton to handle audio
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MPController.h"
#import "Constants.m"

@interface AudioController : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

//  iOS audio controllers
@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) AVAudioPlayer *player;

//  singleton access
+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;
- (void)playUrl:(NSURL *)url;
- (void)sendToPeer:(MCPeerID *)peer;

@end
