//
//  AudioController.m
//  CueLight
//
//  Created by Callum Ryan on 07/09/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "AudioController.h"


@interface AudioController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation AudioController

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AudioController *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioController alloc] init];
    });
    return sharedInstance;
}

- (void)setup
{
    
    // Disable Stop/Play button when application launches
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:NO];
    
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
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}


- (void)stop
{
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void)play
{
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (void)start
{
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
//        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}
- (void)sendToPeer:(MCPeerID *)peer
{
    [[MPController sharedInstance] sendFile:recorder.url ToPeer:peer];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //recording finished
}


@end
