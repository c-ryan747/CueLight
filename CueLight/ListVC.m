//
//  ListVC.m
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "ListVC.h"

@interface ListVC ()
@end

@implementation ListVC
@synthesize cueList, button, showIndex = _showIndex, currentCue = _currentCue, audioList = _audioList;

#pragma mark - Initlization and disconnect
- (void)setShowIndex:(int)showIndex {
    _showIndex = showIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *shows = [NSArray arrayWithArray:[defaults objectForKey:@"shows"]];
    NSDictionary *show = shows[showIndex];
    self.title = show[@"showName"];
    
    self.cueList = [NSMutableArray arrayWithArray:show[@"cues"]];
    
    
    self.mpController = [MPController sharedInstance];
    
    [self.mpController setupIfNeededWithName:show[@"opRole"]];
    [self.mpController advertiseSelf:YES];
    self.mpController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[cueTVC class] forCellReuseIdentifier:@"cueCell"];
    
    self.button = [[ButtonView alloc]initWithFrame:CGRectMake(0,64, 320, 108)];
    self.button.delegate = self;
    [self.button setConnected:NO];
    
    [self.view addSubview:self.button];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.mpController disconnect];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cueList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.cueList.count) {
        cueTVC *cell = (cueTVC *)[tableView dequeueReusableCellWithIdentifier:@"cueCell"];
        cell.cueNum.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.textField.text = self.cueList[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        return cell;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.cueList.count) {
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.cueList removeObjectAtIndex:indexPath.row];
        [self saveCues];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}

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

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView setEditing:NO animated:YES];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Text field delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cueList[textField.tag] = textField.text;
    [self saveCues];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Communication methods
- (void)recievedMessage:(NSData *)data fromPeer:(MCPeerID *)peer {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.button nextState];
}

- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer {
    [[AudioController sharedInstance] playUrl:url];;
}

- (void)controllerConnected:(BOOL)connected {
    if (connected) {
        self.currentCue = 0;
        [self.button setConnected:YES];
        [self.button resetState];
        [self sendCuesToController];
    } else {
        [self.button setConnected:NO];
    }
}

- (NSArray *)getNextThreeCues {
    NSMutableArray *topThree = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    for (int i=0; i<3; i++) {
        @try {
            NSString *text = self.cueList[self.currentCue + i];
            topThree[i] = [NSString stringWithFormat:@"%d. %@", i+1, text];
        }
        @catch (NSException *exception) {
            topThree[i] = @"";
        }
    }
    return topThree;
}

- (void)sendCuesToController {
    
    [self.mpController sendObject:[self getNextThreeCues] ToPeers:@[self.mpController.controllerID]];
}

#pragma mark - Misc methods
- (void)sendNextState {
    [self.mpController sendObject:@"nextState" ToPeers:@[self.mpController.controllerID]];
    if (self.button.stateCount == 0) {
        if (self.currentCue < self.cueList.count -1) {
            self.currentCue++;
            [self.tableView setEditing:NO animated:YES];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentCue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self sendCuesToController];
    }
}

- (void)speakButtonPressed {
    AudioController *ac = [AudioController sharedInstance];
    if (!ac.recorder.recording && !ac.player.playing) {
        if (self.audioList.count != 0) {
            [ac playUrl:self.audioList[0]];
            [self.audioList removeObjectAtIndex:0];
        } else {
            [ac start];
        }
    } else if (ac.recorder.recording) {
        [ac stop];
        [ac sendToPeer:[MPController sharedInstance].controllerID];
    }
}

- (void)saveCues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *shows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"shows"]];
    NSMutableDictionary *show = [NSMutableDictionary dictionaryWithDictionary:shows[self.showIndex]];
    [show setObject:self.cueList forKey:@"cues"];
    
    [shows replaceObjectAtIndex:self.showIndex withObject:show];
    [defaults setObject:shows forKey:@"shows"];
    [defaults synchronize];
    
}

@end
