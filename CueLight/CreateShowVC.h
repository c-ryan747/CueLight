//
//  CreateShowVC.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UITableViewController responsible for handling the UI while creating a new show
//

#import <UIKit/UIKit.h>
#import "TextBoxTVC.h"

@interface CreateShowVC : UITableViewController <UITextFieldDelegate>

//  Dictionary containing show information
//  -> showInfo - Dictionary
//      -> showName - String
//      -> opRole - String

@property (strong, nonatomic) NSMutableDictionary *showInfo;

@end
