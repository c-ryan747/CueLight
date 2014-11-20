//
//  InShow.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UITableViewController responsible for handling the UI while during a show
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#import "MPController.h"
#import "ButtonView.h"
#import "InShowVC.h"
#import "CueTVC.h"

@interface InShowVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MPControllerDelegate, UITextFieldDelegate, ButtonViewDelegate>

//  Array containing cue information
//  -> cueList - Array
//      -> cue description - String

@property NSMutableArray *cueList;

//  Array containing references to all unpaid audio
//  -> audioList - Array
//      -> audio files - NSURL

@property NSMutableArray *audioList;

@property MPController *mpController;
@property ButtonView *button;
@property int currentCue;
@property (nonatomic)       int showIndex;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

//  Method called after creation to inform view of show information
- (void)setShowIndex:(int)showIndex;

@end
