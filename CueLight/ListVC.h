//
//  ListVC.h
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#import "MPController.h"
#import "ButtonView.h"

@interface ListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MPControllerDelegate, UITextFieldDelegate, ButtonViewDelegate>

@property (nonatomic, strong) NSMutableArray *cueList;
@property (nonatomic        ) int showIndex;
@property (nonatomic        ) int currentCue;
@property (nonatomic, strong) MPController *mpController;
@property (nonatomic, strong) IBOutlet ButtonView *button;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)saveCues;
- (void)setShowIndex:(int)showIndex;

@end
