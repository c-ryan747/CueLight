//
//  AudioController.h
//  CueLight
//
//  Created by Callum Ryan on 07/09/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MPController.h"
#import "Constants.m"

@interface AudioController : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) AVAudioPlayer *player;

+(instancetype)sharedInstance;
- (void)start;
- (void)stop;
- (void)playUrl:(NSURL *)url;
- (void)sendToPeer:(MCPeerID *)peer;
- (BOOL)canRecord;
@end
