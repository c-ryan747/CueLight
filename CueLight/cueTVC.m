//
//  cueTVC.m
//  CueLight
//
//  Created by Callum Ryan on 30/07/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "cueTVC.h"

@implementation cueTVC
@synthesize cueNum, textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cueNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 7, 230, 30)];
        self.textField.returnKeyType = UIReturnKeyDone;
    
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.cueNum];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
