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
    
    //  Create networking controller with show info
    self.mpController = [MPController sharedInstance];
    
    [self.mpController setupIfNeededWithName:show[@"opRole"]];
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
#warning Not finished
- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer {
    [[AudioController sharedInstance] playUrl:url];
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
        if (self.currentCue < self.cueList.count -1) {
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
    //  if normal
    if (!ac.recorder.recording && !ac.player.playing) {
        // if audio left, play it, else start recoring
        if (self.audioList.count != 0) {
            [ac playUrl:self.audioList[0]];
            [self.audioList removeObjectAtIndex:0];
        } else {
            [ac start];
        }
    //  else if  recording, stop recoding and send audio to controller
    } else if (ac.recorder.recording) {
        [ac stop];
        [ac sendToPeer:[MPController sharedInstance].controllerID];
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
