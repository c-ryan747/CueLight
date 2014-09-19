//
//  AudioController.m
//  CueLight
//
//  Created by Callum Ryan on 07/09/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "AudioController.h"


@interface AudioController () {
    NSNotificationCenter *_center;
}

@end

@implementation AudioController
@synthesize recorder, player;

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AudioController *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioController alloc] init];
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL response){
            NSLog(@"Allow microphone use response: %d", response);
        }];
        [sharedInstance setup];
    });
    
    return sharedInstance;
}

- (void)setup {
    
    // Disable Stop/Play button when application launches
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:NO];
    _center = [NSNotificationCenter defaultCenter];
    
    // Set the audio file
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.m4a"];
    NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];

    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}


- (void)stop {
    [self.recorder stop];
    NSLog(@"Stoped playing");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void)playUrl:(NSURL *)url {
    if (!self.recorder.recording){
        NSLog(@"Playing");
        [_center postNotificationName:CLStartedPlaying object:self];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

- (void)start {
    if (!self.recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        NSLog(@"Start recording");
        [_center postNotificationName:CLStartedRecording object:self];
        
        [self.recorder record];
//        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}
- (void)sendToPeer:(MCPeerID *)peer {
    [[MPController sharedInstance] sendFile:recorder.url ToPeer:peer];
}

- (BOOL)canRecord {
    return YES;
}
#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    NSLog(@"Finished recording");
    [_center postNotificationName:CLFinishedRecording object:self];
//    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"Finished playing");
    [_center postNotificationName:CLFinishedPlaying object:self];
}


@end
