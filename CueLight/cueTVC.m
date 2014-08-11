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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cueNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
//        self.cueNum.textColor = [UIColor whiteColor];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 7, 230, 30)];
        self.textField.delegate = self;
//        self.textField.textColor = [UIColor whiteColor];
    
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.cueNum];
        
        
//        UIView *vertBar = [[UIView alloc] initWithFrame:CGRectMake(59.5, 0, 1, 44)];
//        vertBar.backgroundColor = [UIColor whiteColor];
//       
//        [self.contentView addSubview:vertBar];
//        
//        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
