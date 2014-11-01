//
//  CueTVC.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "CueTVC.h"

@implementation CueTVC

@synthesize cueNum = _cueNum, textField = _textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cueNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
        
        //  Make textfield fill rest of cell
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 7, self.frame.size.width - 90, 30)];
        self.textField.returnKeyType = UIReturnKeyDone;
    
        //  Add views
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.cueNum];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
