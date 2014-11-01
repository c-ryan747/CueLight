//
//  CueTVC.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UITableViewCell subclass that adds a number on the left and text field on the right
//

#import <UIKit/UIKit.h>

@interface CueTVC : UITableViewCell <UITextFieldDelegate>

@property UITextField *textField;
@property UILabel *cueNum;

@end
