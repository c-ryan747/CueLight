//
//  showVC.h
//  CueLight
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *shows;

- (IBAction)addBlankShow:(id)sender;

@end