//
//  InShow.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "InShowVC.h"

@interface InShowVC ()

- (void)saveCues;
- (NSArray *)getNextThreeCues;

@end

@implementation InShowVC

@synthesize cueList = _cueList, button = _button, showIndex = _showIndex, currentCue = _currentCue, audioList = _audioList;

#pragma mark - Initlization and disconnect
- (void)setShowIndex:(int)showIndex {
    //  Update property
    _showIndex = showIndex;

    //  Get show data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *shows = [NSArray arrayWithArray:[defaults objectForKey:@"shows"]];
    NSDictionary *show = shows[showIndex];
    
    //  Update UI and temp storage
    self.title = show[@"showName"];
    self.cueList = [NSMutableArray arrayWithArray:show[@"cues"]];
    self.audioList = [NSMutableArray array];
    
    //  Create networking controller with show info
    self.mpController = [MPController sharedInstance];
    
    [self.mpController setupWithName:show[@"opRole"]];
    [self.mpController advertiseSelf:YES];
    self.mpController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  tableView setup
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CueTVC class] forCellReuseIdentifier:@"cueCell"];
    
    //  Create and setup button view
    self.button = [[ButtonView alloc]initWithFrame:CGRectMake(0,64, 320, 108)];
    self.button.delegate = self;
    
    [self.view addSubview:self.button];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //  Setup button view notification handlers
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:CLFinishedPlaying object:nil queue:nil usingBlock:^(NSNotification *notification) {
        if ([self.button.speakButtonState  isEqualToString:@"Playing"]) {
            if (self.audioList.count > 0) {
                self.button.speakButtonState = @"Received";
            } else {
                self.button.speakButtonState = @"Normal";
            }
        }
    }];
}

//  Disconnect from network when the view goes off screen
- (void)viewDidDisappear:(BOOL)animated {
    [self.mpController disconnect];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cueList.count+1;
}

//  if not last cell, create cue cell, else create add cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.cueList.count) {
        //  Create cue cell and populate with data
        CueTVC *cell = (CueTVC *)[tableView dequeueReusableCellWithIdentifier:@"cueCell"];
        cell.cueNum.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.textField.text = self.cueList[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        return cell;
    } else {
        // Create add cell from Main.storyboard
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        return cell;
    }
}

//  Can edit all rows apart from the last one (add cell)
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.cueList.count) {
        return NO;
    }
    return YES;
}

//  Add deletion behaviour
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //  Update local and persistent data
        [self.cueList removeObjectAtIndex:indexPath.row];
        [self saveCues];
        
        //  Update UI with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}

//  if last cell tapped, add new cue, save, then reload UI
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.cueList.count) {
        [self.cueList addObject:@""];
        [self saveCues];
        [self.tableView reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Go To Cue";
}

//  Handle "Go To Cue" button pressed
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Update UI
    [self.tableView setEditing:NO animated:YES];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //  Update data
    self.currentCue = (int)indexPath.row;
}

#pragma mark - Text field delegate methods
//  Update cue description and save changes
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cueList[textField.tag] = textField.text;
    [self saveCues];
}

//  Dismiss keyboard on return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Communication methods
//  When a singals recieved, vibrate and update UI
- (void)recievedMessage:(NSString *)data fromPeer:(MCPeerID *)peer {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.button nextState];
}

//  When audio is recieved, add to cue and update UI
- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer {
    [self.audioList addObject:url];
    if (![self.button.speakButtonState isEqualToString:@"Recording"] || ![self.button.speakButtonState isEqualToString:@"Playing"]) {
        self.button.speakButtonState = @"Received";
    }
}

//  Update to repersent if the controller is connected
- (void)controllerConnected:(BOOL)connected {
    if (connected) {
        self.currentCue = 0;
        [self.button setConnected:YES];
        [self.button resetState];
        
        //  Send the controller the most recent cues
        [self sendCuesToController];
    } else {
        [self.button setConnected:NO];
    }
}

- (void)sendCuesToController {
    [self.mpController sendObject:[self getNextThreeCues] ToPeers:@[self.mpController.controllerID]];
}

- (NSArray *)getNextThreeCues {
    //  Create filled empty array
    NSMutableArray *topThree = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    
    //  Loop from 0 to 2
    for (int i=0; i<3; i++) {
        //  Try and get data at offset (self.currentCue), if failed make sure its empty
        @try {
            NSString *text = self.cueList[self.currentCue + i];
            topThree[i] = [NSString stringWithFormat:@"%d. %@", i+1, text];
        } @catch (NSException *exception) {
            topThree[i] = @"";
        }
    }
    return topThree;
}

#pragma mark - Misc methods
//  Update the controller's state
- (void)sendNextState {
    [self.mpController sendObject:@"nextState" ToPeers:@[self.mpController.controllerID]];
    
    //  if starting new cycle
    if (self.button.stateCount == 0) {
        // if not on last cue, update UI and currentCue
        if (self.currentCue < self.cueList.count - 1 && self.cueList.count != 0) {
            self.currentCue++;
            [self.tableView setEditing:NO animated:YES];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentCue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        //  Send controller updated cues
        [self sendCuesToController];
    }
}

#warning Not finished
//  Handle audio button data
- (void)speakButtonPressed {
    AudioController *ac = [AudioController sharedInstance];
    
    if (ac.recorder.recording) {
        if (self.audioList.count > 0) {
            self.button.speakButtonState = @"Received";
        } else {
            self.button.speakButtonState = @"Normal";
        }
        
        [ac stop];
        [ac sendToPeer:self.mpController.controllerID];
    } else if (ac.player.playing) {
        if (self.audioList.count > 0) {
            self.button.speakButtonState = @"Received";
        } else {
            self.button.speakButtonState = @"Normal";
        }
        
        [ac.player stop];
    } else if ([self.button.speakButtonState isEqualToString:@"Normal"]) {
        self.button.speakButtonState = @"Recording";
        
        [ac start];
    } else if ([self.button.speakButtonState isEqualToString:@"Received"]) {
        self.button.speakButtonState = @"Playing";
        
        [ac playUrl:self.audioList[0]];
        [self.audioList removeObjectAtIndex:0];
    }
}

//  Update persistent storage
- (void)saveCues {
    //  Get storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
    NSMutableDictionary *show = [NSMutableDictionary dictionaryWithDictionary:shows[self.showIndex]];
    
    //  Overwrite and save
    [show setObject:self.cueList forKey:@"cues"];
    [shows replaceObjectAtIndex:self.showIndex withObject:show];
    [defaults setObject:shows forKey:@"shows"];
    [defaults synchronize];
    
}

@end
