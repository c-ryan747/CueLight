//
//  ListVC.h
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPController.h"
#import "ButtonView.h"

@interface ListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MPControllerDelegate>

@property (nonatomic, strong) NSMutableArray *cueList;
@property (nonatomic, strong) NSDictionary *showInfo;
@property (nonatomic, strong) MPController *mpController;
@property (nonatomic, strong) ButtonView *button;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
