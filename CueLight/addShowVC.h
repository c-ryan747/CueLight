//
//  addShowVC.h
//  CueLight
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textBoxTVC.h"

@interface addShowVC : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSMutableDictionary *showInfo;
@end
