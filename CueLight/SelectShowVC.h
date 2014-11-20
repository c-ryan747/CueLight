//
//  SelectShowVC.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UITableViewController responsible for handling the UI while selecting a show
//

#import <UIKit/UIKit.h>
#import "InShowVC.h"

@interface SelectShowVC : UITableViewController

//  Array containing information about all shows
//  -> shows - Array
//      -> showInfo - Dictionary
//          -> showName - String
//          -> opRole - String

@property NSMutableArray *shows;

@end
