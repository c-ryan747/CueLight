//
//  TextBoxTVC.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "TextBoxTVC.h"

@implementation TextBoxTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, self.frame.size.width - 20, 30)];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.textField];
    }
    return self;
}

@end
