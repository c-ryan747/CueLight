//
//  textBoxTVC.m
//  CueLight
//
//  Created by Callum Ryan on 15/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "textBoxTVC.h"

@implementation textBoxTVC
@synthesize textField;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, 300, 30)];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.textField];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
