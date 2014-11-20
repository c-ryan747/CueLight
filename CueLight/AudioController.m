//
//  AudioController.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "AudioController.h"


@interface AudioController () {
    NSNotificationCenter *_center;
}

@end

@implementation AudioController

#pragma mark - Init
//  Create only one instance of this class
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AudioController *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioController alloc] init];
        //  get recording permission from user
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL response){}];
        
        [sharedInstance setup];
    });
    
    return sharedInstance;
}

- (void)setup {
    _center = [NSNotificationCenter defaultCenter];
    
    //  Set the audio file
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.m4a"];
    NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];
    
    //  Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //  Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    //  Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

#pragma mark - Methods
- (void)stop {
    [self.recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void)playUrl:(NSURL *)url {
    //  if not recording, play audio and notify system
    if (!self.recorder.recording){
        [_center postNotificationName:CLStartedPlaying object:self];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

- (void)start {
    //  if not recording, start recording and notify system
    if (!self.recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [self.recorder record];
        
        [_center postNotificationName:CLStartedRecording object:self];
    }
}
- (void)sendToPeer:(MCPeerID *)peer {
    [[MPController sharedInstance] sendFile:self.recorder.url ToPeer:peer];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    //  notify system
    [_center postNotificationName:CLFinishedRecording object:self];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //  notify system
    [_center postNotificationName:CLFinishedPlaying object:self];
}


@end
